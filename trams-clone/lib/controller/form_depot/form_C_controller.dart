import 'dart:convert';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;
import 'package:get/get.dart';
import 'package:tram/model/form/form_depot/form_C/form_C_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/form_repository.dart';
import 'package:tram/screen/form_depot/form_C/pages/inspection_data_page.dart';
import 'package:tram/screen/form_depot/form_C/pages/inspection_items_page.dart';
import 'package:tram/screen/form_depot/form_C/pages/side_condition_page.dart';

import '../../model/shared/draft_status_model.dart';
import '../../screen/form_depot/common/base_form/approval_page.dart';
import '../../screen/form_depot/common/base_form/distress_observed_page.dart';
import '../../screen/form_depot/common/base_form/feedback_page.dart';
import '../../screen/form_depot/common/base_form/general_comment_page.dart';
import '../../screen/form_depot/common/base_form/photographs_page.dart';
import 'common/base_form_controller.dart';
import 'common/inspection_draft_support.dart';
import 'common/inspection_submission_coordinator.dart';
import 'common/inspection_validation.dart';
import 'common/inspection_workflow_state.dart';
import 'form_draft_controller.dart';
import 'main_listing/main_listing_controller.dart';
import 'main_listing/main_listing_details_controller.dart';

class FormCController extends GetxController {
  final InspectionWorkflowState _workflow =
      InspectionWorkflowState.fromArguments(Get.arguments);
  final InspectionSubmissionCoordinator _submissionCoordinator =
      const InspectionSubmissionCoordinator();
  //bool isEditMode = Get.arguments["isEditMode"] ?? false;
  RxBool isReviewMode = false.obs;
  final String formPage = Get.arguments['formPage'] ?? 'Unknown';
  bool get isResumeDraft => _workflow.isResumeDraft;
  set isResumeDraft(bool value) => _workflow.isResumeDraft = value;

  Rx<LoaderState> state = LoaderState.initial.obs;
  late Rx<FormCModel> form;
  final repository = FormRepository(formType: 'C');

  final baseFormController = Get.find<BaseFormController>();

  MainListingController? get mainListingController =>
      Get.isRegistered<MainListingController>()
          ? Get.find<MainListingController>()
          : null;

  MainListingDetailsController? get mainListingDetailsController =>
      Get.isRegistered<MainListingDetailsController>()
          ? Get.find<MainListingDetailsController>()
          : null;

  RxBool useCurrentLocation = false.obs;

  // Track which sections are checked (enabled). Default all true.
  RxMap<String, bool> sectionCheckboxes = <String, bool>{
    for (final code in [
      '1A',
      '2A',
      '2B',
      '3A',
      '3B',
      '3C',
      '3D',
      '3E',
      '3F',
      '3G',
      '3H',
      '4A',
      '4B',
      '4C',
      '4D',
      '5A',
    ])
      code: true,
  }.obs;

  bool isSectionChecked(String code) => sectionCheckboxes[code] ?? true;
  void toggleSection(String code) {
    final checked = !(sectionCheckboxes[code] ?? true);
    sectionCheckboxes[code] = checked;
    if (!checked) _clearSectionData(code);
  }

  // JSON keys for each section (used to override checked/unchecked data)
  static const Map<String, List<String>> _sectionJsonKeys = {
    '1A': ['1A_culvert_marker_distress', '1A_culvert_marker_severity'],
    '2A': ['2A_waterway_Distress', 'A2_Distress_Other', '2A_waterway_Severity'],
    '2B': [
      '2B_embankment_Distress',
      'B2_Distress_Other',
      '2B_embankment_Severity'
    ],
    '3A': [
      '3A_headwall_inlet_Distress',
      'A3_Distress_Other',
      '3A_headwall_inlet_Severity'
    ],
    '3B': [
      '3B_wingwall_inlet_Distress',
      'B3_Distress_Other',
      '3B_wingwall_inlet_Severity'
    ],
    '3C': [
      '3C_apron_inlet_Distress',
      'C3_Distress_Other',
      '3C_apron_inlet_Severity'
    ],
    '3D': [
      '3D_riprap_inlet_Distress',
      'D3_Distress_Other',
      '3D_riprap_inlet_Severity'
    ],
    '3E': [
      '3E_headwall_outlet_Distress',
      'E3_Distress_Other',
      '3E_headwall_outlet_Severity'
    ],
    '3F': [
      '3F_wingwall_outlet_Distress',
      'F3_Distress_Other',
      '3F_wingwall_outlet_Severity'
    ],
    '3G': [
      '3G_apron_outlet_Distress',
      'G3_Distress_Other',
      '3G_apron_outlet_Severity'
    ],
    '3H': [
      '3H_riprap_outlet_Distress',
      'H3_Distress_Other',
      '3H_riprap_outlet_Severity'
    ],
    '4A': ['4A_barrel1_Distress', 'A4_Distress_Other', '4A_barrel1_Severity'],
    '4B': ['4B_barrel2_Distress', 'B4_Distress_Other', '4B_barrel2_Severity'],
    '4C': ['4C_barrel3_Distress', 'C4_Distress_Other', '4C_barrel3_Severity'],
    '4D': ['4D_barrel4_Distress', 'D4_Distress_Other', '4D_barrel4_Severity'],
    '5A': [
      '5A_culvert_approch_condition_Distress',
      'A5_Distress_Other',
      '5A_culvert_approch_condition_Severity'
    ],
  };

  /// Overrides unchecked sections in [json].
  /// Distress → "Not Applicable", "Other" → "", Severity → "1".
  void _applyUncheckedSections(Map<String, dynamic> json) {
    for (final entry in sectionCheckboxes.entries) {
      if (entry.value) continue;
      final keys = _sectionJsonKeys[entry.key] ?? [];
      for (int i = 0; i < keys.length; i++) {
        // Distress is always first key, severity is always last key
        json[keys[i]] = '';
      }
    }
  }

