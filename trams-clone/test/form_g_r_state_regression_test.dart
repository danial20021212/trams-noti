import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tram/binding/form_depot/base_form_binding.dart';
import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/controller/form_depot/common/base_form_controller.dart';
import 'package:tram/controller/form_depot/form_G_controller.dart';
import 'package:tram/controller/form_depot/form_R_controller.dart';
import 'package:tram/controller/form_depot/form_draft_controller.dart';
import 'package:tram/controller/form_depot/main_listing/main_listing_details_controller.dart';
import 'package:tram/model/form/form_depot/form_G/form_G_model.dart';
import 'package:tram/model/form/form_depot/form_R/form_R_model.dart';
import 'package:tram/model/form/form_depot/form_draft/form_draft_model.dart';
import 'package:tram/provider/api_provider.dart';

class _TestAuthController extends AuthController {
  @override
  String? getUserType() => 'Service Provider';
}

class _RecordingDraftController extends FormDraftController {
  int insertCalls = 0;
  int updateCalls = 0;
  final List<int> deletedIds = [];
  FormDraft? lastDraft;

  @override
  // Avoid opening SQLite; persistence is recorded in memory.
  // ignore: must_call_super
  void onInit() {}

  @override
  Future<int> insertDraft(FormDraft draft) async {
    insertCalls++;
    lastDraft = draft;
    return 71;
  }

