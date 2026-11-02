import 'package:flutter_test/flutter_test.dart';
import 'package:tram/controller/form_depot/common/inspection_submission_coordinator.dart';
import 'package:tram/controller/form_depot/common/inspection_validation.dart';
import 'package:tram/controller/form_depot/common/inspection_workflow_state.dart';
import 'package:tram/controller/form_depot/form_B_controller.dart';
import 'package:tram/controller/form_depot/form_C_controller.dart';
import 'package:tram/controller/form_depot/form_G_controller.dart';
import 'package:tram/controller/form_depot/form_R_controller.dart';
import 'package:tram/model/shared/draft_status_model.dart';
import 'package:tram/screen/form_depot/common/form_depot_registry.dart';

void main() {
  test('workflow state prevents duplicate submissions and overlapping saves',
      () {
    final state = InspectionWorkflowState.fromArguments({
      'draftId': '42',
      'isResumeDraft': true,
    });

    expect(state.activeDraftId, 42);
    expect(state.isResumeDraft, isTrue);
    expect(state.beginSubmission(), isTrue);
    expect(state.beginSubmission(), isFalse);
    expect(state.beginDraftSave(), isFalse);
    expect(state.beginDraftSave(allowDuringSubmission: true), isTrue);
    state.endDraftSave();
    state.endSubmission();
    state.submissionCompleted = true;
    expect(state.beginSubmission(), isFalse);
    expect(state.beginDraftSave(), isFalse);
  });

  test(
      'submission coordinator saves a pending-sync draft after partial failure',
      () async {
    String? resolvedID;
    DraftStatus? fallbackStatus;
    var mainCalls = 0;
    final coordinator = InspectionSubmissionCoordinator(
      afterMainSubmitDelay: Duration.zero,
    );

    final result = await coordinator.submit(
      submitMain: () async {
        mainCalls++;
        return {'recID': 'inspection-9'};
      },
      resolveInspectionID: (response) => resolveGeneralInspectionID(
        response,
        formType: 'G',
      ),
      onInspectionIDResolved: (value) => resolvedID = value,
      submitSupplementary: (_, __) async {
        throw StateError('photo upload failed');
      },
      saveFallback: (status, _) async {
        fallbackStatus = status;
        return true;
      },
    );

    expect(mainCalls, 1);
    expect(resolvedID, 'inspection-9');
    expect(result.completed, isFalse);
    expect(result.savedForRetry, isTrue);
    expect(result.inspectionID, 'inspection-9');
    expect(fallbackStatus, DraftStatus.pendingSync);
  });

  test(
      'submission coordinator resumes auxiliary work without another main POST',
      () async {
    var mainCalls = 0;
    var resumedExistingUploads = false;
    final coordinator = InspectionSubmissionCoordinator(
      afterMainSubmitDelay: Duration.zero,
    );

    final result = await coordinator.submit(
      existingInspectionID: 'inspection-9',
      submitMain: () async {
        mainCalls++;
        return {'recID': 'duplicate'};
      },
      resolveInspectionID: (_) => 'duplicate',
      onInspectionIDResolved: (_) {},
      submitSupplementary: (_, resumeExistingUploads) async {
        resumedExistingUploads = resumeExistingUploads;
      },
      saveFallback: (_, __) async => false,
    );

    expect(mainCalls, 0);
    expect(resumedExistingUploads, isTrue);
    expect(result.completed, isTrue);
    expect(result.inspectionID, 'inspection-9');
  });

  test('common validation returns the same photo and approval errors', () {
    expect(
      commonInspectionValidationErrors(
        photoCount: 0,
        photoLimit: 20,
        photosMissingRemarks: const [],
        investigation: '',
      ),
      [
        'At least one photograph is required.',
        'Approval details are missing.',
      ],
    );

    expect(
      commonInspectionValidationErrors(
        photoCount: 21,
        photoLimit: 20,
        photosMissingRemarks: const [2, 5],
        investigation: 'checked',
      ),
      [
        'A maximum of 20 photographs is allowed.',
        'Remarks are required for: Photo 2, Photo 5.',
      ],
    );
  });

  test('form registry owns every editor route and controller type', () {
    final expected = <String, (Type, Set<String>)>{
      'B': (
        FormBController,
        {'record', 'inspection', 'review_B1', 'review_B2'},
      ),
      'C': (
        FormCController,
        {'record', 'inspection', 'review_C1', 'review_C2'},
      ),
      'G': (
        FormGController,
        {'record', 'inspection', 'review_G1', 'review_G2'},
      ),
      'R': (
        FormRController,
        {'record', 'inspection', 'review_R1', 'review_R2'},
      ),
    };

    for (final entry in expected.entries) {
      final module = FormDepotRegistry.moduleFor(entry.key);
      expect(module, isNotNull);
      expect(module!.controllerType, entry.value.$1);
      expect(module.pages.keys.toSet(), entry.value.$2);
      for (final page in entry.value.$2) {
        expect(FormDepotRegistry.moduleForRoute(entry.key, page), same(module));
      }
    }
    expect(FormDepotRegistry.moduleForRoute('B', 'review_C1'), isNull);
    expect(FormDepotRegistry.moduleFor('unknown'), isNull);
  });
}