  void _clearSectionData(String code) {
    form.update((val) {
      if (val == null) return;
      switch (code) {
        case '1A':
          val.culvertMarkerDistress = null;
          val.culvertMarkerSeverity = null;
          break;
        case '2A':
          val.waterwayDistress = null;
          val.waterwayDistressOther = null;
          val.waterwaySeverity = null;
          break;
        case '2B':
          val.embankmentDistress = null;
          val.embankmentDistressOther = null;
          val.embankmentSeverity = null;
          break;
        case '3A':
          val.headwallInletDistress = null;
          val.headwallInletDistressOther = null;
          val.headwallInletSeverity = null;
          break;
        case '3B':
          val.wingwallInletDistress = null;
          val.wingwallInletDistressOther = null;
          val.wingwallInletSeverity = null;
          break;
        case '3C':
          val.apronInletDistress = null;
          val.apronInletDistressOther = null;
          val.apronInletSeverity = null;
          break;
        case '3D':
          val.riprapInletDistress = null;
          val.riprapInletDistressOther = null;
          val.riprapInletSeverity = null;
          break;
        case '3E':
          val.headwallOutletDistress = null;
          val.headwallOutletDistressOther = null;
          val.headwallOutletSeverity = null;
          break;
        case '3F':
          val.wingwallOutletDistress = null;
          val.wingwallOutletDistressOther = null;
          val.wingwallOutletSeverity = null;
          break;
        case '3G':
          val.apronOutletDistress = null;
          val.apronOutletDistressOther = null;
          val.apronOutletSeverity = null;
          break;
        case '3H':
          val.riprapOutletDistress = null;
          val.riprapOutletDistressOther = null;
          val.riprapOutletSeverity = null;
          break;
        case '4A':
          val.barrel1Distress = null;
          val.barrel1DistressOther = null;
          val.barrel1Severity = null;
          break;
        case '4B':
          val.barrel2Distress = null;
          val.barrel2DistressOther = null;
          val.barrel2Severity = null;
          break;
        case '4C':
          val.barrel3Distress = null;
          val.barrel3DistressOther = null;
          val.barrel3Severity = null;
          break;
        case '4D':
          val.barrel4Distress = null;
          val.barrel4DistressOther = null;
          val.barrel4Severity = null;
          break;
        case '5A':
          val.culvertApproachConditionDistress = null;
          val.culvertApproachConditionDistressOther = null;
          val.culvertApproachConditionSeverity = null;
          break;
      }
    });
  }

  PageController? pageController;

  RxList<Widget> newRecordPages = <Widget>[
    const InspectionDataPage(),
    const SideConditionPage(),
  ].obs;

  RxList<Widget> newInspectionPages = <Widget>[
    const InspectionItemsPage(),
    const PhotographsPage(),
    const DistressObservedPage(),
    const GeneralCommentPage(),
    const FeedbackPage(),
    const ApprovalPage(),
  ].obs;

  RxList<Widget> reviewFormC2Pages = <Widget>[
    const PhotographsPage(),
    const DistressObservedPage(),
    const GeneralCommentPage(),
    const FeedbackPage()
  ].obs;

  //Inspection Data Page
  final List<String> culvertTypeOptions = [
    'Pipe',
    'Box',
    'Arch',
    'Bridge',
    'Metal',
  ];

  final List<String> culvertMaterialOptions = [
    'R.C.',
    'Metal',
    'HDPE',
    'PVC',
    'Timber',
    'Masonry',
  ];

  final List<String> inletStructureOptions = [
    'Headwall',
    'Wingwall',
    'Apron',
    'Riprap',
  ];

  final List<String> outletStructureOptions = [
    'Headwal',
    'Wingwall',
    'Apron',
    'Riprap',
  ];

  RxList<String> selectedCulvertTypes = <String>[].obs;
  RxList<String> selectedCulvertMaterials = <String>[].obs;
  RxList<String> selectedInletStructures = <String>[].obs;
  RxList<String> selectedOutletStructures = <String>[].obs;

  final RxList<String> optionsYesOrNo = ["YES", "NO"].obs;

  @override
  void onInit() async {
    super.onInit();
    form = FormCModel().obs;
    state.listen((v) {
      switch (v) {
        case LoaderState.initial:
        case LoaderState.loading:
          SmartDialog.showLoading(
            clickMaskDismiss: false,
          );
          break;
        case LoaderState.loaded:
        case LoaderState.failure:
          SmartDialog.dismiss();
          break;
      }
    });

    final draftId = _workflow.activeDraftId;

    //if in review mode
    if (formPage == "review_C2") {
      isReviewMode = true.obs;
      await loadReviewData();
    }

    if (formPage == "inspection" && !isResumeDraft) {
      await _loadPreviousData();
    }

    //if in draft mode
    if (isResumeDraft && draftId != null) {
      await _resumeDraft(draftId);
    }
  }

  static String resolveSubmittedInspectionID(
    dynamic responseData, {
    required String parentRecID,
  }) {
    if (responseData is! Map) {
      throw StateError('Form C submission response is not a JSON object');
    }

    for (final key in const ['subID', 'insRecID', 'inspectionID']) {
      final value = responseData[key]?.toString().trim() ?? '';
      if (value.isNotEmpty && value.toLowerCase() != 'null') return value;
    }

    final fallbackRecID = responseData['recID']?.toString().trim() ?? '';
    if (fallbackRecID.isNotEmpty &&
        fallbackRecID.toLowerCase() != 'null' &&
        fallbackRecID != parentRecID.trim()) {
      return fallbackRecID;
    }

    throw StateError('Form C submission response has no inspection ID');
  }

  void resetEditorStateAfterSuccessfulSubmission() {
    form.value = FormCModel();
    selectedCulvertTypes.clear();
    selectedCulvertMaterials.clear();
    selectedInletStructures.clear();
    selectedOutletStructures.clear();
    sectionCheckboxes.updateAll((_, __) => true);
    useCurrentLocation.value = false;
    isReviewMode.value = false;
    isResumeDraft = false;
    baseFormController.resetFormCEditorState();

    if (pageController != null && pageController!.hasClients) {
      pageController!.jumpToPage(0);
    }
    form.refresh();
  }

  void prefillFromPreviousInspection(
    FormCModel previous, {
    required String parentRecID,
    required String inspectionDate,
    String? packageID,
    String? districtID,
    String? roadID,
    String? referenceNo,
  }) {
    // Copy the inspection answers into a new editable model. Never carry the
    // previous child inspection identity or date into the new submission.
    final prefilled = FormCModel.fromJsonDraft(previous.toDraftJson());
    prefilled.recID = parentRecID;
    prefilled.inspectionDate = inspectionDate;
    prefilled.packageId = packageID ?? previous.packageId;
    prefilled.districtId = districtID ?? previous.districtId;
    prefilled.roadId = roadID ?? previous.roadId;
    prefilled.referenceNo = referenceNo ?? previous.referenceNo;
    form.value = prefilled;
    form.refresh();
  }

