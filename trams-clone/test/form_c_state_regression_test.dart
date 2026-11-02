import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tram/binding/form_depot/base_form_binding.dart';
import 'package:tram/binding/form_depot/main_listing_binding.dart';
import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/controller/form_depot/common/base_form_controller.dart';
import 'package:tram/controller/form_depot/form_draft_controller.dart';
import 'package:tram/controller/form_depot/form_C_controller.dart';
import 'package:tram/controller/form_depot/main_listing/main_listing_controller.dart';
import 'package:tram/controller/form_depot/main_listing/main_listing_details_controller.dart';
import 'package:tram/model/form/form_depot/common/remarks_model.dart';
import 'package:tram/model/form/form_depot/form_C/form_C_main_listing_details_model.dart';
import 'package:tram/model/form/form_depot/form_C/form_C_model.dart';
import 'package:tram/model/form/form_depot/form_draft/form_draft_model.dart';
import 'package:tram/model/form/form_depot/main_listing/form_main_listing_model.dart';
import 'package:tram/provider/api_provider.dart';
import 'package:tram/repository/form_repository.dart';

class _TestAuthController extends AuthController {
  @override
  String? getUserType() => 'Service Provider';
}

class _RecordingApiProvider extends ApiProvider {
  final List<Map<String, dynamic>> requests = [];
  dynamic responseData = const {'http_status': 'Success.', 'data': []};

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

class _ReviewFormCController extends FormCController {
  @override
  Future<void> loadReviewData() async {}
}

class _DraftDetailsController extends MainListingDetailsController {
  @override
  // Avoid loading route data; tests populate the context directly.
  // ignore: must_call_super
  void onInit() {}
}

class _RecordingDraftController extends FormDraftController {
  int insertCalls = 0;
  int updateCalls = 0;
  final List<int> deletedIds = [];
  FormDraft? lastDraft;

  @override
  // Avoid opening SQLite; persistence is recorded in-memory in this test.
  // ignore: must_call_super
  void onInit() {}

  @override
  Future<int> insertDraft(FormDraft draft) async {
    insertCalls++;
    lastDraft = draft;
    return 52;
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          pathProviderChannel, (_) async => '/private/tmp');

  late _RecordingApiProvider apiProvider;

  setUp(() {
    Get.testMode = true;
    Get.reset();
    Get.put<AuthController>(_TestAuthController());
    apiProvider = _RecordingApiProvider();
    Get.put<ApiProvider>(apiProvider);
  });

