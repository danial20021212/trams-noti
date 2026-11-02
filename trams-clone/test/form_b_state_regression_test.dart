import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tram/binding/form_depot/base_form_binding.dart';
import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/controller/form_depot/common/base_form_controller.dart';
import 'package:tram/controller/form_depot/form_draft_controller.dart';
import 'package:tram/controller/form_depot/form_B_controller.dart';
import 'package:tram/controller/form_depot/form_C_controller.dart';
import 'package:tram/controller/form_depot/main_listing/main_listing_details_controller.dart';
import 'package:tram/model/form/form_depot/common/form_2_model.dart';
import 'package:tram/model/form/form_depot/common/remarks_model.dart';
import 'package:tram/model/form/form_depot/form_B/form_B_model.dart';
import 'package:tram/model/form/form_depot/form_draft/form_draft_model.dart';
import 'package:tram/model/form/form_depot/main_listing/form_main_listing_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/provider/api_provider.dart';

class _TestAuthController extends AuthController {
  @override
  String? getUserType() => 'Service Provider';
}

class _RecordingDetailsController extends MainListingDetailsController {
  int loadCalls = 0;

  @override
  // Avoid loading route data; tests populate the context directly.
  // ignore: must_call_super
  void onInit() {}

  @override
  Future<void> load() async {
    loadCalls++;
  }
}

class _RecordingDraftController extends FormDraftController {
  _RecordingDraftController({this.updateResult = 1});

  final int updateResult;
  int insertCalls = 0;
  int updateCalls = 0;
  final List<int> deletedIds = [];
  FormDraft? lastDraft;

  // Avoid opening SQLite; persistence is recorded in-memory in this test.
  @override
  // ignore: must_call_super
  void onInit() {}

  @override
  Future<int> insertDraft(FormDraft draft) async {
    insertCalls++;
    lastDraft = draft;
    return 41;
  }

  @override
  Future<int> updateDraft(FormDraft draft) async {
    updateCalls++;
    lastDraft = draft;
    return updateResult;
  }

  @override
  Future<int> deleteDraft(int id) async {
    deletedIds.add(id);
    drafts.removeWhere((draft) => draft.id == id);
    return 1;
  }

