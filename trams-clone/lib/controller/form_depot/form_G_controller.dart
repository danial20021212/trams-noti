import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;
import 'package:get/get.dart';
import 'package:tram/model/form/form_depot/form_G/form_G_main_listing_details_model.dart';
import 'package:tram/model/form/form_depot/form_G/form_G_model.dart';
import 'package:tram/model/shared/checkbox_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/form_repository.dart';
import 'package:tram/screen/form_depot/form_G/pages/inspection_items_page.dart';
import 'package:tram/screen/form_depot/form_G/pages/side_condition_page.dart';
import 'package:tram/screen/form_depot/form_G/pages/location_data_page.dart';

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

class FormGController extends GetxController {
  final InspectionWorkflowState _workflow =
      InspectionWorkflowState.fromArguments(Get.arguments);
  final InspectionSubmissionCoordinator _submissionCoordinator =
      const InspectionSubmissionCoordinator();

  bool isEditMode = Get.arguments["isEditMode"] ?? false;
  RxBool isReviewMode = false.obs;
  final String formPage = Get.arguments['formPage'] ?? 'Unknown';
  bool get isResumeDraft => _workflow.isResumeDraft;
  set isResumeDraft(bool value) => _workflow.isResumeDraft = value;

  Rx<LoaderState> state = LoaderState.initial.obs;
  late Rx<FormGModel> form;

  final repository = FormRepository(formType: 'G');

  final baseFormController = Get.find<BaseFormController>();

  MainListingController? get mainListingController =>
      Get.isRegistered<MainListingController>()
          ? Get.find<MainListingController>()
          : null;

  MainListingDetailsController? get mainListingDetailsController =>
      Get.isRegistered<MainListingDetailsController>()
          ? Get.find<MainListingDetailsController>()
          : null;

  PageController? pageController;

  RxBool useCurrentLocation = false.obs;

  // Checked items are applicable and must be completed. Unchecked items are
  // excluded from this inspection and submitted with blank item fields.
  RxMap<String, bool> inspectionItemCheckboxes = <String, bool>{
    for (final code in ['1', '2', '3', '4', '5', '6', '7', '8']) code: true,
  }.obs;

  bool isInspectionItemChecked(String code) =>
      inspectionItemCheckboxes[code] ?? true;

  void toggleInspectionItem(String code) {
    final checked = !isInspectionItemChecked(code);
    inspectionItemCheckboxes[code] = checked;
    if (!checked) _clearInspectionItemData(code);
  }

  static const Map<String, List<String>> _inspectionItemJsonKeys = {
    '1': ['barrierDistress', 'barrierCritical', 'barrierClosed'],
    '2': ['gantryBeamDistress', 'gantryBeamCritical', 'gantryBeamClosed'],
    '3': ['gantryColumnDistress', 'gantryColumnCritical', 'gantryColumnClosed'],
    '4': ['footingsDistress', 'footingsCritical', 'footingsClosed'],
    '5': ['anchorMortarDistress', 'anchorMortarCritical', 'anchorMortarClosed'],
    '6': [
      'maintenanceAccessDistress',
      'maintenanceAccessCritical',
      'maintenanceAccessClosed'
    ],
    '7': ['staticSignsDistress', 'staticSignsCritical', 'staticSignsClosed'],
    '8': ['vmsDistress', 'vmsCritical', 'vmsClosed'],
  };

  void _applyUncheckedInspectionItems(Map<String, dynamic> json) {
    for (final entry in inspectionItemCheckboxes.entries) {
      if (entry.value) continue;
      for (final key in _inspectionItemJsonKeys[entry.key] ?? const []) {
        json[key] = '';
      }
    }
  }

  void _clearInspectionItemData(String code) {
    form.update((value) {
      if (value == null) return;
      switch (code) {
        case '1':
          value.barrierDistress = null;
          value.barrierCritical = null;
          value.barrierClosed = null;
          break;
        case '2':
          value.gantryBeamDistress = null;
          value.gantryBeamCritical = null;
          value.gantryBeamClosed = null;
          break;
        case '3':
          value.gantryColumnDistress = null;
          value.gantryColumnCritical = null;
          value.gantryColumnClosed = null;
          break;
        case '4':
          value.footingsDistress = null;
          value.footingsCritical = null;
          value.footingsClosed = null;
          break;
        case '5':
          value.anchorMortarDistress = null;
          value.anchorMortarCritical = null;
          value.anchorMortarClosed = null;
          break;
        case '6':
          value.maintenanceAccessDistress = null;
          value.maintenanceAccessCritical = null;
          value.maintenanceAccessClosed = null;
          break;
        case '7':
          value.staticSignsDistress = null;
          value.staticSignsCritical = null;
          value.staticSignsClosed = null;
          break;
        case '8':
          value.vmsDistress = null;
          value.vmsCritical = null;
          value.vmsClosed = null;
          break;
      }
    });
  }