  tearDown(() {
    Get.reset();
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  test('selects Q1, Q1-A, and Form C2 without truncating identifiers', () {
    final response = Form_C_MainListingDetailsModel.fromJson({
      'http_status': 'Success.',
      'data': [
        {
          'recID': '10',
          'insRecID': '101',
          'reference_no': 'Q1',
          'inspection_date': '2026-09-01',
        },
        {
          'recID': '20',
          'subID': '201',
          'reference_no': 'Q1-A',
          'inspection_date': '2026-09-02',
        },
        {
          'recID': '30',
          'inspectionID': '301',
          'reference_no': 'Form C2',
          'inspection_date': '2026-09-03',
        },
      ],
    });

    final q1 = response.recordsForSelection(
      parentRecID: '10',
      referenceNo: 'Q1',
    );
    final q1A = response.recordsForSelection(
      parentRecID: '20',
      referenceNo: 'Q1-A',
    );
    final formC2 = response.recordsForSelection(
      parentRecID: '30',
      referenceNo: 'Form C2',
    );

    expect(q1.single.referenceNo, 'Q1');
    expect(q1.single.insRecID, '101');
    expect(q1A.single.referenceNo, 'Q1-A');
    expect(q1A.single.insRecID, '201');
    expect(formC2.single.referenceNo, 'Form C2');
    expect(formC2.single.insRecID, '301');
  });

  test(
      'reports no records instead of mixing in other roads when nothing '
      'in the response actually matches this one', () {
    final response = Form_C_MainListingDetailsModel.fromJson({
      'http_status': 'Success.',
      'data': [
        {
          'recID': '10',
          'insRecID': '101',
          'reference_no': 'Q1',
          'inspection_date': '2026-09-01',
        },
        {
          'recID': '20',
          'insRecID': '201',
          'reference_no': 'Q1-A',
          'inspection_date': '2026-09-02',
        },
      ],
    });

    // Neither the requested road's ID nor its reference number appears
    // anywhere in this response - it should report having no records
    // rather than falling back to someone else's (Q1's or Q1-A's).
    final noMatch = response.recordsForSelection(
      parentRecID: '99',
      referenceNo: 'Unassigned Road',
    );

    expect(noMatch, isEmpty);
  });

  test('passes hyphenated Form C road identifiers to the listing API intact',
      () async {
    final repository = FormRepository(formType: 'C');

    for (final roadID in ['Q1', 'Q1-A', 'Form C2']) {
      await repository.showFormCMainListing(
        packageID: 'package-1',
        districtID: 'district-1',
        routeID: roadID,
      );
    }

    expect(
      apiProvider.requests.map((request) => request['roadId']),
      ['Q1', 'Q1-A', 'Form C2'],
    );
  });

  test(
      'keeps every Form C structure under a package even when several share '
      'an unassigned reference number', () async {
    Get.routing.args = {'formType': 'C'};
    apiProvider.responseData = {
      'http_status': 'Success.',
      'data': [
        // Two different structures, neither given a reference number yet -
        // both would report referenceNo as "-". Deduping on referenceNo
        // alone used to collapse these into a single entry.
        {'recID': '501', 'roadName': 'Road A'},
        {'recID': '502', 'roadName': 'Road B'},
        // A structure that does have one, to confirm it's unaffected.
        {'recID': '503', 'reference_no': 'Q1', 'roadName': 'Road C'},
      ],
    };

    final controller = Get.put<MainListingController>(MainListingController());
    await controller.apply(
      packageID: 'package-1',
      districtID: 'district-1',
      routeID: 'route-1',
      refNo: '',
    );

    expect(
      controller.pagingControllerC.itemList?.map((item) => item.recID),
      ['501', '502', '503'],
    );
  });

  test('retrieves persisted photos with the submitted inspection ID', () async {
    apiProvider.responseData = {
      'http_status': 'Success.',
      'data': [
        {
          'image': 'photo2.jpg',
          'photoNo': 'photo2',
          'userRemarks': 'second',
        },
        {
          'image': 'photo1.jpg',
          'photoNo': 'photo1',
          'userRemarks': 'first',
        },
      ],
    };
    final controller = BaseFormController();
    controller.configureContext(
      formType: 'C',
      recID: 'inspection-201',
      reviewMode: true,
    );

    await controller.loadPhoto();

    expect(apiProvider.requests.single['recID'], 'inspection-201');
    expect(
      controller.photoLinks.map((photo) => photo.photoNo),
      ['photo1', 'photo2'],
    );
    expect(
      controller.photoLinks.map((photo) => photo.remarks),
      ['first', 'second'],
    );
  });

  test('rejects a parent record ID as the submitted inspection ID', () {
    expect(
      () => FormCController.resolveSubmittedInspectionID(
        {'recID': 'parent-20'},
        parentRecID: 'parent-20',
      ),
      throwsA(isA<StateError>()),
    );
    expect(
      FormCController.resolveSubmittedInspectionID(
        {'subID': 'inspection-201', 'recID': 'parent-20'},
        parentRecID: 'parent-20',
      ),
      'inspection-201',
    );
  });

  test('orders Form C day-first dates newest-first using child ID for ties',
      () {
    final controller = MainListingDetailsController();
    final records = [
      FormMainListingModel.fromJson({
        'recID': 'parent-20',
        'insRecID': '500',
        'inspection_date': '14/09/2026',
      }),
      FormMainListingModel.fromJson({
        'recID': 'parent-20',
        'insRecID': '2',
        'inspection_date': '15-09-2026',
      }),
      FormMainListingModel.fromJson({
        'recID': 'parent-20',
        'insRecID': '10',
        'inspection_date': '15/09/2026',
      }),
      FormMainListingModel.fromJson({
        'recID': 'parent-20',
        'insRecID': '999',
        'inspection_date': '2026-08-01',
      }),
    ];

    controller.sortInspectionRecordsNewestFirst(
      records,
      useChildInspectionID: true,
    );

    expect(
      records.map((record) => record.insRecID),
      ['10', '2', '500', '999'],
    );
  });

  test('new Form C draft keeps its ID and subsequent saves update it',
      () async {
    Get.routing.args = {
      'formType': 'C',
      'formPage': 'inspection',
      'isResumeDraft': false,
    };
    final drafts = Get.put<FormDraftController>(_RecordingDraftController())
        as _RecordingDraftController;
    Get.put<MainListingDetailsController>(_DraftDetailsController())
      ..packageName = 'Package One'
      ..districtName = 'Kapit'
      ..roadName = 'Q3217';
    Get.put<BaseFormController>(BaseFormController());
    final controller = FormCController()
      ..form = FormCModel(
        recID: 'culvert-parent-2',
        inspectionDate: '2026-09-15',
        referenceNo: '',
      ).obs;

    expect(await controller.saveDraft(navigateAfterSave: false), isTrue);
    expect(Get.arguments['draftId'], 52);
    expect(Get.arguments['isResumeDraft'], isTrue);
    expect(controller.isResumeDraft, isTrue);
    final savedData =
        jsonDecode(drafts.lastDraft!.formData) as Map<String, dynamic>;
    expect(savedData['districtName'], 'Kapit');
    expect(savedData['roadName'], 'Q3217');

    expect(await controller.saveDraft(navigateAfterSave: false), isTrue);
    expect(drafts.insertCalls, 1);
    expect(drafts.updateCalls, 1);
    expect(drafts.lastDraft?.id, 52);
  });

  test('Form C removes the submitted draft even if route arguments change',
      () async {
    Get.routing.args = {
      'formType': 'C',
      'formPage': 'inspection',
      'isResumeDraft': true,
      'draftId': 84,
    };
    final drafts = Get.put<FormDraftController>(_RecordingDraftController())
        as _RecordingDraftController;
    Get.put<BaseFormController>(BaseFormController());
    final controller = FormCController()..form = FormCModel().obs;

    Get.routing.args = <String, dynamic>{};
    await controller.removeSubmittedDraft();

    expect(drafts.deletedIds, [84]);
    expect(controller.isResumeDraft, isFalse);
  });

  test('finds Form C drafts by parent recID when reference number is empty',
      () async {
    final draftController =
        Get.put<FormDraftController>(_RecordingDraftController())
            as _RecordingDraftController;
    draftController.drafts.assignAll([
      FormDraft(
        id: 1,
        formType: 'Form C',
        formData: '{"recID":"culvert-parent-2","referenceNo":""}',
        createdAt: '2026-09-15T00:00:00Z',
        updatedAt: '2026-09-15T00:00:00Z',
      ),
      FormDraft(
        id: 2,
        formType: 'Form C',
        formData: '{"recID":"another-culvert","referenceNo":""}',
        createdAt: '2026-09-15T00:00:00Z',
        updatedAt: '2026-09-15T00:00:00Z',
      ),
    ]);
    final controller = MainListingDetailsController()..formType = 'C';

    await controller.fetchMatchingDrafts(
      '',
      parentID: 'culvert-parent-2',
    );

    expect(controller.localDrafts.map((draft) => draft.id), [1]);
  });

  test('preserves per-inspection approval status for review routing', () {
    final item = FormMainListingModel.fromJson({
      'recID': 'parent-20',
      'insRecID': 'inspection-201',
      'status': 'Approved',
    });

    expect(item.status, 'Approved');
    expect(item.copyWith().status, 'Approved');
  });

  test('marks an approved Form C review context as read-only', () {
    Get.routing.args = {
      'formType': 'C',
      'formPage': 'review_C2',
      'recID': 'inspection-201',
      'status': 'APPROVED',
    };

    final controller = Get.put<BaseFormController>(BaseFormController());

    expect(controller.isReviewMode.value, isTrue);
    expect(controller.isReadOnly.value, isTrue);
  });

  test(
      'a new Form C inspection screen always forces editable state, even on '
      'a BaseFormController instance GetX reused from a review screen', () {
    // Simulate a BaseFormController GetX handed back for a new inspection
    // after it was last configured for a Form C2 review: onInit() does not
    // re-run on a reused instance, so isReviewMode/isReadOnly would
    // otherwise still read as the earlier review's, hiding "Choose photo"
    // (Photographs page relies on isReviewMode: only its remote/read-only
    // branch has no add-photo affordance).
    final baseController = BaseFormController();
    baseController.configureContext(
      formType: 'C',
      recID: 'inspection-201',
      reviewMode: true,
    );
    baseController.isReadOnly.value = true;
    expect(baseController.isReviewMode.value, isTrue);

    // This is exactly what NewInspectionFormCScreen.initState() now runs
    // unconditionally, regardless of whether BaseFormController.onInit()
    // executed for this navigation.
    baseController.configureContext(
      formType: 'C',
      recID: 'parent-20',
      reviewMode: false,
    );
    baseController.isReadOnly.value = false;

    expect(baseController.isReviewMode.value, isFalse);
    expect(baseController.isReadOnly.value, isFalse);
  });

  test('clears Form C editor data only after successful submission', () {
    Get.routing.args = {
      'formType': 'C',
      'formPage': 'inspection',
      'isResumeDraft': true,
    };
    final baseController = Get.put<BaseFormController>(BaseFormController());
    final controller = FormCController();
    controller.form = FormCModel(
      recID: 'parent-20',
      inspectionDate: '2026-09-09',
      roadId: 'Q1-A',
      waterwayDistress: 'C05',
      waterwaySeverity: '3',
    ).obs;
    controller.selectedCulvertTypes.assign('Box');
    controller.sectionCheckboxes['2A'] = false;
    controller.useCurrentLocation.value = true;
    baseController.photoToUpload.assignAll([
      XFile.fromData(Uint8List.fromList([1, 2, 3]), name: 'photo1.jpg'),
    ]);
    baseController.photoRemarks.value = ['remark one'];
    baseController.formRemarks.value = RemarksModel(data: [
      Remarks(
        recID: 'inspection-201',
        spRemarksPartB: 'distress',
        consRemarksPartB: '',
        spRemarksPartC: 'comment',
        consRemarksPartC: '',
        spRemarksPartD: 'feedback',
        consRemarksPartD: '',
      ),
    ]);

    controller.resetEditorStateAfterSuccessfulSubmission();

    expect(controller.form.value.recID, isNull);
    expect(controller.form.value.roadId, isNull);
    expect(controller.form.value.waterwayDistress, isNull);
    expect(controller.selectedCulvertTypes, isEmpty);
    expect(controller.sectionCheckboxes.values, everyElement(isTrue));
    expect(controller.useCurrentLocation.value, isFalse);
    expect(controller.isResumeDraft, isFalse);
    expect(baseController.photoToUpload, isEmpty);
    expect(baseController.photoRemarks, everyElement(isEmpty));
    expect(baseController.formRemarks.value.data!.single.recID, isEmpty);
  });

  test('prefills a new Form C inspection without reusing child identity', () {
    Get.routing.args = {
      'formType': 'C',
      'formPage': 'inspection',
    };
    Get.put<BaseFormController>(BaseFormController());
    final controller = FormCController();
    controller.form = FormCModel().obs;

    controller.prefillFromPreviousInspection(
      FormCModel(
        recID: 'old-child-101',
        inspectionDate: '2026-08-01',
        waterwayDistress: 'C05',
        waterwaySeverity: '3',
        barrel1Distress: 'C12',
        barrel1Severity: '2',
      ),
      parentRecID: 'parent-20',
      inspectionDate: '2026-09-11',
      packageID: 'package-1',
      districtID: 'district-1',
      roadID: 'Q1-A',
      referenceNo: 'C-001',
    );

    expect(controller.form.value.recID, 'parent-20');
    expect(controller.form.value.inspectionDate, '2026-09-11');
    expect(controller.form.value.waterwayDistress, 'C05');
    expect(controller.form.value.waterwaySeverity, '3');
    expect(controller.form.value.barrel1Distress, 'C12');
    expect(controller.form.value.roadId, 'Q1-A');
    expect(controller.form.value.toAPISubmitJson()['recID'], 'parent-20');
  });

  test('retains Form C fields, photos, and remarks after submission failure',
      () async {
    Get.routing.args = {
      'formType': 'C',
      'formPage': 'inspection',
      'recID': 'parent-20',
    };
    apiProvider.responseData = const {
      'http_status': 'Failure.',
      'data': 'server failure',
    };
    final baseController = Get.put<BaseFormController>(BaseFormController());
    final controller = FormCController();
    controller.form = FormCModel(
      recID: 'parent-20',
      inspectionDate: '2026-09-09',
      roadId: 'Q1-A',
      waterwayDistress: 'C05',
      waterwaySeverity: '3',
    ).obs;
    controller.sectionCheckboxes.updateAll((_, __) => false);
    baseController.photoToUpload.assign(
      XFile.fromData(Uint8List.fromList([1, 2, 3]), name: 'photo1.jpg'),
    );
    baseController.photoRemarks.value = ['retain this remark'];
    baseController.form.value.investigation = 'retain approval details';

    await controller.submitNewInspection();

    expect(controller.form.value.recID, 'parent-20');
    expect(controller.form.value.roadId, 'Q1-A');
    expect(controller.form.value.waterwayDistress, 'C05');
    expect(baseController.photoToUpload, hasLength(1));
    expect(baseController.photoRemarks, ['retain this remark']);
    expect(baseController.form.value.investigation, 'retain approval details');
  });

  test('keeps Form C details controller scoped to each details route', () {
    Get.routing.args = {'formType': 'C', 'formTitle': 'Culvert'};
    MainListingBinding().dependencies();
    expect(Get.isRegistered<MainListingDetailsController>(), isFalse);

    Get.reset();
    Get.put<AuthController>(_TestAuthController());
    Get.put<ApiProvider>(_RecordingApiProvider());
    Get.routing.args = {
      'formType': 'C',
      'formTitle': 'Culvert',
      'isMainListing': true,
      'recID': 'parent-20',
    };
    MainListingBinding().dependencies();
    expect(Get.isRegistered<MainListingDetailsController>(), isTrue);

    Get.reset();
    Get.put<AuthController>(_TestAuthController());
    Get.put<ApiProvider>(_RecordingApiProvider());
    Get.routing.args = {'formType': 'B', 'formTitle': 'Bridge'};
    MainListingBinding().dependencies();
    expect(Get.isRegistered<MainListingDetailsController>(), isTrue);
  });

  test('Add New Inspection replaces stale Form C review controllers', () {
    Get.routing.args = {
      'formType': 'C',
      'formPage': 'review_C2',
      'recID': 'viewed-inspection-1',
      'status': 'Approved',
    };
    final viewedBaseController = Get.put<BaseFormController>(
      BaseFormController(),
    );
    final viewedFormController =
        Get.put<FormCController>(_ReviewFormCController());
    viewedBaseController.configureContext(
      formType: 'C',
      recID: 'viewed-inspection-1',
      reviewMode: true,
    );

    Get.routing.args = {
      'formType': 'C',
      'formPage': 'inspection',
      'recID': 'culvert-parent-2',
      'inspectionDate': DateTime(2026, 9, 12),
      'previousRecID': '',
    };
    BaseFormBinding().dependencies();

    final insertBaseController = Get.find<BaseFormController>();
    expect(viewedFormController.isClosed, isTrue);
    expect(identical(insertBaseController, viewedBaseController), isFalse);
    expect(insertBaseController.isReviewMode.value, isFalse);
    expect(insertBaseController.recID, 'culvert-parent-2');
    expect(insertBaseController.photoLinks, isEmpty);
    expect(insertBaseController.photoToUpload, isEmpty);
  });
}