  Future<void> loadReviewData() async {
    debugPrint('=== FormC2 loadReviewData ===');
    debugPrint('recID from args: ${Get.arguments['recID']}');
    debugPrint('formPage: ${Get.arguments['formPage']}');
    debugPrint('baseFormController.recID: ${baseFormController.recID}');
    try {
      baseFormController.configureContext(
        formType: 'C',
        recID: Get.arguments['recID']?.toString() ?? '',
        reviewMode: true,
      );
      await Future.wait(
          [baseFormController.loadPhoto(), baseFormController.loadRemarks()]);
    } catch (e) {
      Get.log("Load Review Data Error: $e");
    }
  }

  // -- Inheritance of material data from the previous record when a new inspection record is created.
  Future<void> _loadPreviousData() async {
    try {
      final parentRecID = Get.arguments['recID']?.toString() ?? "";
      final inspectionDate = DateFormat('yyyy-MM-dd')
          .format(Get.arguments['inspectionDate'] as DateTime);
      setRecID = parentRecID;
      setInspectionDate = inspectionDate;

      final detailsController = mainListingDetailsController;
      if (detailsController != null) {
        setPackageID(detailsController.packageID);
        setDistrictID(detailsController.districtID);
        setRoadID(detailsController.routeID);
        setReferenceNo = detailsController.referenceNo;
      }

      final previousInsRecID =
          Get.arguments['previousRecID']?.toString().trim() ?? '';
      if (previousInsRecID.isNotEmpty) {
        state.value = LoaderState.loading;
        final Form_C_InspectionDetailsModel details = await repository
            .showInspectionDetailsFormC(insRecID: previousInsRecID);

        if (details.data.isNotEmpty) {
          prefillFromPreviousInspection(
            details.data.first,
            parentRecID: parentRecID,
            inspectionDate: inspectionDate,
            packageID: detailsController?.packageID,
            districtID: detailsController?.districtID,
            roadID: detailsController?.routeID,
            referenceNo: detailsController?.referenceNo,
          );
        }
      }

      // Legacy field-by-field prefill kept below as reference; the model copy
      // above now applies the same data consistently.
      // for (var e in details.data) {
      //   setParkingPosition = conditionYesOrNo(e.parkingPosition ?? "");
      //   setAccessCondition = conditionYesOrNo(e.accessCondition ?? "");
      //   setPotentialHazard = conditionYesOrNo(e.potentialHazard ?? "");
      //   setFinishedRoadLevel = e.finishedRoadLevel ?? "";
      //   setCatchmentArea = e.catchmentArea ?? "";
      //   setDesignFlow = e.designFlow ?? "";
      //   setPrecastInSitu = e.precastInSitu ?? "";
      //   setBarrelNumberSize = e.barrelNumberSize ?? "";
      //   setInletLevel = e.inletLevel ?? "";
      //   setOutletLevel = e.outletLevel ?? "";
      //   setCulvertSkew = e.culvertSkew ?? "";
      //   setCulvertLength = e.culvertLength ?? "";
      //   setCulvertType = e.culvertType!;
      //   setCulvertMaterial = e.culvertMaterial!;
      //   setInletStructure = e.inletStructure!;
      //   setOutletStructure = e.outletStructure!;
      //
      //   setCulvertMarkerDistress = e.culvertMarkerDistress ?? "";
      //   setCulvertMarkerSeverity = e.culvertMarkerSeverity ?? "0";
      //
      //   setWaterwayDistress = e.waterwayDistress ?? "";
      //   setWaterwayDistressOther = e.waterwayDistressOther ?? "";
      //   setWaterwaySeverity = e.waterwaySeverity ?? "0";
      //
      //   setEmbankmentDistress = e.embankmentDistress ?? "";
      //   setEmbankmentDistressOther = e.embankmentDistressOther ?? "";
      //   setEmbankmentSeverity = e.embankmentSeverity ?? "0";
      //
      //   setHeadwallInletDistress = e.headwallInletDistress ?? "";
      //   setHeadwallInletDistressOther = e.headwallInletDistressOther ?? "";
      //   setHeadwallInletSeverity = e.headwallInletSeverity ?? "0";
      //
      //   setWingwallInletDistress = e.wingwallInletDistress ?? "";
      //   setWingwallInletDistressOther = e.wingwallInletDistressOther ?? "";
      //   setWingwallInletSeverity = e.wingwallInletSeverity ?? "0";
      //
      //   setApronInletDistress = e.apronInletDistress ?? "";
      //   setApronInletDistressOther = e.apronInletDistressOther ?? "";
      //   setApronInletSeverity = e.apronInletSeverity ?? "0";
      //
      //   setRiprapInletDistress = e.riprapInletDistress ?? "";
      //   setRiprapInletDistressOther = e.riprapInletDistressOther ?? "";
      //   setRiprapInletSeverity = e.riprapInletSeverity ?? "0";
      //
      //   setHeadwallOutletDistress = e.headwallOutletDistress ?? "";
      //   setHeadwallOutletDistressOther = e.headwallOutletDistressOther ?? "";
      //   setHeadwallOutletSeverity = e.headwallOutletSeverity ?? "0";
      //
      //   setWingwallOutletDistress = e.wingwallOutletDistress ?? "";
      //   setWingwallOutletDistressOther = e.wingwallOutletDistressOther ?? "";
      //   setWingwallOutletSeverity = e.wingwallOutletSeverity ?? "0";
      //
      //   setApronOutletDistress = e.apronOutletDistress ?? "";
      //   setApronOutletDistressOther = e.apronOutletDistressOther ?? "";
      //   setApronOutletSeverity = e.apronOutletSeverity ?? "0";
      //
      //   setRiprapOutletDistress = e.riprapOutletDistress ?? "";
      //   setRiprapOutletDistressOther = e.riprapOutletDistressOther ?? "";
      //   setRiprapOutletSeverity = e.riprapOutletSeverity ?? "0";
      //
      //   setBarrel1Distress = e.barrel1Distress ?? "";
      //   setBarrel1DistressOther = e.barrel1DistressOther ?? "";
      //   setBarrel1Severity = e.barrel1Severity ?? "0";
      //
      //   setBarrel2Distress = e.barrel2Distress ?? "";
      //   setBarrel2DistressOther = e.barrel2DistressOther ?? "";
      //   setBarrel2Severity = e.barrel2Severity ?? "0";
      //
      //   setBarrel3Distress = e.barrel3Distress ?? "";
      //   setBarrel3DistressOther = e.barrel3DistressOther ?? "";
      //   setBarrel3Severity = e.barrel3Severity ?? "0";
      //
      //   setBarrel4Distress = e.barrel4Distress ?? "";
      //   setBarrel4DistressOther = e.barrel4DistressOther ?? "";
      //   setBarrel4Severity = e.barrel4Severity ?? "0";
      //
      //   setCulvertApproachConditionDistress = e.culvertApproachConditionDistress ?? "";
      //   setCulvertApproachConditionDistressOther = e.culvertApproachConditionDistressOther ?? "";
      //   setCulvertApproachConditionSeverity = e.culvertApproachConditionSeverity ?? "0";
      // }
      form.refresh();
      state.value = LoaderState.loaded;
    } catch (err) {
      Get.log(err.toString());
      state.value = LoaderState.failure;
    }
  }