  @override
  Future<int> updateDraft(FormDraft draft) async {
    updateCalls++;
    lastDraft = draft;
    return 1;
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

class _RecordingApiProvider extends ApiProvider {
  final List<Map<String, dynamic>> requests = [];
  dynamic responseData = const {
    'http_status': 'Success.',
    'recID': 'submitted-901',
  };

  @override
  Future<dio.Response<dynamic>> store(
    String url, {
    Map<String, dynamic> data = const {},
  }) async {
    requests.add(Map<String, dynamic>.from(data));
    return dio.Response<dynamic>(
      requestOptions: dio.RequestOptions(path: url),
      statusCode: 200,
      data: responseData,
    );
  }
}

class _FailingBaseFormController extends BaseFormController {
  final List<String> submittedIDs = [];

  @override
  Future<void> submitNewInspection(
    String recID, {
    bool clearPendingPhotosOnSuccess = true,
    bool resumeExistingPhotoUploads = false,
  }) async {
    submittedIDs.add(recID);
    throw StateError('simulated auxiliary submission failure');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    pathProviderChannel,
    (_) async => '/private/tmp',
  );

  setUp(() {
    Get.testMode = true;
    Get.reset();
    Get.put<AuthController>(_TestAuthController());
    Get.put<ApiProvider>(ApiProvider());
  });

  tearDown(Get.reset);

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  test('Form G draft keeps its ID, photo remarks, and error details', () async {
    Get.routing.args = {
      'formType': 'G',
      'formPage': 'inspection',
      'isResumeDraft': false,
    };
    final baseController = Get.put<BaseFormController>(BaseFormController());
    final draftController =
        Get.put<FormDraftController>(_RecordingDraftController())
            as _RecordingDraftController;
    final controller = FormGController()
      ..form = FormGModel(
        recID: 'gantry-parent-1',
        inspectionDate: '2026-09-22',
        referenceNo: 'G-001',
      ).obs;
    baseController.photoToUpload.assign(
      XFile.fromData(Uint8List.fromList([1, 2, 3]), name: 'photo1.jpg'),
    );
    baseController.photoRemarks.value = ['gantry photo remark'];

    expect(
      await controller.saveDraft(
        errorLog: 'offline',
        navigateAfterSave: false,
      ),
      isTrue,
    );
    expect(draftController.lastDraft!.errorLog, 'offline');
    Get.routing.args = {'formType': 'G', 'formPage': 'inspection'};
    expect(await controller.saveDraft(navigateAfterSave: false), isTrue);

    expect(draftController.insertCalls, 1);
    expect(draftController.updateCalls, 1);
    expect(draftController.lastDraft!.id, 71);
    final json = jsonDecode(draftController.lastDraft!.formData);
    expect(json['photo_remarks'], ['gantry photo remark']);
    expect(draftController.lastDraft!.errorLog, isNull);

    draftController.drafts.add(draftController.lastDraft!);
    await controller.removeSubmittedDraft();
    expect(draftController.deletedIds, [71]);
    expect(draftController.drafts, isEmpty);
  });

  test('Form G draft stores applicability and blanks excluded item fields',
      () async {
    Get.routing.args = {
      'formType': 'G',
      'formPage': 'inspection',
      'isResumeDraft': false,
    };
    Get.put<BaseFormController>(BaseFormController());
    final drafts = Get.put<FormDraftController>(_RecordingDraftController())
        as _RecordingDraftController;
    final controller = FormGController()
      ..form = FormGModel(
        barrierDistress: '1',
        barrierCritical: '1',
        barrierClosed: '0',
      ).obs;

    controller.toggleInspectionItem('1');
    expect(await controller.saveDraft(navigateAfterSave: false), isTrue);

    final json = jsonDecode(drafts.lastDraft!.formData);
    expect(json['inspection_item_checkboxes']['1'], isFalse);
    expect(json['inspection_item_checkboxes']['2'], isTrue);
    expect(json['barrierDistress'], isEmpty);
    expect(json['barrierCritical'], isEmpty);
    expect(json['barrierClosed'], isEmpty);
  });

  test('Form R serializes No Distress with severity one', () {
    Get.routing.args = {
      'formType': 'R',
      'formPage': 'inspection',
      'isResumeDraft': false,
    };
    Get.put<BaseFormController>(BaseFormController());
    final controller = FormRController()
      ..form = FormRModel(
        distress: const ['R01', 'R02'],
        severity: '5',
      ).obs;
    controller.selectedDistress.assignAll(const ['R01', 'R02']);

    controller.toggleDistress(FormRController.noDistressCode);

    expect(controller.form.value.toJson()['distress'], 'ND');
    expect(controller.form.value.toJson()['severity'], '1');
  });

  test('Form R draft keeps its ID and photo remarks across route changes',
      () async {
    Get.routing.args = {
      'formType': 'R',
      'formPage': 'inspection',
      'isResumeDraft': false,
    };
    final baseController = Get.put<BaseFormController>(BaseFormController());
    final draftController =
        Get.put<FormDraftController>(_RecordingDraftController())
            as _RecordingDraftController;
    final controller = FormRController()
      ..form = FormRModel(
        recID: 'wall-parent-1',
        inspectionDate: '2026-09-22',
        referenceNo: 'R-001',
      ).obs;
    baseController.photoToUpload.assign(
      XFile.fromData(Uint8List.fromList([4, 5, 6]), name: 'photo1.jpg'),
    );
    baseController.photoRemarks.value = ['wall photo remark'];

    expect(await controller.saveDraft(navigateAfterSave: false), isTrue);
    Get.routing.args = {'formType': 'R', 'formPage': 'inspection'};
    expect(await controller.saveDraft(navigateAfterSave: false), isTrue);

    expect(draftController.insertCalls, 1);
    expect(draftController.updateCalls, 1);
    expect(draftController.lastDraft!.id, 71);
    final json = jsonDecode(draftController.lastDraft!.formData);
    expect(json['photo_remarks'], ['wall photo remark']);
  });

  test('G and R editors do not register placeholder details controllers', () {
    for (final formType in ['G', 'R']) {
      Get.reset();
      Get.put<AuthController>(_TestAuthController());
      Get.put<ApiProvider>(ApiProvider());
      Get.routing.args = {
        'formType': formType,
        'formPage': 'inspection',
        'isResumeDraft': true,
        'draftId': 71,
      };

      BaseFormBinding().dependencies();

      expect(Get.isRegistered<MainListingDetailsController>(), isFalse);
    }
  });

  test('Form G partial retry reuses the submitted inspection ID', () async {
    Get.reset();
    Get.put<AuthController>(_TestAuthController());
    final apiProvider =
        Get.put<ApiProvider>(_RecordingApiProvider()) as _RecordingApiProvider;
    Get.routing.args = {
      'formType': 'G',
      'formPage': 'inspection',
      'isResumeDraft': false,
    };
    final baseController = Get.put<BaseFormController>(
      _FailingBaseFormController(),
    ) as _FailingBaseFormController;
    final draftController =
        Get.put<FormDraftController>(_RecordingDraftController())
            as _RecordingDraftController;
    final controller = FormGController()
      ..form = FormGModel(
        recID: 'gantry-parent-1',
        inspectionDate: '2026-09-22',
        barrierDistress: '1',
        barrierCritical: '1',
        gantryBeamDistress: '1',
        gantryBeamCritical: '1',
        gantryColumnDistress: '1',
        gantryColumnCritical: '1',
        footingsDistress: '1',
        footingsCritical: '1',
        anchorMortarDistress: '1',
        anchorMortarCritical: '1',
        maintenanceAccessDistress: '1',
        maintenanceAccessCritical: '1',
        staticSignsDistress: '1',
        staticSignsCritical: '1',
        vmsDistress: '1',
        vmsCritical: '1',
      ).obs;
    baseController.photoToUpload.assign(
      XFile.fromData(Uint8List.fromList([1]), name: 'photo.jpg'),
    );
    baseController.photoRemarks.value = ['required remark'];
    baseController.setInvestigation = 'approval';

    await controller.submitNewInspection();
    await controller.submitNewInspection();

    expect(apiProvider.requests, hasLength(1));
    expect(baseController.submittedIDs, ['submitted-901', 'submitted-901']);
    expect(draftController.insertCalls, 1);
    expect(draftController.updateCalls, 1);
    expect(draftController.lastDraft!.status.name, 'pendingSync');
    final json = jsonDecode(draftController.lastDraft!.formData);
    expect(json['submitted_inspection_id'], 'submitted-901');
    expect(baseController.photoToUpload, hasLength(1));
    expect(baseController.photoRemarks, ['required remark']);
  });

  test('Form R partial failure retains photos in a pending-sync draft',
      () async {
    Get.reset();
    Get.put<AuthController>(_TestAuthController());
    Get.put<ApiProvider>(_RecordingApiProvider());
    Get.routing.args = {
      'formType': 'R',
      'formPage': 'inspection',
      'isResumeDraft': false,
    };
    final baseController = Get.put<BaseFormController>(
      _FailingBaseFormController(),
    ) as _FailingBaseFormController;
    final draftController =
        Get.put<FormDraftController>(_RecordingDraftController())
            as _RecordingDraftController;
    final controller = FormRController()
      ..form = FormRModel(
        recID: 'wall-parent-1',
        inspectionDate: '2026-09-22',
        distress: const ['R01'],
      ).obs;
    baseController.photoToUpload.assign(
      XFile.fromData(Uint8List.fromList([1]), name: 'photo.jpg'),
    );
    baseController.photoRemarks.value = ['required remark'];
    baseController.setInvestigation = 'approval';

    await controller.submitNewInspection();

    expect(draftController.lastDraft!.status.name, 'pendingSync');
    expect(draftController.lastDraft!.mediaPaths, isNotNull);
    expect(baseController.photoToUpload, hasLength(1));
    expect(baseController.photoRemarks, ['required remark']);
  });
}
