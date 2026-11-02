import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;
import 'package:tram/model/form/form_depot/form_R/form_R_model.dart';
import 'package:tram/model/shared/checkbox_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/form_repository.dart';
import 'package:tram/screen/form_depot/form_R/pages/facing_type_page.dart';
import 'package:tram/screen/form_depot/form_R/pages/inspection_data_page.dart';
import 'package:tram/screen/form_depot/form_R/pages/location_data_page.dart';
import 'package:tram/screen/form_depot/form_R/pages/wall_function_page.dart';
import 'package:tram/screen/form_depot/form_R/pages/wall_member_page.dart';

import '../../model/form/form_depot/form_R/form_R_main_listing_details_model.dart';
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

class FormRController extends GetxController {
  final InspectionWorkflowState _workflow =
      InspectionWorkflowState.fromArguments(Get.arguments);
  final InspectionSubmissionCoordinator _submissionCoordinator =
      const InspectionSubmissionCoordinator();

  RxBool isReviewMode = false.obs;
  final String formPage = Get.arguments['formPage'] ?? 'Unknown';
  bool get isResumeDraft => _workflow.isResumeDraft;
  set isResumeDraft(bool value) => _workflow.isResumeDraft = value;

  Rx<LoaderState> state = LoaderState.initial.obs;
  late Rx<FormRModel> form;

  final repository = FormRepository(formType: 'R');
  //final rootFormController = Get.find<RootFormController>();

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

  RxList<Widget> newRecordPages = <Widget>[
    const LocationDataPage(),
    const WallFunctionPage(),
    const WallMemberPage(),
    const FacingTypePage(),
  ].obs;

  RxList<Widget> newInspectionPages = <Widget>[
    const InspectionDataPage(),
    const PhotographsPage(),
    const DistressObservedPage(),
    const GeneralCommentPage(),
    const FeedbackPage(),
    const ApprovalPage(),
  ].obs;

  RxList<Widget> reviewFormR2Pages = <Widget>[
    const PhotographsPage(),
    const DistressObservedPage(),
    const GeneralCommentPage(),
    const FeedbackPage()
  ].obs;

  // Wall Functions in checkbox group
  RxList<CheckBoxModel> wallFunction = FormRModel.wallFunctionData.entries
      .map((e) => CheckBoxModel(e.key, e.value))
      .toList()
      .obs;

// Wall Members in checkbox group
  RxList<CheckBoxModel> wallMember = FormRModel.wallMemberData.entries
      .map((e) => CheckBoxModel(e.key, e.value))
      .toList()
      .obs;

// Facing Type in checkbox group
  RxList<CheckBoxModel> facingType = FormRModel.facingTypeData.entries
      .map((e) => CheckBoxModel(e.key, e.value))
      .toList()
      .obs;

  //Wall Function
  RxList<String> selectedWallFunctions = <String>[].obs;
  //Wall Member
  RxList<String> selectedWallMember = <String>[].obs;
  //Facing type
  RxList<String> selectedFacingType = <String>[].obs;
  //Inspection Data
  RxList<String> selectedDistress = <String>[].obs;

  static const String noDistressCode = 'ND';

  bool get isNoDistressSelected => getDistress.contains(noDistressCode);

  void toggleDistress(String code) {
    final values = List<String>.from(getDistress);
    if (code == noDistressCode) {
      if (values.contains(noDistressCode)) {
        values.clear();
      } else {
        values
          ..clear()
          ..add(noDistressCode);
        setSeverity = '1';
      }
    } else {
      values.remove(noDistressCode);
      if (values.contains(code)) {
        values.remove(code);
      } else {
        values.add(code);
      }
    }
    selectedDistress.assignAll(values);
    setDistress = List<String>.from(values);
    form.refresh();
  }