  Future<void> submitNewRecord() async {
    setPackageID(baseFormController.getPackageID);
    setDistrictID(baseFormController.getDistrictID);
    setRoadID(baseFormController.getRoadID);

    try {
      state.value = LoaderState.loading;
      //save new record without inspection date first
      final payload = form.value.toJson();
      _applyUncheckedSections(payload);
      final response = await FormRepository(formType: "C")
          .submitNewInspectionForm(mapForm: payload);
      state.value = LoaderState.loaded;
      //back to main listing screen
      Get.back();
      //apply filters so it show new data saved just now
      await mainListingController!.apply(
        packageID: getPackageID!,
        districtID: getDistrictID!,
        routeID: getRoadID!,
        refNo: getReferenceNo,
      );

      SmartDialog.showToast(response.data['data']);
    } catch (e) {
      Get.log(e.toString());
      state.value = LoaderState.failure;
      SmartDialog.showToast("Failed submit");
    }
  }

  Future<void> submitNewInspection() async {
    if (!_workflow.beginSubmission()) return;
    try {
      await _submitNewInspection();
    } finally {
      _workflow.endSubmission();
    }
  }

  Future<void> _submitNewInspection() async {
    debugPrint('=== submitNewInspection Form C ===');
    debugPrint('recID: ${form.value.recID}');
    debugPrint('inspection_date: ${form.value.inspectionDate}');
    debugPrint(
        'formRemarks data: ${baseFormController.formRemarks.value.data?.length}');
    debugPrint(
        'formRemarks PartB SP: ${baseFormController.formRemarks.value.data?.first.spRemarksPartB}');
    debugPrint(
        'formRemarks PartB Cons: ${baseFormController.formRemarks.value.data?.first.consRemarksPartB}');
    debugPrint(
        'photoToUpload count: ${baseFormController.photoToUpload.length}');
    debugPrint('currentRole: ${baseFormController.currentRole}');

    if (!_validateSubmission()) return;

    var serverSubmissionCompleted = false;

    try {
      state.value = LoaderState.loading;

      form.value.investigation = baseFormController.getInvestigation;

      final submitPayload = form.value.toAPISubmitJson();
      _applyUncheckedSections(submitPayload);

      Get.log("Submitting payload: ${jsonEncode(submitPayload)}");

      final submission = await _submissionCoordinator.submit(
        existingInspectionID: _workflow.submittedInspectionID,
        submitMain: () async {
          final res = await FormRepository(formType: "C")
              .submitNewInspectionFormC(mapForm: submitPayload);

          debugPrint('=== submitNewInspectionFormC Response ===');
          debugPrint('statusCode: ${res.statusCode}');
          debugPrint('data: ${res.data}');
          debugPrint('===========================================');

          return res.data;
        },
        resolveInspectionID: (responseData) => resolveSubmittedInspectionID(
          responseData,
          parentRecID: form.value.recID ?? '',
        ),
        onInspectionIDResolved: (inspectionID) {
          _workflow.submittedInspectionID = inspectionID;

          debugPrint(
            'Main form submitted, inspection ID: $inspectionID',
          );
        },
        submitSupplementary: (
          inspectionID,
          resumeExistingUploads,
        ) async {
          debugPrint(
            'Calling baseFormController.submitNewInspection($inspectionID)',
          );

          await baseFormController.submitNewInspection(
            inspectionID,
            clearPendingPhotosOnSuccess: false,
            resumeExistingPhotoUploads: resumeExistingUploads,
          );

          debugPrint(
            'baseFormController.submitNewInspection completed',
          );
        },
        saveFallback: (status, errorLog) => saveDraft(
          status: status,
          errorLog: errorLog,
          allowDuringSubmission: true,
        ),
      );

      if (!submission.completed) {
        Get.log(
          "API Error intercepted: ${submission.error}",
        );

        SmartDialog.showToast(
          "Connection issue. Saving to drafts...",
          displayTime: const Duration(seconds: 3),
        );

        return;
      }

      // From here onward the server submission is already successful.
      serverSubmissionCompleted = true;
      _workflow.submissionCompleted = true;

      final latestRecId = submission.inspectionID;

      // Capture draft state before cleanup resets it.
      final wasResumeDraft = isResumeDraft;

      // -----------------------------
      // LOCAL DRAFT CLEANUP
      // -----------------------------
      try {
        await removeSubmittedDraft();
      } catch (e) {
        Get.log(
          'Post-submit Form C draft cleanup warning: $e',
        );
      }

      final openedFromDetails =
          mainListingDetailsController != null;

      // -----------------------------
      // REFRESH INSPECTION RECORD LIST
      // -----------------------------
      if (openedFromDetails) {
        try {
          await mainListingDetailsController!
              .refreshUntilInspectionVisible(
            latestRecId,
          );
        } catch (e) {
          Get.log(
            'Post-submit Form C list refresh warning: $e',
          );
        }
      }

      // Capture navigation data BEFORE resetting the form.
      final parentRecID = form.value.recID ?? '';

      final navigationArguments = <String, dynamic>{
        'formType': 'C',
        'formTitle':
            'CULVERT VISUAL INSPECTION (RECORD & FORM)',
        'parentID': parentRecID,
        'recID': parentRecID,
        'isMainListing': true,
        'packageID': form.value.packageId ?? '',
        'districtID': form.value.districtId ?? '',
        'routeID': form.value.roadId ?? '',
        'refNo': form.value.referenceNo ?? '',
      };

      // -----------------------------
      // RESET EDITOR
      // -----------------------------
      try {
        resetEditorStateAfterSuccessfulSubmission();
      } catch (e) {
        Get.log(
          'Post-submit Form C editor reset warning: $e',
        );
      }

      state.value = LoaderState.loaded;

      SmartDialog.showToast(
        'Inspection submitted successfully',
      );

      // -----------------------------
      // NAVIGATION
      // -----------------------------

      // Most common case:
      // draft/new inspection opened from Form C details page.
      if (openedFromDetails) {
        Get.back(result: true);
        return;
      }

      // Draft opened from somewhere else.
      // Send user directly to Form C inspection records.
      if (wasResumeDraft && parentRecID.isNotEmpty) {
        Get.offNamed(
          '/main_listing_form_details',
          arguments: navigationArguments,
        );
        return;
      }

      // Normal inspection flow without an existing details controller.
      if (parentRecID.isNotEmpty) {
        Get.offNamed(
          '/main_listing_form_details',
          arguments: navigationArguments,
        );
        return;
      }

      // Last fallback.
      Get.back();
    } catch (e) {
      // If the server already accepted the inspection,
      // do not show a false failure message.
      if (serverSubmissionCompleted) {
        Get.log(
          'Post-submit Form C local/UI error '
          '(server submission already succeeded): $e',
        );

        state.value = LoaderState.loaded;

        SmartDialog.showToast(
          'Inspection submitted successfully',
        );

        // Do not leave the user on a submit-able form.
        if (Get.currentRoute == '/base_form') {
          Get.back(result: true);
        }

        return;
      }

      // Genuine submission failure.
      Get.log(
        "Internal Error during Form C submit: ${e.toString()}",
      );

      state.value = LoaderState.failure;

      SmartDialog.showToast(
        "Failed to process inspection",
      );
    }
  }

