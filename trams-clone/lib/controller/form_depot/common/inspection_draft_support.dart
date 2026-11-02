import 'dart:convert';

import 'package:image_picker/image_picker.dart';

import '../../../model/form/form_depot/common/form_2_model.dart';
import '../../../model/form/form_depot/common/remarks_model.dart';
import '../../../model/form/form_depot/form_draft/form_draft_model.dart';
import '../../../model/shared/draft_status_model.dart';
import '../form_draft_controller.dart';
import 'base_form_controller.dart';

class RestoredCommonDraftState {
  const RestoredCommonDraftState({
    required this.useCurrentLocation,
    this.submittedInspectionID,
  });

  final bool useCurrentLocation;
  final String? submittedInspectionID;
}

class InspectionDraftSupport {
  const InspectionDraftSupport._();

  static const int schemaVersion = 2;

  static void addCommonData(
    Map<String, dynamic> data, {
    required BaseFormController baseController,
    required bool useCurrentLocation,
    String? submittedInspectionID,
    String? packageName,
    String? districtName,
    String? roadName,
  }) {
    data['_draft_schema_version'] = schemaVersion;
    data['use_current_location'] = useCurrentLocation;
    data['photo_remarks'] = baseController.photoRemarks.toList();
    data['photo_numbers'] = baseController.selectedPhotoNumbers;
    if (submittedInspectionID?.trim().isNotEmpty == true) {
      data['submitted_inspection_id'] = submittedInspectionID!.trim();
    }
    data['packageName'] = packageName ?? '';
    data['districtName'] = districtName ?? '';
    data['roadName'] = roadName ?? '';
    data['sp_remarks_partB'] = baseController.getSpRemarkPartB;
    data['cons_remarks_partB'] = baseController.getConsRemarkPartB;
    data['sp_remarks_partC'] = baseController.getSpRemarkPartC;
    data['cons_remarks_partC'] = baseController.getConsRemarkPartC;
    data['sp_remarks_partD'] = baseController.getSpRemarkPartD;
    data['cons_remarks_partD'] = baseController.getConsRemarkPartD;
    data['investigation'] = baseController.getInvestigation;
    data['sp_sign_date'] = baseController.getSpSignDate;
    data['ec_sign_date'] = baseController.getEcSignDate;
    data['ec_sign_agree'] = baseController.getEcSignAgree;
  }

  static RestoredCommonDraftState restoreCommonData(
    Map<String, dynamic> data, {
    required String? mediaPaths,
    required BaseFormController baseController,
  }) {
    baseController.formRemarks.value = RemarksModel(data: [
      Remarks(
        recID: data['recID']?.toString() ?? '',
        spRemarksPartB: data['sp_remarks_partB']?.toString() ?? '',
        consRemarksPartB: data['cons_remarks_partB']?.toString() ?? '',
        spRemarksPartC: data['sp_remarks_partC']?.toString() ?? '',
        consRemarksPartC: data['cons_remarks_partC']?.toString() ?? '',
        spRemarksPartD: data['sp_remarks_partD']?.toString() ?? '',
        consRemarksPartD: data['cons_remarks_partD']?.toString() ?? '',
      ),
    ]);
    baseController.formRemarks.refresh();

    baseController.form.value = Form2Model(
      investigation: data['investigation']?.toString() ?? '',
      spSignDate: data['sp_sign_date']?.toString() ?? '',
      ecSignDate: data['ec_sign_date']?.toString() ?? '',
      ecSignAgree: data['ec_sign_agree']?.toString() ?? 'disagree',
    );
    baseController.form.refresh();

    baseController.clearPendingPhotos();
    if (mediaPaths?.isNotEmpty == true) {
      final decodedPaths = jsonDecode(mediaPaths!);
      if (decodedPaths is List) {
        baseController.photoToUpload.value =
            decodedPaths.map((path) => XFile(path.toString())).toList();
      }
    }

    final savedPhotoNumbers = data['photo_numbers'];
    if (savedPhotoNumbers is List) {
      final restoredNumbers = savedPhotoNumbers
          .map((value) => int.tryParse(value.toString()))
          .whereType<int>()
          .toList(growable: false);
      if (restoredNumbers.length == baseController.photoToUpload.length &&
          restoredNumbers.toSet().length == restoredNumbers.length) {
        baseController.photoNumbers.value = restoredNumbers;
      }
    }

    if (baseController.photoNumbers.length !=
        baseController.photoToUpload.length) {
      baseController.photoNumbers.value = List<int>.generate(
        baseController.photoToUpload.length,
        (index) => index + 1,
      );
    }

    final savedRemarks = data['photo_remarks'];
    final remarks = savedRemarks is List
        ? savedRemarks.map((value) => value?.toString() ?? '').toList()
        : <String>[];
    final requiredLength = [
      8,
      remarks.length,
      baseController.photoToUpload.length,
    ].reduce((left, right) => left > right ? left : right);
    baseController.photoRemarks.value = [
      ...remarks,
      ...List<String>.filled(requiredLength - remarks.length, ''),
    ];

    final submittedID =
        data['submitted_inspection_id']?.toString().trim() ?? '';
    return RestoredCommonDraftState(
      useCurrentLocation: data['use_current_location'] == true,
      submittedInspectionID: submittedID.isEmpty ? null : submittedID,
    );
  }

  static String? encodeMediaPaths(BaseFormController baseController) {
    final paths = baseController.photoToUpload
        .map((photo) => photo.path)
        .toList(growable: false);
    return paths.isEmpty ? null : jsonEncode(paths);
  }
}

class InspectionDraftStore {
  const InspectionDraftStore(this.controller);

  final FormDraftController controller;

  Future<int> upsert({
    required int? draftID,
    required String formType,
    required Map<String, dynamic> data,
    required DraftStatus status,
    required String? mediaPaths,
    String? errorLog,
  }) async {
    final timestamp = DateTime.now().toUtc().toIso8601String();
    final draft = FormDraft(
      id: draftID,
      formType: formType,
      formData: jsonEncode(data),
      createdAt: timestamp,
      updatedAt: timestamp,
      status: status,
      mediaPaths: mediaPaths,
      errorLog: errorLog?.isNotEmpty == true ? errorLog : null,
    );

    if (draftID != null) {
      final rows = await controller.updateDraft(draft);
      if (rows <= 0) throw StateError('Draft update did not modify a row');
      return draftID;
    }

    final newID = await controller.insertDraft(draft);
    if (newID <= 0) {
      throw StateError('Draft insert did not return a valid ID');
    }
    return newID;
  }

  Future<void> deleteRequired(
    int draftID, {required String formType}) async {
    final rows = await controller.deleteDraft(draftID);
    if (rows < 0) {
      throw StateError('Unable to clean up submitted $formType draft $draftID',);
    }
  }
}