  @override
  void onInit() async {
    super.onInit();
    form = FormRModel().obs;
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

    // if (formPage == "review_R2") {
    //   isReviewMode = true.obs;
    //   await _loadReviewData();
    // }
    if (formPage == "review_R2") {
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
      setRecID = Get.arguments['recID']?.toString() ?? '';
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
        final Form_R_MainListingDetailsModel formDetails =
            detailsController.formDetails.value;
        for (var e in formDetails.data) {
          setReferenceNo = e.referenceNo ?? '';
          setChainageKilometre = e.chainage ?? '';
          setStructureCode = e.structureCode ?? '';
          setGpsEasting = e.gpsEasting ?? '';
          setGpsNorting = e.gpsNorthing ?? '';
        }
      }

      final previousRecID =
          Get.arguments['previousRecID']?.toString().trim() ?? '';
      if (previousRecID.isEmpty) {
        form.refresh();
        state.value = LoaderState.loaded;
        return;
      }

      Form_R_InspectionDetailsModel details =
          await repository.showInspectionDetails(recID: previousRecID);

      for (var e in details.data) {
        setWallFunction = e.wallFunction!;
        setWallFunctionOther = e.wallFunctionOther!;
        setWallMember1 = e.wallMember1!;
        setWallMember2 = e.wallMember2!;
        setWallMember3 = e.wallMember3!;
        setWallMemberOther = e.wallMemberOther!;
        setFacingType1 = e.facingType1!;
        setFacingType2 = e.facingType2!;
        setFacingType3 = e.facingType3!;
        setFacingTypeOther = e.facingTypeOther!;
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

    try {
      state.value = LoaderState.loading;
      //save new record without inspection date first
      setInspectionDate = "";
      final response = await FormRepository(formType: "R")
          .submitNewInspectionForm(mapForm: form.value.toJson());
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

      Get.log("Submitting payload: ${jsonEncode(form.toJson())}");
      final submission = await _submissionCoordinator.submit(
        existingInspectionID: _workflow.submittedInspectionID,
        submitMain: () async {
          final response = await FormRepository(formType: 'R')
              .submitNewInspectionForm(mapForm: form.value.toJson());
          return response.data;
        },
        resolveInspectionID: (responseData) => resolveGeneralInspectionID(
          responseData,
          formType: 'R',
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

      // 3. UI CLEANUP (Only runs if Network was successful)
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

      Get.back(result: openedFromDetails ? true : null);
    } catch (e) {
      Get.log("Internal Error during submit: ${e.toString()}");
      state.value = LoaderState.failure;
      SmartDialog.showToast("Failed to process inspection");
    }
  }

  void resetEditorStateAfterSuccessfulSubmission() {
    form.value = FormRModel();
    selectedWallFunctions.clear();
    selectedWallMember.clear();
    selectedFacingType.clear();
    selectedDistress.clear();
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
        .deleteRequired(draftId, formType: 'Form R');
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

      final wasResumeDraft = isResumeDraft;
      final currentDraftId = _currentDraftId;

      // 1. Combine Form R data with BaseFormController Data
      Map<String, dynamic> combinedJson = form.toJson();
      final detailsContext = mainListingDetailsController;
      InspectionDraftSupport.addCommonData(
        combinedJson,
        baseController: baseFormController,
        useCurrentLocation: useCurrentLocation.value,
        submittedInspectionID: _workflow.submittedInspectionID,
        packageName: detailsContext?.packageName.isNotEmpty == true
            ? detailsContext!.packageName
            : getPackageID ?? '',
        districtName: detailsContext?.districtName.isNotEmpty == true
            ? detailsContext!.districtName
            : getDistrictID ?? '',
        roadName: detailsContext?.roadName.isNotEmpty == true
            ? detailsContext!.roadName
            : getRoadID ?? '',
      );
      Get.log('Saving Draft Data: ${jsonEncode(combinedJson)}');

      final savedDraftID =
          await InspectionDraftStore(formDraftController).upsert(
        draftID: currentDraftId,
        formType: 'Form R',
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

  // --- DRAFT RESUME LOGIC ---
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
        // 1. Decode Form B Model
        form.value = FormRModel.fromJson(jsonData);
        form.refresh();
        selectedWallFunctions.assignAll(form.value.wallFunction ?? const []);
        selectedWallMember.assignAll([
          form.value.wallMember1,
          form.value.wallMember2,
          form.value.wallMember3,
        ].whereType<String>().where((value) => value.isNotEmpty));
        selectedFacingType.assignAll([
          form.value.facingType1,
          form.value.facingType2,
          form.value.facingType3,
        ].whereType<String>().where((value) => value.isNotEmpty));
        selectedDistress.assignAll(form.value.distress ?? const []);

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

  // updateForm() async {
  //   await rootFormController.updateForm(mapForm: loadMapForm());
  // }

  // Map<String, String> loadMapForm() {
  //   return {
  //     'recID': getRecID,
  //     'inspection_date': getInspectionDate,
  //     'referenceNo': getReferenceNo,
  //     'packageId': getPackageID ?? "",
  //     'districtId': getDistrictID ?? "",
  //     'roadId': getRoadID ?? "",
  //     'Chainage': getChainageKilometre,
  //     'StructureCode': getStructureCode,
  //     'GPS_Easting': getGpsEasting,
  //     'GPS_Northing': getGpsNorting,
  //     'wallFunction': getWallFunction.join(','),
  //     'wallFunction_other':
  //         getWallFunction.contains("F8") ? getWallFunctionOther : "",
  //     'wallMember1': getWallMember1,
  //     'wallMember2': getWallMember2,
  //     'wallMember3': getWallMember3,
  //     'wallMember_other':
  //         selectedWallMember.contains("M24") ? getWallMemberOther : "",
  //     'facingType1': getFacingType1,
  //     'facingType2': getFacingType2,
  //     'facingType3': getFacingType3,
  //     'facingType_other':
  //         selectedFacingType.contains("T15") ? getFacingTypeOther : "",
  //     'distress': getDistress.join(','),
  //     'severity': getSeverity,
  //   };
  // }

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

      //setGpsEasting = position.latitude.toStringAsFixed(6);
      //setGpsNorting = position.longitude.toStringAsFixed(6);

      setGpsEasting = pointForward.x.toStringAsFixed(3);
      setGpsNorting = pointForward.y.toStringAsFixed(3);

      state.value = LoaderState.loaded;
    } catch (e) {
      useCurrentLocation.value = false;
      state.value = LoaderState.failure;
      Get.snackbar("Error", "Failed to get location: $e");
      Get.log(e.toString());
    }
  }

  bool _validateSubmission() {
    List<String> errors = [];

    // --- 1. CHECK INSPECTION DATA ---
    if (getDistress.isEmpty) {
      errors.add("At least one distress is required.");
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

  void saveWallMember() {
    // Clear old values
    form.value.wallMember1 = "";
    form.value.wallMember2 = "";
    form.value.wallMember3 = "";

    // Assign new values based on selection order
    if (selectedWallMember.isNotEmpty) {
      form.value.wallMember1 = selectedWallMember[0];
    }
    if (selectedWallMember.length > 1) {
      form.value.wallMember2 = selectedWallMember[1];
    }
    if (selectedWallMember.length > 2) {
      form.value.wallMember3 = selectedWallMember[2];
    }

    form.refresh();
  }

  void saveFacingType() {
    // Clear old values
    form.value.facingType1 = "";
    form.value.facingType2 = "";
    form.value.facingType3 = "";

    // Assign new values based on selection order
    if (selectedFacingType.isNotEmpty) {
      form.value.facingType1 = selectedFacingType[0];
    }
    if (selectedFacingType.length > 1) {
      form.value.facingType2 = selectedFacingType[1];
    }
    if (selectedFacingType.length > 2) {
      form.value.facingType3 = selectedFacingType[2];
    }

    form.refresh();
  }

  void backPage() {
    if (pageController != null && pageController!.hasClients) {
      pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  //1. Location data
  //---GETTERS
  String? get getPackageID => form.value.packageID;
  String? get getDistrictID => form.value.districtID;
  String? get getRoadID => form.value.roadID;

  String get getRecID => form.value.recID ?? "";
  String get getInspectionDate => form.value.inspectionDate ?? "";
  String get getReferenceNo => form.value.referenceNo ?? "";
  String get getChainageKilometre => form.value.chainageKilometre ?? "";
  String get getStructureCode => form.value.structureCode ?? "";
  String get getGpsEasting => form.value.gpsEasting ?? "";
  String get getGpsNorting => form.value.gpsNorting ?? "";

  //--SETTERS
  void setPackageID(String? v) => form.update((val) => val?.packageID = v);
  void setDistrictID(String? v) => form.update((val) => val?.districtID = v);
  void setRoadID(String? v) => form.update((val) => val?.roadID = v);

  set setRecID(String value) => form.value.recID = value;
  set setInspectionDate(String value) => form.value.inspectionDate = value;
  set setReferenceNo(String value) => form.value.referenceNo = value;
  set setChainageKilometre(String value) =>
      form.value.chainageKilometre = value;
  set setStructureCode(String value) => form.value.structureCode = value;
  set setGpsEasting(String value) =>
      form.update((val) => form.value.gpsEasting = value);
  set setGpsNorting(String value) =>
      form.update((val) => form.value.gpsNorting = value);

  // 2. Wall Function
  get getWallFunction => form.value.wallFunction ?? [];
  get getWallFunctionOther => form.value.wallFunctionOther ?? "";
  set setWallFunction(List<String> value) => form.value.wallFunction = value;
  set setWallFunctionOther(String value) =>
      form.value.wallFunctionOther = value;

  // 3. Wall Member
  get getWallMember1 => form.value.wallMember1 ?? "";
  get getWallMember2 => form.value.wallMember2 ?? "";
  get getWallMember3 => form.value.wallMember3 ?? "";
  get getWallMemberOther => form.value.wallMemberOther ?? "";

  set setWallMember1(String value) => form.value.wallMember1 = value;
  set setWallMember2(String value) => form.value.wallMember2 = value;
  set setWallMember3(String value) => form.value.wallMember3 = value;
  set setWallMemberOther(String value) => form.value.wallMemberOther = value;

// 4. Facing Type
  get getFacingType1 => form.value.facingType1 ?? "";
  get getFacingType2 => form.value.facingType2 ?? "";
  get getFacingType3 => form.value.facingType3 ?? "";
  get getFacingTypeOther => form.value.facingTypeOther ?? "";

  set setFacingType1(String value) => form.value.facingType1 = value;
  set setFacingType2(String value) => form.value.facingType2 = value;
  set setFacingType3(String value) => form.value.facingType3 = value;
  set setFacingTypeOther(String value) => form.value.facingTypeOther = value;

  //5. Severity and Distress
  get getDistress => form.value.distress ?? [];
  get getSeverity => form.value.severity ?? "";
  set setDistress(List<String> value) => form.value.distress = value;
  set setSeverity(String value) => form.value.severity = value;
}