  RxList<Widget> newRecordPages = <Widget>[
    const LocationDataPage(),
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

  RxList<Widget> reviewFormG2Pages = <Widget>[
    const PhotographsPage(),
    const DistressObservedPage(),
    const GeneralCommentPage(),
    const FeedbackPage()
  ].obs;

  final RxList<CheckBoxModel> optionsYesOrNo = [
    const CheckBoxModel("0", "NO"),
    const CheckBoxModel("1", "YES"),
  ].obs;

  @override
  void onInit() async {
    super.onInit();
    form = FormGModel().obs;
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

    // if (formPage == "review_G2") {
    //   isReviewMode = true.obs;
    //   await _loadReviewData();
    // }
    if (formPage == "review_G2") {
      isReviewMode.value = true;
    }

    if (formPage == "inspection") {
      await _loadPreviousData();
    }

    if (_workflow.isResumeDraft && draftId != null) {
      await _loadDraftData(draftId);
    }
  }

  @override
  void onClose() {
    form.close();
    super.onClose();
  }

  Future<void> loadReviewData() async {
    try {
      await Future.wait(
          [baseFormController.loadPhoto(), baseFormController.loadRemarks()]);
    } catch (e) {
      Get.log("Load Review Data Error: $e");
    }
  }

  // -- Inheritance of material data from the previous record when a new inspection record is created.
  Future<void> _loadPreviousData() async {
    try {
      state.value = LoaderState.loading;

      final detailsController = mainListingDetailsController;
      setRecId = Get.arguments['recID']?.toString() ?? '';
      final inspectionDate = Get.arguments['inspectionDate'];
      if (inspectionDate is DateTime) {
        setInspectionDate = inspectionDate.toIso8601String();
      } else if (inspectionDate != null) {
        setInspectionDate = inspectionDate.toString();
      }

      if (detailsController != null) {
        setPackageID(detailsController.packageID);
        setDistrictID(detailsController.districtID);
        setRoadID(detailsController.routeID);
        final Form_G_MainListingDetailsModel formDetails =
            detailsController.formDetails.value;
        for (var e in formDetails.data) {
          setReferenceNo = e.referenceNo ?? '';
          setChainage = e.chainage ?? '';
          setStructureCode = e.structureCode ?? '';
          setGpsEasting = e.gpsEasting ?? '';
          setGpsNorthing = e.gpsNorthing ?? '';
        }
      }

      final previousRecID =
          Get.arguments['previousRecID']?.toString().trim() ?? '';
      if (previousRecID.isEmpty) {
        form.refresh();
        state.value = LoaderState.loaded;
        return;
      }

      Form_G_InspectionDetailsModel details =
          await repository.showInspectionDetails(recID: previousRecID);
      for (var e in details.data) {
        setParkingPosition = e.parkingPosition!;
        setAccessCondition = e.accessCondition!;
        setPotentialHazard = e.potentialHazard!;
      }

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

    //Get.log(jsonEncode(loadMapForm()));

    try {
      state.value = LoaderState.loading;
      //save new record without inspection date first
      setInspectionDate = "";
      final payload = form.value.toJson();
      _applyUncheckedInspectionItems(payload);
      final response = await FormRepository(formType: "G")
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
    if (!_validateSubmission()) return;
    try {
      state.value = LoaderState.loading;

      final payload = form.value.toJson();
      _applyUncheckedInspectionItems(payload);
      Get.log("Submitting payload: ${jsonEncode(payload)}");
      final submission = await _submissionCoordinator.submit(
        existingInspectionID: _workflow.submittedInspectionID,
        submitMain: () async {
          final response = await FormRepository(formType: 'G')
              .submitNewInspectionForm(mapForm: payload);
          return response.data;
        },
        resolveInspectionID: (responseData) => resolveGeneralInspectionID(
          responseData,
          formType: 'G',
        ),
        onInspectionIDResolved: (inspectionID) {
          _workflow.submittedInspectionID = inspectionID;
        },
        submitSupplementary: (inspectionID, resumeExistingUploads) =>
            baseFormController.submitNewInspection(
          inspectionID,
          clearPendingPhotosOnSuccess: false,
          resumeExistingPhotoUploads: resumeExistingUploads,
        ),
        saveFallback: (status, errorLog) => saveDraft(
          status: status,
          errorLog: errorLog,
          allowDuringSubmission: true,
        ),
      );
      if (!submission.completed) {
        Get.log("API Error intercepted: ${submission.error}");
        SmartDialog.showToast("Connection issue. Saving to drafts...",
            displayTime: const Duration(seconds: 3));
        return;
      }
      final latestRecId = submission.inspectionID;

      // 2. UI CLEANUP (Only runs if Network was 100% successful)
      // If it was a draft and successfully uploaded, delete the local draft
      await removeSubmittedDraft();
      _workflow.submissionCompleted = true;

      final openedFromDetails = mainListingDetailsController != null;
      if (openedFromDetails) {
        await mainListingDetailsController!
            .refreshUntilInspectionVisible(latestRecId);
      }

      resetEditorStateAfterSuccessfulSubmission();
      state.value = LoaderState.loaded;
      SmartDialog.showToast('Inspection submitted successfully');

      // Back to main listing detail screen
      Get.back(result: openedFromDetails ? true : null);
    } catch (e) {
      // Outer catch: will only trigger for internal code crashes (not network issues)
      Get.log("Internal Error during submit: ${e.toString()}");
      state.value = LoaderState.failure;
      SmartDialog.showToast("Failed to process inspection");
    }
  }

  void resetEditorStateAfterSuccessfulSubmission() {
    form.value = FormGModel();
    inspectionItemCheckboxes.updateAll((_, __) => true);
    useCurrentLocation.value = false;
    isReviewMode.value = false;
    isResumeDraft = false;
    baseFormController.resetEditorState();
    if (pageController != null && pageController!.hasClients) {
      pageController!.jumpToPage(0);
    }
    form.refresh();
  }

  int? get _currentDraftId {
    if (_workflow.activeDraftId != null) return _workflow.activeDraftId;
    _workflow.activeDraftId =
        FormDraftController.draftIdFromArguments(Get.arguments);
    return _workflow.activeDraftId;
  }

  Future<void> removeSubmittedDraft() async {
    final draftId = _currentDraftId;
    if (draftId == null) return;
    if (!Get.isRegistered<FormDraftController>()) {
      Get.put(FormDraftController());
    }
    await InspectionDraftStore(Get.find<FormDraftController>())
        .deleteRequired(draftId, formType: 'Form G');
    mainListingDetailsController?.localDrafts
        .removeWhere((draft) => draft.id == draftId);
    _workflow.clearDraft();
    final arguments = Get.arguments;
    if (arguments is Map) {
      arguments.remove('draftId');
      arguments.remove('isResumeDraft');
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

      // --- 1. Combine Form B data with BaseFormController Data ---
      Map<String, dynamic> combinedJson = form.toJson();
      _applyUncheckedInspectionItems(combinedJson);
      combinedJson['inspection_item_checkboxes'] =
          inspectionItemCheckboxes.map((key, value) => MapEntry(key, value));
      final detailsContext = mainListingDetailsController;
      InspectionDraftSupport.addCommonData(
        combinedJson,
        baseController: baseFormController,
        useCurrentLocation: useCurrentLocation.value,
        submittedInspectionID: _workflow.submittedInspectionID,
        packageName: detailsContext?.packageName.isNotEmpty == true
            ? detailsContext!.packageName
            : getPackageId,
        districtName: detailsContext?.districtName.isNotEmpty == true
            ? detailsContext!.districtName
            : getDistrictId,
        roadName: detailsContext?.roadName.isNotEmpty == true
            ? detailsContext!.roadName
            : getRoadId,
      );
      Get.log('Saving Draft Data: ${jsonEncode(combinedJson)}');

      final savedDraftID =
          await InspectionDraftStore(formDraftController).upsert(
        draftID: currentDraftId,
        formType: 'Form G',
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

      // 6. Go back to the previous screen
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

  Future<void> _loadDraftData(int draftId) async {
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
        final savedCheckboxes = jsonData['inspection_item_checkboxes'];
        if (savedCheckboxes is Map) {
          for (final code in inspectionItemCheckboxes.keys.toList()) {
            inspectionItemCheckboxes[code] = savedCheckboxes[code] == true;
          }
        }
        // 1. Decode Form B Model
        form.value = FormGModel.fromJson(jsonData);
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

      var projDst = proj4.Projection.parse(strSarawakRSO);

      // 5. Perform the Conversion
      var pointForward = projSrc.transform(projDst, pointSrc);

      // 6. Update the fields

      //setGpsEasting = position.latitude.toStringAsFixed(6);
      //setGpsNorting = position.longitude.toStringAsFixed(6);

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

    // --- 1. CHECK INSPECTION ITEMS ---
    List<Map<String, String>> inspectionItems = [
      {
        "name": "1 (Barriers)",
        "distress": getBarrierDistress,
        "critical": getBarrierCritical,
        "closed": getBarrierClosed,
      },
      {
        "name": "2 (Gantry Beams)",
        "distress": getGantryBeamDistress,
        "critical": getGantryBeamCritical,
        "closed": getGantryBeamClosed,
      },
      {
        "name": "3 (Gantry Columns)",
        "distress": getGantryColumnDistress,
        "critical": getGantryColumnCritical,
        "closed": getGantryColumnClosed,
      },
      {
        "name": "4 (Footings)",
        "distress": getFootingsDistress,
        "critical": getFootingsCritical,
        "closed": getFootingsClosed,
      },
      {
        "name": "5 (Anchor Bolts & Mortar)",
        "distress": getAnchorMortarDistress,
        "critical": getAnchorMortarCritical,
        "closed": getAnchorMortarClosed,
      },
      {
        "name": "6 (Maintenance Access)",
        "distress": getMaintenanceAccessDistress,
        "critical": getMaintenanceAccessCritical,
        "closed": getMaintenanceAccessClosed,
      },
      {
        "name": "7 (Static Signs)",
        "distress": getStaticSignsDistress,
        "critical": getStaticSignsCritical,
        "closed": getStaticSignsClosed,
      },
      {
        "name": "8 (Variable Message Signs)",
        "distress": getVmsDistress,
        "critical": getVmsCritical,
        "closed": getVmsClosed,
      },
    ];

    List<String> missingDistress = [];
    List<String> missingConditions = [];

    for (var item in inspectionItems) {
      String name = item["name"]!;
      final code = name.split(' ').first;
      if (!isInspectionItemChecked(code)) continue;
      String distress = item["distress"]!;
      String critical = item["critical"]!;
      String closed = item["closed"]!;

      // Rule A: Make sure YES or NO is selected
      if (distress.trim().isEmpty) {
        missingDistress.add(name);
      }

      // Rule B: Make sure either Critical OR Closed is checked
      // Checkboxes equal "1" when checked. If neither is "1", they failed the rule.
      if (critical != "1" && closed != "1") {
        missingConditions.add(name);
      }
    }

    // Add specific errors to the main list
    if (missingDistress.isNotEmpty) {
      errors.add(
          "Distress (YES/NO) not selected for: ${missingDistress.join(', ')}.");
    }

    if (missingConditions.isNotEmpty) {
      errors.add(
          "Please check either 'Critical' or 'Closed' for: ${missingConditions.join(', ')}.");
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

  //1. Inpection Data
  //GETTERS
  String? get getPackageID => form.value.packageId;
  String? get getDistrictID => form.value.districtId;
  String? get getRoadID => form.value.roadId;

  String get getRecId => form.value.recID ?? "";
  get getInspectionDate => form.value.inspectionDate ?? "";
  String get getReferenceNo => form.value.referenceNo ?? "";
  String get getPackageId => form.value.packageId ?? "";
  String get getDistrictId => form.value.districtId ?? "";
  String get getRoadId => form.value.roadId ?? "";
  String get getChainage => form.value.chainage ?? "";
  String get getStructureCode => form.value.structureCode ?? "";
  String get getGpsEasting => form.value.gpsEasting ?? "";
  String get getGpsNorthing => form.value.gpsNorthing ?? "";
  //SETTERS
  void setPackageID(String? v) => form.update((val) => val?.packageId = v);
  void setDistrictID(String? v) => form.update((val) => val?.districtId = v);
  void setRoadID(String? v) => form.update((val) => val?.roadId = v);
  set setRecId(String value) => form.value.recID = value;
  set setInspectionDate(String value) => form.value.inspectionDate = value;
  set setReferenceNo(String value) => form.value.referenceNo = value;
  set setPackageId(String value) => form.value.packageId = value;
  set setDistrictId(String value) => form.value.districtId = value;
  set setRoadId(String value) => form.value.roadId = value;
  set setChainage(String value) => form.value.chainage = value;
  set setStructureCode(String value) => form.value.structureCode = value;
  set setGpsEasting(String value) =>
      form.update((val) => form.value.gpsEasting = value);
  set setGpsNorthing(String value) =>
      form.update((val) => form.value.gpsNorthing = value);

  //2. Site Condition
  //GETTERS
  String get getParkingPosition => form.value.parkingPosition ?? "";
  String get getAccessCondition => form.value.accessCondition ?? "";
  String get getPotentialHazard => form.value.potentialHazard ?? "";
  //SETTERS
  set setParkingPosition(String value) => form.value.parkingPosition = value;
  set setAccessCondition(String value) => form.value.accessCondition = value;
  set setPotentialHazard(String value) => form.value.potentialHazard = value;

  //3.Inspection Items
  //GETTERS
  String get getBarrierDistress => form.value.barrierDistress ?? "";
  String get getBarrierCritical => form.value.barrierCritical ?? "";
  String get getBarrierClosed => form.value.barrierClosed ?? "";
  String get getGantryBeamDistress => form.value.gantryBeamDistress ?? "";
  String get getGantryBeamCritical => form.value.gantryBeamCritical ?? "";
  String get getGantryBeamClosed => form.value.gantryBeamClosed ?? "";
  String get getGantryColumnDistress => form.value.gantryColumnDistress ?? "";
  String get getGantryColumnCritical => form.value.gantryColumnCritical ?? "";
  String get getGantryColumnClosed => form.value.gantryColumnClosed ?? "";
  String get getFootingsDistress => form.value.footingsDistress ?? "";
  String get getFootingsCritical => form.value.footingsCritical ?? "";
  String get getFootingsClosed => form.value.footingsClosed ?? "";
  String get getAnchorMortarDistress => form.value.anchorMortarDistress ?? "";
  String get getAnchorMortarCritical => form.value.anchorMortarCritical ?? "";
  String get getAnchorMortarClosed => form.value.anchorMortarClosed ?? "";
  String get getMaintenanceAccessDistress =>
      form.value.maintenanceAccessDistress ?? "";
  String get getMaintenanceAccessCritical =>
      form.value.maintenanceAccessCritical ?? "";
  String get getMaintenanceAccessClosed =>
      form.value.maintenanceAccessClosed ?? "";
  String get getStaticSignsDistress => form.value.staticSignsDistress ?? "";
  String get getStaticSignsCritical => form.value.staticSignsCritical ?? "";
  String get getStaticSignsClosed => form.value.staticSignsClosed ?? "";
  String get getVmsDistress => form.value.vmsDistress ?? "";
  String get getVmsCritical => form.value.vmsCritical ?? "";
  String get getVmsClosed => form.value.vmsClosed ?? "";
  // SETTERS
  set setBarrierDistress(String value) => form.value.barrierDistress = value;
  set setBarrierCritical(String value) => form.value.barrierCritical = value;
  set setBarrierClosed(String value) => form.value.barrierClosed = value;
  set setGantryBeamDistress(String value) =>
      form.value.gantryBeamDistress = value;
  set setGantryBeamCritical(String value) =>
      form.value.gantryBeamCritical = value;
  set setGantryBeamClosed(String value) => form.value.gantryBeamClosed = value;
  set setGantryColumnDistress(String value) =>
      form.value.gantryColumnDistress = value;
  set setGantryColumnCritical(String value) =>
      form.value.gantryColumnCritical = value;
  set setGantryColumnClosed(String value) =>
      form.value.gantryColumnClosed = value;
  set setFootingsDistress(String value) => form.value.footingsDistress = value;
  set setFootingsCritical(String value) => form.value.footingsCritical = value;
  set setFootingsClosed(String value) => form.value.footingsClosed = value;
  set setAnchorMortarDistress(String value) =>
      form.value.anchorMortarDistress = value;
  set setAnchorMortarCritical(String value) =>
      form.value.anchorMortarCritical = value;
  set setAnchorMortarClosed(String value) =>
      form.value.anchorMortarClosed = value;
  set setMaintenanceAccessDistress(String value) =>
      form.value.maintenanceAccessDistress = value;
  set setMaintenanceAccessCritical(String value) =>
      form.value.maintenanceAccessCritical = value;
  set setMaintenanceAccessClosed(String value) =>
      form.value.maintenanceAccessClosed = value;
  set setStaticSignsDistress(String value) =>
      form.value.staticSignsDistress = value;
  set setStaticSignsCritical(String value) =>
      form.value.staticSignsCritical = value;
  set setStaticSignsClosed(String value) =>
      form.value.staticSignsClosed = value;
  set setVmsDistress(String value) => form.value.vmsDistress = value;
  set setVmsCritical(String value) => form.value.vmsCritical = value;
  set setVmsClosed(String value) => form.value.vmsClosed = value;
}