  @override
  Future<void> fetchAllDrafts() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          pathProviderChannel, (_) async => '/private/tmp');

  setUp(() {
    Get.testMode = true;
    Get.reset();
    Get.put<AuthController>(_TestAuthController());
    Get.put<ApiProvider>(ApiProvider());
    Get.routing.args = {
      'formType': 'B',
      'formPage': 'inspection',
      'isResumeDraft': true,
    };
  });

  tearDown(Get.reset);

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  test('clears Form B answers but retains parent context after submission', () {
    final baseController = Get.put<BaseFormController>(BaseFormController());
    final controller = FormBController();
    controller.form = FormBModel(
      recID: 'inspection-1',
      parentID: 'bridge-1',
      inspectionDate: '2026-09-11',
      packageID: 'package-1',
      districtID: 'district-1',
      roadID: 'road-1',
      roadName: 'Road One',
      bridgeName: 'Bridge One',
      referenceNo: 'B-001',
      p1Materials: const ['C'],
      p1Distress: 'P01',
      p1Severity: '3',
    ).obs;
    controller.useCurrentLocation.value = true;
    baseController.photoToUpload.assign(
      XFile.fromData(Uint8List.fromList([1, 2, 3]), name: 'photo1.jpg'),
    );
    baseController.photoRemarks.value = ['previous photo'];
    baseController.formRemarks.value = RemarksModel(data: [
      Remarks(
        recID: 'inspection-1',
        spRemarksPartB: 'previous distress',
        consRemarksPartB: '',
        spRemarksPartC: 'previous comment',
        consRemarksPartC: '',
        spRemarksPartD: 'previous feedback',
        consRemarksPartD: '',
      ),
    ]);
    baseController.form.value = Form2Model(
      investigation: 'previous approval',
      ecSignAgree: 'agree',
    );
    controller.memberCheckboxes['P1'] = false;

    controller.resetEditorStateAfterSuccessfulSubmission();

    expect(controller.form.value.recID, isNull);
    expect(controller.form.value.parentID, 'bridge-1');
    expect(controller.form.value.inspectionDate, isNull);
    expect(controller.form.value.packageID, 'package-1');
    expect(controller.form.value.districtID, 'district-1');
    expect(controller.form.value.roadID, 'road-1');
    expect(controller.form.value.referenceNo, 'B-001');
    expect(controller.form.value.toApiSubmitJson()['parentID'], 'bridge-1');
    expect(controller.form.value.p1Materials, isNull);
    expect(controller.memberCheckboxes.values, everyElement(isTrue));
    expect(controller.useCurrentLocation.value, isFalse);
    expect(controller.isResumeDraft, isFalse);
    expect(baseController.photoToUpload, isEmpty);
    expect(baseController.photoRemarks, hasLength(8));
    expect(baseController.photoRemarks, everyElement(isEmpty));
    expect(baseController.formRemarks.value.data!.single.recID, isEmpty);
    expect(baseController.getSpRemarkPartB, isEmpty);
    expect(baseController.getInvestigation, isEmpty);
  });

  test('reloads the inspection list for every successful editor result',
      () async {
    final controller = _RecordingDetailsController();

    await controller.refreshAfterEditorResult(true);
    await controller.refreshAfterEditorResult(true);
    await controller.refreshAfterEditorResult(null);

    expect(controller.loadCalls, 2);
  });

  test('orders Form B inspections by newest date then newest record ID', () {
    final controller = MainListingDetailsController();
    final records = [
      FormMainListingModel.fromJson({
        'recID': '50',
        'inspection_date': '2026-08-31',
      }),
      FormMainListingModel.fromJson({
        'recID': '9',
        'inspection_date': '2026-09-15',
      }),
      FormMainListingModel.fromJson({
        'recID': '10',
        'inspection_date': '2026-09-15',
      }),
      FormMainListingModel.fromJson({
        'recID': '999',
        'inspection_date': 'invalid-date',
      }),
    ];

    controller.sortInspectionRecordsNewestFirst(records);

    expect(records.map((record) => record.recID), ['10', '9', '50', '999']);
  });

  test('finds Form B drafts by parent ID when reference number is empty',
      () async {
    final draftController =
        Get.put<FormDraftController>(_RecordingDraftController())
            as _RecordingDraftController;
    draftController.drafts.assignAll([
      FormDraft(
        id: 1,
        formType: 'Form B',
        formData: '{"parentID":"355415","referenceNo":""}',
        createdAt: '2026-09-15T00:00:00Z',
        updatedAt: '2026-09-15T00:00:00Z',
      ),
      FormDraft(
        id: 2,
        formType: 'Form B',
        formData: '{"parentID":"another-bridge","referenceNo":""}',
        createdAt: '2026-09-15T00:00:00Z',
        updatedAt: '2026-09-15T00:00:00Z',
      ),
      FormDraft(
        id: 3,
        formType: 'Form C',
        formData: '{"parentID":"355415","referenceNo":""}',
        createdAt: '2026-09-15T00:00:00Z',
        updatedAt: '2026-09-15T00:00:00Z',
      ),
    ]);
    final controller = MainListingDetailsController()..formType = 'B';

    await controller.fetchMatchingDrafts('', parentID: '355415');

    expect(controller.localDrafts.map((draft) => draft.id), [1]);
  });

  test('new Form B draft keeps its ID and subsequent saves update it',
      () async {
    Get.routing.args = {
      'formType': 'B',
      'formPage': 'inspection',
      'isResumeDraft': false,
    };
    final drafts = Get.put<FormDraftController>(_RecordingDraftController())
        as _RecordingDraftController;
    final details =
        Get.put<MainListingDetailsController>(_RecordingDetailsController())
            as _RecordingDetailsController
          ..packageID = '1'
          ..districtID = ''
          ..routeID = ''
          ..packageName = 'Package One'
          ..districtName = 'Kapit'
          ..roadName = 'Q3217';
    Get.put<BaseFormController>(BaseFormController());
    final controller = FormBController()
      ..form = FormBModel(
        parentID: 'bridge-1',
        inspectionDate: '2026-09-15',
        referenceNo: 'B-001',
      ).obs;

    expect(await controller.saveDraft(navigateAfterSave: false), isTrue);
    expect(Get.arguments['draftId'], 41);
    expect(Get.arguments['isResumeDraft'], isTrue);
    expect(controller.isResumeDraft, isTrue);
    final savedData =
        jsonDecode(drafts.lastDraft!.formData) as Map<String, dynamic>;
    expect(savedData['districtName'], 'Kapit');
    expect(savedData['roadName'], 'Q3217');
    expect(details.loadCalls, 0);

    expect(await controller.saveDraft(navigateAfterSave: false), isTrue);
    expect(drafts.insertCalls, 1);
    expect(drafts.updateCalls, 1);
    expect(drafts.lastDraft?.id, 41);
  });

  test('Form B member checkboxes clear excluded primary and secondary data',
      () {
    Get.put<BaseFormController>(BaseFormController());
    final controller = FormBController()
      ..form = FormBModel(
        p1Materials: const ['RC'],
        p1MaterialOther: 'primary material',
        p1Distress: 'P01',
        p1DistressOther: 'primary distress',
        p1Severity: '3',
        s7Materials: const ['O'],
        s7MaterialOther: 'secondary material',
        s7Distress: 'OTH',
        s7DistressOther: 'secondary distress',
        s7Severity: '4',
      ).obs;

    controller.toggleMember('P1');
    controller.toggleMember('S7');

    expect(controller.isMemberChecked('P1'), isFalse);
    expect(controller.isMemberChecked('S7'), isFalse);
    expect(controller.form.value.p1Materials, isEmpty);
    expect(controller.form.value.p1MaterialOther, isNull);
    expect(controller.form.value.p1Distress, isNull);
    expect(controller.form.value.p1DistressOther, isNull);
    expect(controller.form.value.p1Severity, isNull);
    expect(controller.form.value.s7Materials, isEmpty);
    expect(controller.form.value.s7MaterialOther, isNull);
    expect(controller.form.value.s7Distress, isNull);
    expect(controller.form.value.s7DistressOther, isNull);
    expect(controller.form.value.s7Severity, isNull);

    controller.toggleMember('P1');
    expect(controller.isMemberChecked('P1'), isTrue);
    expect(controller.form.value.p1Materials, isEmpty);
  });

  test('Form B draft stores checkbox states and blank excluded member fields',
      () async {
    Get.routing.args = {
      'formType': 'B',
      'formPage': 'inspection',
      'isResumeDraft': false,
    };
    final drafts = Get.put<FormDraftController>(_RecordingDraftController())
        as _RecordingDraftController;
    Get.put<BaseFormController>(BaseFormController());
    final controller = FormBController()
      ..form = FormBModel(
        parentID: 'bridge-1',
        inspectionDate: '2026-09-26',
        p1Materials: const ['RC'],
        p1Distress: 'P01',
        p1Severity: '3',
        s7Materials: const ['O'],
        s7MaterialOther: 'Masonry',
        s7Distress: 'OTH',
        s7DistressOther: 'Cracking',
        s7Severity: '4',
      ).obs;
    controller.toggleMember('P1');
    controller.toggleMember('S7');

    expect(await controller.saveDraft(navigateAfterSave: false), isTrue);

    final savedData =
        jsonDecode(drafts.lastDraft!.formData) as Map<String, dynamic>;
    final checkboxData = savedData['member_checkboxes'] as Map<String, dynamic>;
    expect(checkboxData['P1'], isFalse);
    expect(checkboxData['P2'], isTrue);
    expect(checkboxData['S7'], isFalse);
    for (final prefix in ['p1', 's7']) {
      expect(savedData['${prefix}_material'], isEmpty);
      expect(savedData['${prefix}_material_other'], isEmpty);
      expect(savedData['${prefix}_distress'], isEmpty);
      expect(savedData['${prefix}_other_distress'], isEmpty);
      expect(savedData['${prefix}_severity'], isEmpty);
    }
  });

  test('Form B does not report success when a draft update changes no row',
      () async {
    Get.routing.args = {
      'formType': 'B',
      'formPage': 'inspection',
      'isResumeDraft': true,
      'draftId': 7,
    };
    final drafts = Get.put<FormDraftController>(
      _RecordingDraftController(updateResult: 0),
    ) as _RecordingDraftController;
    Get.put<BaseFormController>(BaseFormController());
    final controller = FormBController()
      ..form = FormBModel(
        parentID: 'bridge-1',
        inspectionDate: '2026-09-15',
        referenceNo: 'B-001',
      ).obs;

    expect(await controller.saveDraft(navigateAfterSave: false), isFalse);
    expect(drafts.updateCalls, 1);
    expect(controller.state.value, LoaderState.failure);
  });

  test('Form B removes the submitted draft even if route arguments change',
      () async {
    Get.routing.args = {
      'formType': 'B',
      'formPage': 'inspection',
      'isResumeDraft': true,
      'draftId': 73,
    };
    final drafts = Get.put<FormDraftController>(_RecordingDraftController())
        as _RecordingDraftController;
    Get.put<BaseFormController>(BaseFormController());
    final controller = FormBController()..form = FormBModel().obs;

    // Dialogs and subsequent navigation can replace Get.arguments. The
    // controller must retain the draft identity it opened with.
    Get.routing.args = <String, dynamic>{};
    await controller.removeSubmittedDraft();

    expect(drafts.deletedIds, [73]);
    expect(controller.isResumeDraft, isFalse);
  });

  test('Form B editor does not register a placeholder details controller', () {
    expect(Get.isRegistered<MainListingDetailsController>(), isFalse);

    BaseFormBinding().dependencies();

    expect(Get.isRegistered<MainListingDetailsController>(), isFalse);
  });

  test('Add New Inspection replaces stale Form B review controllers', () {
    Get.routing.args = {
      'formType': 'B',
      'formPage': 'review_B2',
      'recID': 'viewed-inspection-1',
      'status': 'Approved',
    };
    final viewedBaseController = Get.put<BaseFormController>(
      BaseFormController(),
    );
    final viewedFormController = Get.put<FormBController>(FormBController());
    viewedBaseController.configureContext(
      formType: 'B',
      recID: 'viewed-inspection-1',
      reviewMode: true,
    );

    Get.routing.args = {
      'formType': 'B',
      'formPage': 'inspection',
      'parentID': 'bridge-2',
      'recID': 'bridge-2',
      'inspectionDate': DateTime(2026, 9, 12),
      'previousRecID': '',
    };
    BaseFormBinding().dependencies();

    final insertBaseController = Get.find<BaseFormController>();
    expect(viewedFormController.isClosed, isTrue);
    expect(identical(insertBaseController, viewedBaseController), isFalse);
    expect(insertBaseController.isReviewMode.value, isFalse);
    expect(insertBaseController.recID, 'bridge-2');
    expect(insertBaseController.photoLinks, isEmpty);
    expect(insertBaseController.photoToUpload, isEmpty);
  });

  test('shared binding disposes the previous editor across form types', () {
    Get.routing.args = {
      'formType': 'B',
      'formPage': 'review_B2',
      'recID': 'bridge-inspection-1',
    };
    BaseFormBinding().dependencies();
    final firstBaseController = Get.find<BaseFormController>();
    final firstEditor = Get.find<FormBController>();

    Get.routing.args = {
      'formType': 'C',
      'formPage': 'inspection',
      'recID': 'culvert-parent-1',
      'inspectionDate': DateTime(2026, 9, 12),
      'previousRecID': '',
    };
    BaseFormBinding().dependencies();

    final secondBaseController = Get.find<BaseFormController>();
    expect(firstEditor.isClosed, isTrue);
    expect(identical(firstBaseController, secondBaseController), isFalse);
    expect(Get.isRegistered<FormCController>(), isTrue);
  });
}