  Future<void> fetchCurrentLocation(bool value) async {
    useCurrentLocation.value = value;
    if (!value) return;

    try {
      state.value = LoaderState.loading;
      // 1. Check if service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        useCurrentLocation.value = false;
        Get.snackbar("Error", "Location services are disabled.");
        return;
      }

      // 2. Check Permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          useCurrentLocation.value = false;
          Get.snackbar("Error", "Location permissions are denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        useCurrentLocation.value = false;
        Get.snackbar("Error", "Location permissions are permanently denied.");
        return;
      }

      // 3. Get Position
      // Using high accuracy for engineering/road forms
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      // 4. Define the Projections
      // 'EPSG:4326' is the standard GPS format (WGS84)
      var pointSrc = proj4.Point(x: position.longitude, y: position.latitude);
      var projSrc = proj4.Projection.get('EPSG:4326')!;

      // EPSG:3377 - GDM2000 / Sarawak RSO
      var strSarawakRSO =
          '+proj=omerc +lat_0=4 +lonc=115 +alpha=53.3158204722222 +k=0.99984 +x_0=2000000 +y_0=5000000 +ellps=GRS80 +units=m +no_defs';

      var projDst = proj4.Projection.parse(
          strSarawakRSO); // Change this variable to swap formats

      // 5. Perform the Conversion
      var pointForward = projSrc.transform(projDst, pointSrc);

      // 6. Update the fields
      setGpsEasting = pointForward.x.toStringAsFixed(3);
      setGpsNorthing = pointForward.y.toStringAsFixed(3);

      state.value = LoaderState.loaded;
    } catch (e) {
      useCurrentLocation.value = false;
      state.value = LoaderState.failure;
      Get.snackbar("Error", "Failed to get location: $e");
      Get.log(e.toString());
    }
  }

  int? get _currentDraftId {
    if (_workflow.activeDraftId != null) return _workflow.activeDraftId;
    final arguments = Get.arguments;
    _workflow.activeDraftId =
        FormDraftController.draftIdFromArguments(arguments);
    return _workflow.activeDraftId;
  }

  Future<void> removeSubmittedDraft() async {
    final draftId = _currentDraftId;
    if (draftId == null) return;

    if (!Get.isRegistered<FormDraftController>()) {
      Get.put(FormDraftController());
    }
    await InspectionDraftStore(Get.find<FormDraftController>())
        .deleteRequired(draftId, formType: 'Form C');

    mainListingDetailsController?.localDrafts
        .removeWhere((draft) => draft.id == draftId);
    _workflow.clearDraft();
    final arguments = Get.arguments;
    if (arguments is Map) {
      arguments.remove('draftId');
      arguments['isResumeDraft'] = false;
    }
  }

  Future<bool> saveDraft({
    DraftStatus? status,
    String? errorLog,
    bool allowDuringSubmission = false,
    bool navigateAfterSave = true,
  }) async {
    if (!_workflow.beginDraftSave(
      allowDuringSubmission: allowDuringSubmission,
    )) {
      return false;
    }

    if (!Get.isRegistered<FormDraftController>()) {
      Get.put(FormDraftController());
    }

    final formDraftController = Get.find<FormDraftController>();

    try {
      state.value = LoaderState.loading;

      // --- Check if we are resuming a draft ---
      final wasResumeDraft = isResumeDraft;
      final currentDraftId = _currentDraftId;

      // --- 1. Combine Form C data with BaseFormController Data ---
      Map<String, dynamic> combinedJson = form.value.toDraftJson();

      _applyUncheckedSections(combinedJson);
      combinedJson['section_checkboxes'] =
          sectionCheckboxes.map((k, v) => MapEntry(k, v));
      final detailsContext = mainListingDetailsController;
      final selectedContext = detailsContext?.selectedFormCModel;
      InspectionDraftSupport.addCommonData(
        combinedJson,
        baseController: baseFormController,
        useCurrentLocation: useCurrentLocation.value,
        submittedInspectionID: _workflow.submittedInspectionID,
        packageName: detailsContext?.packageName.isNotEmpty == true
            ? detailsContext!.packageName
            : selectedContext?.projectName ?? selectedContext?.package ?? '',
        districtName: detailsContext?.districtName.isNotEmpty == true
            ? detailsContext!.districtName
            : selectedContext?.district ?? '',
        roadName: detailsContext?.roadName.isNotEmpty == true
            ? detailsContext!.roadName
            : selectedContext?.roadName ?? '',
      );

      // 2. Convert the ENTIRE combined state to a JSON string
      final String formDataJson = jsonEncode(combinedJson);

      debugPrint('\n========== SAVE DRAFT DEBUG ==========');
      debugPrint('isResumeDraft: $isResumeDraft');
      debugPrint('currentDraftId: $currentDraftId');
      debugPrint('Form type: Form C');
      debugPrint('Combined JSON keys: ${combinedJson.keys.toList()}');
      debugPrint('Full draft JSON: $formDataJson');
      debugPrint('======================================\n');

      final savedDraftID =
          await InspectionDraftStore(formDraftController).upsert(
        draftID: currentDraftId,
        formType: 'Form C',
        data: combinedJson,
        status: status ?? DraftStatus.draft,
        mediaPaths: InspectionDraftSupport.encodeMediaPaths(baseFormController),
        errorLog: errorLog,
      );
      if (currentDraftId == null) {
        _workflow.attachDraft(savedDraftID);
        final arguments = Get.arguments;
        if (arguments is Map) {
          arguments['draftId'] = savedDraftID;
          arguments['isResumeDraft'] = true;
        }
      }

      state.value = LoaderState.loaded;
      SmartDialog.showToast("Draft saved successfully.");

      if (navigateAfterSave) {
        Get.back();
        if (!wasResumeDraft && mainListingDetailsController != null) {
          await mainListingDetailsController!.load();
        }
      }
      return true;
    } catch (e) {
      Get.log("Save Draft Error: ${e.toString()}");
      state.value = LoaderState.failure;
      SmartDialog.showToast("Failed to save draft");
      return false;
    } finally {
      _workflow.endDraftSave();
    }
  }

  Future<void> _resumeDraft(int draftId) async {
    try {
      state.value = LoaderState.loading;

      if (!Get.isRegistered<FormDraftController>()) {
        Get.lazyPut(() => FormDraftController());
      }
      final draftCtrl = Get.find<FormDraftController>();

      final draftData = await draftCtrl.getDraftById(draftId);

      if (draftData != null) {
        Get.log("Resuming Draft ID: $draftId");

        final Map<String, dynamic> jsonData = jsonDecode(draftData.formData);
        // Restore section checkbox states BEFORE setting form.value
        // so the UI knows which sections are unchecked before it reads severity values.
        if (jsonData['section_checkboxes'] != null) {
          final saved = jsonData['section_checkboxes'] as Map<String, dynamic>;
          for (final code in sectionCheckboxes.keys.toList()) {
            sectionCheckboxes[code] = saved[code] == true;
          }
        }

        // 1. Decode Form C Model specifically using fromJsonDraft!
        form.value = FormCModel.fromJsonDraft(jsonData);
        form.refresh();

        final restored = InspectionDraftSupport.restoreCommonData(
          jsonData,
          mediaPaths: draftData.mediaPaths,
          baseController: baseFormController,
        );
        useCurrentLocation.value = restored.useCurrentLocation;
        _workflow.submittedInspectionID = restored.submittedInspectionID;
      }
      state.value = LoaderState.loaded;
    } catch (e) {
      Get.log("Error loading draft: $e");
      state.value = LoaderState.failure;
      SmartDialog.showToast("Failed to load draft data.");
    }
  }

  void backPage() {
    if (pageController != null && pageController!.hasClients) {
      pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  bool _validateSubmission() {
    List<String> errors = [];

    // Define each section with its value, the expected 'Other' code, and the 'Other' text value
    final List<Map<String, dynamic>> validationList = [
      {
        "name": "2A",
        "val": getWaterwayDistress,
        "otherCode": "C12",
        "otherVal": getWaterwayDistressOther
      },
      {
        "name": "2B",
        "val": getEmbankmentDistress,
        "otherCode": "C12",
        "otherVal": getEmbankmentDistressOther
      },
      {
        "name": "3A",
        "val": getHeadwallInletDistress,
        "otherCode": "C20",
        "otherVal": getHeadwallInletDistressOther
      },
      {
        "name": "3B",
        "val": getWingwallInletDistress,
        "otherCode": "C20",
        "otherVal": getWingwallInletDistressOther
      },
      {
        "name": "3C",
        "val": getApronInletDistress,
        "otherCode": "C20",
        "otherVal": getApronInletDistressOther
      },
      {
        "name": "3D",
        "val": getRiprapInletDistress,
        "otherCode": "C20",
        "otherVal": getRiprapInletDistressOther
      },
      {
        "name": "3E",
        "val": getHeadwallOutletDistress,
        "otherCode": "C20",
        "otherVal": getHeadwallOutletDistressOther
      },
      {
        "name": "3F",
        "val": getWingwallOutletDistress,
        "otherCode": "C20",
        "otherVal": getWingwallOutletDistressOther
      },
      {
        "name": "3G",
        "val": getApronOutletDistress,
        "otherCode": "C20",
        "otherVal": getApronOutletDistressOther
      },
      {
        "name": "3H",
        "val": getRiprapOutletDistress,
        "otherCode": "C20",
        "otherVal": getRiprapOutletDistressOther
      },
      {
        "name": "4A",
        "val": getBarrel1Distress,
        "otherCode": "C32",
        "otherVal": getBarrel1DistressOther
      },
      {
        "name": "4B",
        "val": getBarrel2Distress,
        "otherCode": "C32",
        "otherVal": getBarrel2DistressOther
      },
      {
        "name": "4C",
        "val": getBarrel3Distress,
        "otherCode": "C32",
        "otherVal": getBarrel3DistressOther
      },
      {
        "name": "4D",
        "val": getBarrel4Distress,
        "otherCode": "C32",
        "otherVal": getBarrel4DistressOther
      },
      {
        "name": "5A",
        "val": getCulvertApproachConditionDistress,
        "otherCode": "C36",
        "otherVal": getCulvertApproachConditionDistressOther
      },
    ];

    List<String> missingDistress = [];
    List<String> missingOtherDetails = [];

    // -- CHECK DISTRESS & "OTHER" FIELDS --
    for (var item in validationList) {
      String name = item["name"];
      // Skip unchecked sections
      if (!isSectionChecked(name)) continue;
      String val = item["val"];
      String? otherCode = item["otherCode"];
      String? otherVal = item["otherVal"];

      // 1. Check if primary distress is empty
      if (val.trim().isEmpty) {
        missingDistress.add(name);
      }
      // 2. Skip "ND" - it's a valid No Distress selection
      else if (val == "ND") {
        // No Distress, skip further checks
      }
      // 3. Check if 'Other' was selected but the text field is empty
      else if (otherCode != null && val == otherCode) {
        if (otherVal == null || otherVal.trim().isEmpty) {
          missingOtherDetails.add(name);
        }
      }
    }

    if (missingDistress.isNotEmpty) {
      errors.add("Distress not selected for: ${missingDistress.join(', ')}.");
    }

    if (missingOtherDetails.isNotEmpty) {
      errors.add(
          "Please specify details for 'Other' in: ${missingOtherDetails.join(', ')}.");
    }

    errors.addAll(commonInspectionValidationErrors(
      photoCount: baseFormController.photoToUpload.length,
      photoLimit: baseFormController.limitToUpload.value,
      photosMissingRemarks: baseFormController.missingPhotoRemarkNumbers,
      investigation: baseFormController.getInvestigation,
    ));

    // --- FINAL CHECK & SHOW DIALOG ---
    if (errors.isNotEmpty) {
      String combinedErrorMessage = errors.map((e) => '• $e').join('\n');
      _showValidationErrorDialog(combinedErrorMessage);
      return false;
    }

    return true;
  }

  void _showValidationErrorDialog(String errorMessage) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: Container(
          width: Get.width * 0.8,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xfff3f8fe),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: 48, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text(
                "Missing Information",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              // We inject the flexible error message right here
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 28),
              NeumorphicButton(
                onPressed: () => Get.back(),
                style: NeumorphicStyle(
                  depth: 4,
                  color: Colors.blueAccent,
                  boxShape:
                      NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                child: const Text(
                  "Fix It",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1. Inspection Data
  //GETTERS
  String? get getPackageID => form.value.packageId;
  String? get getDistrictID => form.value.districtId;
  String? get getRoadID => form.value.roadId;

  get getRecID => form.value.recID ?? "";
  get getInspectionDate => form.value.inspectionDate ?? "";
  get getReferenceNo => form.value.referenceNo ?? "";
  get getChainage => form.value.chainage ?? "";
  get getStructureCode => form.value.structureCode ?? "";
  get getGpsEasting => form.value.gpsEasting ?? "";
  get getGpsNorthing => form.value.gpsNorthing ?? "";
  get getFinishedRoadLevel => form.value.finishedRoadLevel ?? "";
  get getCatchmentArea => form.value.catchmentArea ?? "";
  get getDesignFlow => form.value.designFlow ?? "";
  get getPrecastInSitu => form.value.precastInSitu ?? "";
  get getBarrelNumberSize => form.value.barrelNumberSize ?? "";
  get getInletLevel => form.value.inletLevel ?? "";
  get getOutletLevel => form.value.outletLevel ?? "";
  get getCulvertSkew => form.value.culvertSkew ?? "";
  get getCulvertLength => form.value.culvertLength ?? "";
  get getCulvertType => form.value.culvertType ?? [];
  get getCulvertMaterial => form.value.culvertMaterial ?? [];
  get getInletStructure => form.value.inletStructure ?? [];
  get getOutletStructure => form.value.outletStructure ?? [];

  //SETTERS
  void setPackageID(String? v) => form.update((val) => val?.packageId = v);
  void setDistrictID(String? v) => form.update((val) => val?.districtId = v);
  void setRoadID(String? v) => form.update((val) => val?.roadId = v);

  set setRecID(String value) => form.value.recID = value;
  set setInspectionDate(String value) => form.value.inspectionDate = value;
  set setReferenceNo(String value) => form.value.referenceNo = value;

  set setChainage(String value) => form.value.chainage = value;
  set setStructureCode(String value) => form.value.structureCode = value;
  set setGpsEasting(String value) =>
      form.update((val) => form.value.gpsEasting = value);
  set setGpsNorthing(String value) =>
      form.update((val) => form.value.gpsNorthing = value);
  set setFinishedRoadLevel(String value) =>
      form.value.finishedRoadLevel = value;
  set setCatchmentArea(String value) => form.value.catchmentArea = value;
  set setDesignFlow(String value) => form.value.designFlow = value;
  set setPrecastInSitu(String value) => form.value.precastInSitu = value;
  set setBarrelNumberSize(String value) => form.value.barrelNumberSize = value;
  set setInletLevel(String value) => form.value.inletLevel = value;
  set setOutletLevel(String value) => form.value.outletLevel = value;
  set setCulvertSkew(String value) => form.value.culvertSkew = value;
  set setCulvertLength(String value) => form.value.culvertLength = value;
  set setCulvertType(List<String> value) => form.value.culvertType = value;
  set setCulvertMaterial(List<String> value) =>
      form.value.culvertMaterial = value;
  set setInletStructure(List<String> value) =>
      form.value.inletStructure = value;
  set setOutletStructure(List<String> value) =>
      form.value.outletStructure = value;

  //2. Side Condition
  //GETTERS
  get getParkingPosition => form.value.parkingPosition;
  get getAccessCondition => form.value.accessCondition;
  get getPotentialHazard => form.value.potentialHazard;
  //SETTER
  set setParkingPosition(String value) => form.value.parkingPosition = value;
  set setAccessCondition(String value) => form.value.accessCondition = value;
  set setPotentialHazard(String value) => form.value.potentialHazard = value;

  //3. Inspection Items - Getters
  get getCulvertMarkerDistress => form.value.culvertMarkerDistress ?? "";
  get getCulvertMarkerSeverity => form.value.culvertMarkerSeverity ?? "";
  get getWaterwayDistress => form.value.waterwayDistress ?? "";
  get getWaterwaySeverity => form.value.waterwaySeverity ?? "";
  get getEmbankmentDistress => form.value.embankmentDistress ?? "";
  get getEmbankmentSeverity => form.value.embankmentSeverity ?? "";
  get getHeadwallInletDistress => form.value.headwallInletDistress ?? "";
  get getHeadwallInletSeverity => form.value.headwallInletSeverity ?? "";
  get getWingwallInletDistress => form.value.wingwallInletDistress ?? "";
  get getWingwallInletSeverity => form.value.wingwallInletSeverity ?? "";
  get getApronInletDistress => form.value.apronInletDistress ?? "";
  get getApronInletSeverity => form.value.apronInletSeverity ?? "";
  get getRiprapInletDistress => form.value.riprapInletDistress ?? "";
  get getRiprapInletSeverity => form.value.riprapInletSeverity ?? "";
  get getHeadwallOutletDistress => form.value.headwallOutletDistress ?? "";
  get getHeadwallOutletSeverity => form.value.headwallOutletSeverity ?? "";
  get getWingwallOutletDistress => form.value.wingwallOutletDistress ?? "";
  get getWingwallOutletSeverity => form.value.wingwallOutletSeverity ?? "";
  get getApronOutletDistress => form.value.apronOutletDistress ?? "";
  get getApronOutletSeverity => form.value.apronOutletSeverity ?? "";
  get getRiprapOutletDistress => form.value.riprapOutletDistress ?? "";
  get getRiprapOutletSeverity => form.value.riprapOutletSeverity ?? "";
  get getBarrel1Distress => form.value.barrel1Distress ?? "";
  get getBarrel1Severity => form.value.barrel1Severity ?? "";
  get getBarrel2Distress => form.value.barrel2Distress ?? "";
  get getBarrel2Severity => form.value.barrel2Severity ?? "";
  get getBarrel3Distress => form.value.barrel3Distress ?? "";
  get getBarrel3Severity => form.value.barrel3Severity ?? "";
  get getBarrel4Distress => form.value.barrel4Distress ?? "";
  get getBarrel4Severity => form.value.barrel4Severity ?? "";
  get getCulvertApproachConditionDistress =>
      form.value.culvertApproachConditionDistress ?? "";
  get getCulvertApproachConditionSeverity =>
      form.value.culvertApproachConditionSeverity ?? "";

  // Setters
  set setCulvertMarkerDistress(String value) =>
      form.value.culvertMarkerDistress = value;
  set setCulvertMarkerSeverity(String value) =>
      form.value.culvertMarkerSeverity = value;
  set setWaterwayDistress(String value) => form.value.waterwayDistress = value;
  set setWaterwaySeverity(String value) => form.value.waterwaySeverity = value;
  set setEmbankmentDistress(String value) =>
      form.value.embankmentDistress = value;
  set setEmbankmentSeverity(String value) =>
      form.value.embankmentSeverity = value;
  set setHeadwallInletDistress(String value) =>
      form.value.headwallInletDistress = value;
  set setHeadwallInletSeverity(String value) =>
      form.value.headwallInletSeverity = value;
  set setWingwallInletDistress(String value) =>
      form.value.wingwallInletDistress = value;
  set setWingwallInletSeverity(String value) =>
      form.value.wingwallInletSeverity = value;
  set setApronInletDistress(String value) =>
      form.value.apronInletDistress = value;
  set setApronInletSeverity(String value) =>
      form.value.apronInletSeverity = value;
  set setRiprapInletDistress(String value) =>
      form.value.riprapInletDistress = value;
  set setRiprapInletSeverity(String value) =>
      form.value.riprapInletSeverity = value;
  set setHeadwallOutletDistress(String value) =>
      form.value.headwallOutletDistress = value;
  set setHeadwallOutletSeverity(String value) =>
      form.value.headwallOutletSeverity = value;
  set setWingwallOutletDistress(String value) =>
      form.value.wingwallOutletDistress = value;
  set setWingwallOutletSeverity(String value) =>
      form.value.wingwallOutletSeverity = value;
  set setApronOutletDistress(String value) =>
      form.value.apronOutletDistress = value;
  set setApronOutletSeverity(String value) =>
      form.value.apronOutletSeverity = value;
  set setRiprapOutletDistress(String value) =>
      form.value.riprapOutletDistress = value;
  set setRiprapOutletSeverity(String value) =>
      form.value.riprapOutletSeverity = value;
  set setBarrel1Distress(String value) => form.value.barrel1Distress = value;
  set setBarrel1Severity(String value) => form.value.barrel1Severity = value;
  set setBarrel2Distress(String value) => form.value.barrel2Distress = value;
  set setBarrel2Severity(String value) => form.value.barrel2Severity = value;
  set setBarrel3Distress(String value) => form.value.barrel3Distress = value;
  set setBarrel3Severity(String value) => form.value.barrel3Severity = value;
  set setBarrel4Distress(String value) => form.value.barrel4Distress = value;
  set setBarrel4Severity(String value) => form.value.barrel4Severity = value;
  set setCulvertApproachConditionDistress(String value) =>
      form.value.culvertApproachConditionDistress = value;
  set setCulvertApproachConditionSeverity(String value) =>
      form.value.culvertApproachConditionSeverity = value;

  // --- "Other" Field Getters ---
  get getWaterwayDistressOther => form.value.waterwayDistressOther ?? "";
  get getEmbankmentDistressOther => form.value.embankmentDistressOther ?? "";
  get getHeadwallInletDistressOther =>
      form.value.headwallInletDistressOther ?? "";
  get getWingwallInletDistressOther =>
      form.value.wingwallInletDistressOther ?? "";
  get getApronInletDistressOther => form.value.apronInletDistressOther ?? "";
  get getRiprapInletDistressOther => form.value.riprapInletDistressOther ?? "";
  get getHeadwallOutletDistressOther =>
      form.value.headwallOutletDistressOther ?? "";
  get getWingwallOutletDistressOther =>
      form.value.wingwallOutletDistressOther ?? "";
  get getApronOutletDistressOther => form.value.apronOutletDistressOther ?? "";
  get getRiprapOutletDistressOther =>
      form.value.riprapOutletDistressOther ?? "";
  get getBarrel1DistressOther => form.value.barrel1DistressOther ?? "";
  get getBarrel2DistressOther => form.value.barrel2DistressOther ?? "";
  get getBarrel3DistressOther => form.value.barrel3DistressOther ?? "";
  get getBarrel4DistressOther => form.value.barrel4DistressOther ?? "";
  get getCulvertApproachConditionDistressOther =>
      form.value.culvertApproachConditionDistressOther ?? "";

  // --- "Other" Field Setters ---
  set setWaterwayDistressOther(String value) =>
      form.value.waterwayDistressOther = value;
  set setEmbankmentDistressOther(String value) =>
      form.value.embankmentDistressOther = value;
  set setHeadwallInletDistressOther(String value) =>
      form.value.headwallInletDistressOther = value;
  set setWingwallInletDistressOther(String value) =>
      form.value.wingwallInletDistressOther = value;
  set setApronInletDistressOther(String value) =>
      form.value.apronInletDistressOther = value;
  set setRiprapInletDistressOther(String value) =>
      form.value.riprapInletDistressOther = value;
  set setHeadwallOutletDistressOther(String value) =>
      form.value.headwallOutletDistressOther = value;
  set setWingwallOutletDistressOther(String value) =>
      form.value.wingwallOutletDistressOther = value;
  set setApronOutletDistressOther(String value) =>
      form.value.apronOutletDistressOther = value;
  set setRiprapOutletDistressOther(String value) =>
      form.value.riprapOutletDistressOther = value;
  set setBarrel1DistressOther(String value) =>
      form.value.barrel1DistressOther = value;
  set setBarrel2DistressOther(String value) =>
      form.value.barrel2DistressOther = value;
  set setBarrel3DistressOther(String value) =>
      form.value.barrel3DistressOther = value;
  set setBarrel4DistressOther(String value) =>
      form.value.barrel4DistressOther = value;
  set setCulvertApproachConditionDistressOther(String value) =>
      form.value.culvertApproachConditionDistressOther = value;
}
