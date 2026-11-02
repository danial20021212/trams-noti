import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/constant/url.dart';
import 'package:tram/model/form/form_depot/common/form_2_model.dart';
import 'package:tram/model/form/form_depot/common/form_photo_listing_model.dart';
import 'package:tram/model/form/form_depot/common/remarks_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/form_repository.dart';
import '../../../model/shared/dropdown_model.dart';
import '../../../repository/bridge_type_repository.dart';
import '../../../repository/pavement_repository.dart';

enum Roles { sp, cons, other }

class BaseFormController extends GetxController {
  static final Map<String, int> _recentPhotoUploads = <String, int>{};
  // Tracks the remark text we just sent for a given inspection's photoNo, so
  // the visibility check below can confirm the backend actually persisted it
  // (not just that the photo row exists) before treating a fetch as ready.
  static final Map<String, Map<String, String>> _recentPhotoRemarks =
      <String, Map<String, String>>{};

  final auth = Get.find<AuthController>();
  Rx<bool> isReadOnly = false.obs;
  Rx<bool> isReviewMode = false.obs;

  Rx<LoaderState> state = LoaderState.initial.obs;
  Rx<Form2Model> form = Form2Model().obs;
  RxList<FormPhotoListingModel> photoLinks = RxList();
  Rx<RemarksModel> formRemarks = RemarksModel(data: [
    Remarks(
      recID: "",
      spRemarksPartB: "",
      consRemarksPartB: "",
      spRemarksPartC: "",
      consRemarksPartC: "",
      spRemarksPartD: "",
      consRemarksPartD: "",
    )
  ]).obs;

  RxList<XFile> photoToUpload = RxList<XFile>();
  // Backend photo numbers for each item in [photoToUpload]. Keeping these
  // separate from the compact file list allows users to select P1 and P3
  // without the second file being incorrectly uploaded as photo2.
  RxList<int> photoNumbers = RxList<int>();
  RxList<String> photoRemarks = List<String>.filled(8, "").obs;
  Rx<dynamic> formDetails = Rxn(); // Holds data for any form
  Rx<dynamic> formTitleMap = Rxn();

  Rx<int> limitToUpload = 20.obs;

  final ImagePicker imagePicker = ImagePicker();

  bool isEditMode = false;
  String formType = '';
  String recID = '';
  FormRepository repository = FormRepository(formType: '');
  Roles currentRole = Roles.other;

  RxList<DropdownModel> packageDropdown = RxList();
  RxList<DropdownModel> districtDropdown = RxList();

  RxList<DropdownModel> divisionDropdown = RxList();

  RxList<DropdownModel> roadDropdown = RxList();

  final btRepository = BridgeTypeRepository();
  final pavementRepository = PavementRepository();

  RxnString packageID = RxnString();
  RxnString districtID = RxnString();

  RxnString divisionName = RxnString();

  RxnString roadID = RxnString();
  RxnString roadName = RxnString();

  @override
  void onInit() async {
    super.onInit();
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

    isEditMode = Get.arguments['isEditMode'] ?? false;
    final incomingFormType = Get.arguments['formType']?.toString() ?? "";
    final incomingRecID = Get.arguments['recID']?.toString() ?? "";
    final incomingFormPage = Get.arguments['formPage']?.toString() ?? "";
    configureContext(
      formType: incomingFormType,
      recID: incomingRecID,
      reviewMode: incomingFormPage == "review_${incomingFormType}2",
    );

    // Determine role
    debugPrint('User type from auth: "${auth.getUserType()}"');
    switch (auth.getUserType()) {
      case "Service Provider":
        currentRole = Roles.sp;
        break;
      case "Consultant":
        currentRole = Roles.cons;
        break;
      default:
        currentRole = Roles.other;
    }
    debugPrint('currentRole: $currentRole');

    // Read-only logic
    final status = Get.arguments["status"];
    isReadOnly.value = status?.toString().trim().toLowerCase() == "approved";

    // If not in review mode (where loadPhoto() is called), manually set state to loaded
    if (!isReviewMode.value) {
      state.value = LoaderState.loaded;
    }
  }

  void configureContext({
    required String formType,
    required String recID,
    required bool reviewMode,
  }) {
    this.formType = formType;
    this.recID = recID;
    repository = FormRepository(formType: formType);
    isReviewMode.value = reviewMode;
  }

  // --- Select dropdown Package ID ---
  Future<void> selectPackage(String v) async {
    SmartDialog.showLoading();
    setPackageID = v;
    setDistrictID = null;
    setRoadID = null;

    await loadDistrict();

    SmartDialog.dismiss();
  }

  // --- Select dropdown District ID ---
  Future<void> selectDistrict(String v) async {
    SmartDialog.showLoading();
    setDistrictID = v;
    setRoadID = null;

    await loadRoute();
    SmartDialog.dismiss();
  }

  // --- Select dropdown Division Name ---
  Future<void> selectDivision(String v) async {
    SmartDialog.showLoading();
    setDivisionName = v;
    setRoadID = null;

    await loadRoute();
    SmartDialog.dismiss();
  }

  // --- Select dropdown Route ID ---
  Future<void> selectRoute(String id) async {
    SmartDialog.showLoading();

    final selectedRoute = roadDropdown.firstWhere(
      (route) => route.id == id,
      orElse: () => const DropdownModel('', ''), // fallback
    );

    Get.log('Selected route value: ${selectedRoute.value}');

    setRoadID = id;

    // Only proceed if value is not empty and contains ' - ' for first split
    if (selectedRoute.value.contains(' - ')) {
      final parts = selectedRoute.value.split(' - ');
      final roadName = parts.sublist(1).join(' - ').trim();
      setRoadName = roadName;
    }

    SmartDialog.dismiss();
  }

  // --- Load packages from repository ---
  Future<void> loadPackage() async {
    try {
      state.value = LoaderState.loading;

      final data = await pavementRepository.showFilterPackage();

      // convert to dropdown models
      final allPackages = data.tblPackage
          .map((e) => DropdownModel(e.packageId, e.packageName))
          .toList();

      // if user has limited packages, filter
      if (auth.getUserPackage()?.isEmpty ?? true) {
        packageDropdown.assignAll(allPackages);
      } else {
        packageDropdown.assignAll(
            allPackages.where((e) => e.id == auth.getUserPackage()).toList());
      }

      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  // --- Load District from repository ---
  Future<void> loadDistrict() async {
    if (packageID.value == null || packageID.value!.isEmpty) return;
    try {
      state.value = LoaderState.loading;
      districtDropdown.clear();
      roadDropdown.clear();
      final data =
          await pavementRepository.showFilterDistrict(packageID.value!);

      districtDropdown.addAll(data.tblDistrict
          .map((e) => DropdownModel(e.districtId, e.districtName))
          .toList());

      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  // --- Load Division from repository ---
  Future<void> loadDivision() async {
    if (packageID.value == null || packageID.value!.isEmpty) return;
    try {
      state.value = LoaderState.loading;
      divisionDropdown.clear();
      roadDropdown.clear();
      final data =
          await pavementRepository.showFilterDivision(packageID.value!);

      divisionDropdown.addAll(data.tblDivision
          .map((e) => DropdownModel(e.divisionName, e.divisionName))
          .toList());

      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  // --- Load Route from repository ---
  Future<void> loadRoute() async {
    if (packageID.value == null || packageID.value!.isEmpty) return;
    if (divisionName.value == null || divisionName.value!.isEmpty) return;
    try {
      state.value = LoaderState.loading;
      roadDropdown.clear();
      final data = await pavementRepository.showFilterRoute2(
          packageID.value!, divisionName.value!);
      roadDropdown.addAll(data.tblRoute
          .map((e) => DropdownModel(e.routeId, "${e.routeNo} - ${e.routeName}"))
          .toList());
      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  Future<void> loadRemarks() async {
    try {
      debugPrint('=== loadRemarks ===');
      debugPrint('recID: $recID');
      debugPrint('formType: $formType');
      debugPrint('URL: ${UrlStorage().formRemarksView(formType: formType)}');
      // Review routes may reuse this controller. Do not show another
      // inspection's remarks while the current request is loading or if it
      // fails.
      formRemarks.value = _emptyRemarksModel();
      formRemarks.value = await repository.showRemarks(recID: recID);
      debugPrint('remarks response: ${formRemarks.value.data?.length} items');
      formRemarks.refresh();
    } catch (err) {
      debugPrint("Remarks Error: $err");
    }
  }

  Future<void> loadPhoto() async {
    try {
      state.value = LoaderState.loading;
      photoLinks.clear();
      debugPrint('=== loadPhoto ===');
      debugPrint('recID: $recID');
      debugPrint('formType: $formType');
      debugPrint('URL: ${UrlStorage().formPhotoList(formType: formType)}');
      final uploadKey = _photoUploadKey(recID);
      final expectedRecentCount = _recentPhotoUploads[uploadKey];
      final data = expectedRecentCount != null
          ? await waitForUploadedPhotos(
              recID,
              expectedCount: expectedRecentCount,
            )
          : await repository.showFormPhoto(recID: recID);
      debugPrint('photo count: ${data.data.length}');
      photoLinks.value = data.orderedByPhotoNumber();
      form.refresh();
      state.value = LoaderState.loaded;
      // Photos are shown as soon as they're visible above; a remark can
      // still take a little longer to land on the backend, so top it up
      // afterwards instead of holding up the whole grid for it.
      _refreshRemarksInBackground(recID);
    } catch (e) {
      state.value = LoaderState.failure;
      debugPrint("Photo Error: $e");
    }
  }

  Future<void> uploadPhoto(
    String recId, {
    bool clearPendingOnSuccess = true,
    bool resumeExistingUploads = false,
  }) async {
    debugPrint('--- uploadPhoto ---');
    debugPrint('photoToUpload count: ${photoToUpload.length}');
    debugPrint('recId: $recId');
    debugPrint('URL: ${UrlStorage().formPhotoUpload(formType: formType)}');
    if (photoToUpload.isEmpty) {
      debugPrint('No photos to upload, skipping');
      return;
    }

    try {
      state.value = LoaderState.loading;

      // A pending-sync retry can already have uploaded part of the batch
      // before the connection failed. Read back what is visible so those
      // photo slots are not uploaded again unnecessarily.
      final existingPhotos = <String, FormPhotoListingModel>{};
      if (resumeExistingUploads) {
        try {
          final remote = await repository
              .showFormPhoto(recID: recId)
              .timeout(const Duration(seconds: 30));
          for (final photo in remote.data) {
            if (photo.photoNo.isNotEmpty) existingPhotos[photo.photoNo] = photo;
          }
        } catch (error) {
          debugPrint('Unable to inspect existing photos before upload: $error');
        }
      }

      for (var i = 0; i < photoToUpload.length; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        final photoNumber = photoNumberForUploadIndex(i);
        final photoNo = "photo$photoNumber";
        final remarkToSend =
            i < photoRemarks.length ? photoRemarks[i].trim() : "";
        final existingPhoto = existingPhotos[photoNo];
        if (existingPhoto != null &&
            (remarkToSend.isEmpty ||
                existingPhoto.remarks.trim() == remarkToSend)) {
          debugPrint('$photoNo already uploaded; skipping retry');
          continue;
        }

        String? base64StringPhoto =
            await convertXFileToBase64(photoToUpload[i]);
        if (base64StringPhoto == null) {
          if ({'b', 'c', 'g', 'r'}.contains(formType.toLowerCase())) {
            throw StateError(
              'Unable to read Form ${formType.toUpperCase()} photo $photoNumber',
            );
          }
          continue;
        }
        debugPrint(
          'Uploading photo $photoNumber (${i + 1}/${photoToUpload.length})...',
        );
        await repository
            .uploadFormPhoto(
              recID: recId,
              photo: base64StringPhoto,
              photoNo: photoNo,
              remarks: remarkToSend,
            )
            .timeout(const Duration(seconds: 60));
        final uploadKey = _photoUploadKey(recId);
        _recentPhotoUploads[uploadKey] = photoToUpload.length;
        if (remarkToSend.isNotEmpty) {
          (_recentPhotoRemarks[uploadKey] ??= <String, String>{})[photoNo] =
              remarkToSend;
        }
        debugPrint('Photo $photoNumber uploaded');

        // CRITICAL: Nullify the string immediately after use so RAM can be freed!
        base64StringPhoto = null;
      }

      if (clearPendingOnSuccess) {
        clearPendingPhotos();
      }
      state.value = LoaderState.loaded;
    } catch (e) {
      state.value = LoaderState.failure;
      Get.log("Upload Error: $e");
      rethrow;
    }
  }

  String _photoUploadKey(String inspectionID) =>
      '${formType.toLowerCase()}:$inspectionID';

  Future<FormPhotoListingDataModel> waitForUploadedPhotos(
    String inspectionID, {
    required int expectedCount,
    int attempts = 6,
  }) async {
    FormPhotoListingDataModel latest = const FormPhotoListingDataModel(
      httpStatus: '',
      data: [],
    );

    final uploadKey = _photoUploadKey(inspectionID);

    for (var attempt = 0; attempt < attempts; attempt++) {
      try {
        latest = await repository.showFormPhoto(recID: inspectionID);
        if (latest.data.length >= expectedCount) {
          _recentPhotoUploads.remove(uploadKey);
          return latest;
        }
      } catch (error) {
        debugPrint('Photo visibility check failed: $error');
      }

      if (attempt < attempts - 1) {
        await Future.delayed(Duration(milliseconds: 350 * (attempt + 1)));
      }
    }

    return latest;
  }

  // Inspection IDs with a background remark catch-up already running on
  // *this* controller instance, so a photo load triggered again (e.g.
  // swiping between review pages) doesn't start a second overlapping poll
  // for the same remark. Deliberately per-instance, not static: a
  // submission can hand off to a freshly created controller for the
  // resulting review screen (see FormCController.submitNewInspection), and
  // that new instance must still run and apply its own catch-up rather than
  // deferring to the submitting instance's, which is about to be disposed
  // and cannot update this screen's photoLinks.
  final Set<String> _remarkRefreshInFlight = <String>{};

  /// Tops up [photoLinks] with a remark once the backend actually persists
  /// it, without making the photo grid itself wait for that to happen.
  /// The photo row and its remark can be written in separate backend steps,
  /// so a remark can still be missing for a short while after its photo is
  /// already visible; this runs on its own, longer schedule in the
  /// background and updates the already-displayed grid in place once the
  /// remark shows up, instead of delaying every photo behind it.
  void _refreshRemarksInBackground(String inspectionID) {
    final uploadKey = _photoUploadKey(inspectionID);
    final expectedRemarks = _recentPhotoRemarks[uploadKey];
    if (expectedRemarks == null || expectedRemarks.isEmpty) return;
    if (!_remarkRefreshInFlight.add(uploadKey)) return;

    () async {
      try {
        const attempts = 8;
        for (var attempt = 0; attempt < attempts; attempt++) {
          await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
          try {
            final latest = await repository.showFormPhoto(recID: inspectionID);
            if (_remarksHavePropagated(latest.data, expectedRemarks)) {
              _recentPhotoRemarks.remove(uploadKey);
              // Only touch the currently-displayed grid if it's still
              // showing this same inspection - the controller may have
              // moved on to a different one by the time this resolves.
              if (recID == inspectionID) {
                photoLinks.value = latest.orderedByPhotoNumber();
              }
              return;
            }
          } catch (error) {
            debugPrint('Background remark refresh failed: $error');
          }
        }
      } finally {
        _remarkRefreshInFlight.remove(uploadKey);
      }
    }();
  }

  /// True once every photoNo we uploaded a remark for shows a non-empty
  /// remark in [data].
  bool _remarksHavePropagated(
    List<FormPhotoListingModel> data,
    Map<String, String>? expectedRemarks,
  ) {
    if (expectedRemarks == null || expectedRemarks.isEmpty) return true;

    for (final photoNo in expectedRemarks.keys) {
      FormPhotoListingModel? match;
      for (final photo in data) {
        if (photo.photoNo == photoNo) {
          match = photo;
          break;
        }
      }
      if (match == null || match.remarks.trim().isEmpty) return false;
    }
    return true;
  }

  void clearPendingPhotos() {
    photoToUpload.clear();
    photoNumbers.clear();
    photoRemarks.value = List<String>.filled(8, "");
  }

  RemarksModel _emptyRemarksModel() => RemarksModel(data: [
        Remarks(
          recID: "",
          spRemarksPartB: "",
          consRemarksPartB: "",
          spRemarksPartC: "",
          consRemarksPartC: "",
          spRemarksPartD: "",
          consRemarksPartD: "",
        ),
      ]);

  /// Clears state owned by one form editor while keeping its API context.
  /// This must only run after a complete successful submission (or before an
  /// intentionally fresh editor), so failed submissions remain recoverable.
  void resetEditorState() {
    clearPendingPhotos();
    photoLinks.clear();
    formRemarks.value = _emptyRemarksModel();
    form.value = Form2Model();
    formDetails.value = null;
    formTitleMap.value = null;
    packageID.value = null;
    districtID.value = null;
    divisionName.value = null;
    roadID.value = null;
    roadName.value = null;
    packageDropdown.clear();
    districtDropdown.clear();
    divisionDropdown.clear();
    roadDropdown.clear();
    isEditMode = false;
    isReadOnly.value = false;
    isReviewMode.value = false;
  }

  void resetFormCEditorState() {
    resetEditorState();
  }

  Future<void> deletePhoto({required FormPhotoListingModel model}) async {
    try {
      state.value = LoaderState.loading;

      final res = await repository.deleteFormPhoto(
          recID: recID, photoNo: model.photoNo);

      if (res.data["http_status"] != "Success.") {
        SmartDialog.showToast("Somethings went wrong, please try again...");
      }

      loadPhoto();
      SmartDialog.showToast(res.data["data"]);

      state.value = LoaderState.loaded;
    } catch (e) {
      photoToUpload.clear();
      photoNumbers.clear();
      debugPrint(e.toString());
      state.value = LoaderState.failure;
    }
  }

  Future<void> submitRemark(String recId) async {
    debugPrint('--- submitRemark ---');
    debugPrint('recId: $recId');
    debugPrint('formType: $formType');
    debugPrint('URL for C: ${UrlStorage.formCRemark2}');
    debugPrint(
        'URL for others: ${UrlStorage().formRemarks(formType: formType)}');
    try {
      state.value = LoaderState.loading;
      setRecID = recId;
      debugPrint('formRemarks data null? ${formRemarks.value.data == null}');
      debugPrint('formRemarks data length: ${formRemarks.value.data?.length}');

      final remarksJson = formRemarks.value.data!.first.toJson();
      debugPrint('remarks payload: $remarksJson');

      if (formType.toLowerCase() == "c") {
        await repository
            .submitFormCRemark(mapForm: remarksJson)
            .timeout(const Duration(seconds: 60));
      } else {
        await repository
            .submitFormRemark(mapForm: remarksJson)
            .timeout(const Duration(seconds: 60));
      }

      debugPrint('submitRemark success');
      state.value = LoaderState.loaded;
    } catch (e) {
      debugPrint('submitRemark error: $e');
      state.value = LoaderState.failure;
      rethrow;
    }
  }

  Future<void> submitApproval(String recId) async {
    debugPrint('--- submitApproval ---');
    debugPrint('recId: $recId');
    debugPrint('currentRole: $currentRole');
    try {
      state.value = LoaderState.loading;

      final today = DateTime.now().toIso8601String().split('T').first;
      final Map<String, dynamic> mapForm = {
        "recID": recId,
        "investigation": getInvestigation,
        "sp_sign_date": currentRole == Roles.sp ? today : getSpSignDate,
        "ec_sign_date": currentRole == Roles.cons ? today : getEcSignDate,
        "sign_agree": getEcSignAgree ?? "",
      };

      debugPrint('approval payload: ${jsonEncode(mapForm)}');
      debugPrint('URL: ${UrlStorage().formSignature(formType: formType)}');
      debugPrint('mapForm isEmpty: ${mapForm.isEmpty}');
      if (mapForm.isEmpty) {
        debugPrint(
            'WARNING: Empty payload - role $currentRole may not be recognized');
      }
      await repository
          .submitSignature(mapForm: mapForm)
          .timeout(const Duration(seconds: 60));
      debugPrint('submitApproval success');
      state.value = LoaderState.loaded;
    } catch (e) {
      debugPrint('submitApproval error: $e');
      state.value = LoaderState.failure;
      rethrow;
    }
  }

  Future<void> submitNewInspection(
    String recID, {
    bool clearPendingPhotosOnSuccess = true,
    bool resumeExistingPhotoUploads = false,
  }) async {
    debugPrint('=== baseFormController.submitNewInspection ===');
    debugPrint('recID: $recID');
    debugPrint('formType: $formType');
    final expectedPhotoCount = photoToUpload.length;
    debugPrint('Step 1: uploadPhoto...');
    await uploadPhoto(
      recID,
      clearPendingOnSuccess: clearPendingPhotosOnSuccess,
      resumeExistingUploads: resumeExistingPhotoUploads,
    );
    debugPrint('Step 1 done');
    if (expectedPhotoCount > 0) {
      debugPrint('Waiting for uploaded photos to become visible...');
      await waitForUploadedPhotos(
        recID,
        expectedCount: expectedPhotoCount,
      );
      // Give any remark still catching up on the backend the earliest
      // possible start, so it's already there by the time the user opens
      // the review page instead of them having to reload it themselves.
      _refreshRemarksInBackground(recID);
    }
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Step 2: submitRemark...');
    await submitRemark(recID);
    debugPrint('Step 2 done');
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Step 3: submitApproval...');
    await submitApproval(recID);
    debugPrint('Step 3 done');
  }

  Future<String?> convertXFileToBase64(XFile? file) async {
    if (file == null) return null;
    try {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      debugPrint("Error converting file to Base64: $e");
      return null;
    }
  }

  Uint8List dataFromBase64String(String base64String) {
    String data = "";
    try {
      // Remove the data URI prefix (e.g., "data:image/png;base64,")
      data = base64String.split(',').last;
    } catch (e) {
      Get.log('Error converting Base64 to Uint8List: $e');
    }
    return base64Decode(data);
  }

  set setPackageID(String? v) => packageID.value = v;
  set setDistrictID(String? v) => districtID.value = v;

  set setDivisionName(String? v) => divisionName.value = v;

  set setRoadID(String? v) => roadID.value = v;
  set setRoadName(String? v) => roadName.value = v!;

  String? get getPackageID => packageID.value;
  String? get getDistrictID => districtID.value;
  String? get getRoadID => roadID.value;
  String? get getRoadName => roadName.value;

  // GETTERS
  // 3.Distress Observed
  get getSpRemarkPartB => formRemarks.value.data?.first.spRemarksPartB ?? '';
  get getConsRemarkPartB =>
      formRemarks.value.data?.first.consRemarksPartB ?? '';
  // 4.General comment
  get getSpRemarkPartC => formRemarks.value.data?.first.spRemarksPartC ?? '';
  get getConsRemarkPartC =>
      formRemarks.value.data?.first.consRemarksPartC ?? '';
  // 5.Feedback
  get getSpRemarkPartD => formRemarks.value.data?.first.spRemarksPartD ?? '';
  get getConsRemarkPartD =>
      formRemarks.value.data?.first.consRemarksPartD ?? '';
  // 6.Signature
  get getInvestigation => form.value.investigation ?? "";
  get getSpSignDate => form.value.spSignDate ?? "";

  get getEcSignDate => form.value.ecSignDate ?? "";
  get getEcSignAgree => form.value.ecSignAgree;

  // SETTERS
  // 3.Distress Observed
  set setRecID(String e) => formRemarks.value.data?.first.recID = e;
  set setSpRemarkPartB(String e) =>
      formRemarks.value.data?.first.spRemarksPartB = e;
  set setConsRemarkPartB(String e) =>
      formRemarks.value.data?.first.consRemarksPartB = e;
  // 4.General comment
  set setSpRemarkPartC(String e) =>
      formRemarks.value.data?.first.spRemarksPartC = e;
  set setConsRemarkPartC(String e) =>
      formRemarks.value.data?.first.consRemarksPartC = e;
  // 5.Feedback
  set setSpRemarkPartD(String e) =>
      formRemarks.value.data?.first.spRemarksPartD = e;
  set setConsRemarkPartD(String e) =>
      formRemarks.value.data?.first.consRemarksPartD = e;
  // 6. Signature
  // sp
  set setInvestigation(String e) => form.value.investigation = e;
  set setSpSignDate(String e) => form.value.spSignDate = e;
  // ec || cons
  set setEcSignDate(String e) => form.value.ecSignDate = e;
  set setEcSignAgree(String e) => form.value.ecSignAgree = e;

  void setPhotoRemark(int index, String value) {
    if (index < 0 || index >= photoRemarks.length) return;
    photoRemarks[index] = value;
  }

  bool addPhoto(XFile photo, {int? photoNumber}) {
    if (photoToUpload.length >= limitToUpload.value) return false;

    final number = photoNumber ?? nextAvailablePhotoNumber();
    if (number < 1 ||
        number > limitToUpload.value ||
        selectedPhotoNumbers.contains(number)) {
      return false;
    }

    photoToUpload.add(photo);
    photoNumbers.add(number);
    while (photoRemarks.length < photoToUpload.length) {
      photoRemarks.add("");
    }
    return true;
  }

  List<int> get selectedPhotoNumbers => [
        for (var index = 0; index < photoToUpload.length; index++)
          photoNumberForUploadIndex(index),
      ];

  int photoNumberForUploadIndex(int index) =>
      index >= 0 && index < photoNumbers.length
          ? photoNumbers[index]
          : index + 1;

  int? uploadIndexForPhotoNumber(int photoNumber) {
    for (var index = 0; index < photoToUpload.length; index++) {
      if (photoNumberForUploadIndex(index) == photoNumber) return index;
    }
    return null;
  }

  int nextAvailablePhotoNumber({int startAt = 1}) {
    final used = selectedPhotoNumbers.toSet();
    for (var number = startAt; number <= limitToUpload.value; number++) {
      if (!used.contains(number)) return number;
    }
    return limitToUpload.value + 1;
  }

  bool get hasExceededPhotoLimit => photoToUpload.length > limitToUpload.value;

  bool get supportsPhotoRemarks =>
      {'b', 'c', 'g', 'r'}.contains(formType.toLowerCase());

  List<int> get missingPhotoRemarkNumbers => [
        for (var index = 0; index < photoToUpload.length; index++)
          if (index >= photoRemarks.length ||
              photoRemarks[index].trim().isEmpty)
            photoNumberForUploadIndex(index),
      ];

  void removePhotoAt(int index) {
    if (index < 0 || index >= photoToUpload.length) return;
    photoToUpload.removeAt(index);
    if (index < photoNumbers.length) {
      photoNumbers.removeAt(index);
    }
    if (index < photoRemarks.length) {
      photoRemarks.removeAt(index);
    }
    while (
        photoRemarks.length < 8 || photoRemarks.length < photoToUpload.length) {
      photoRemarks.add("");
    }
  }

  @override
  void onClose() {
    photoToUpload.clear();
    photoNumbers.clear();
    photoRemarks.clear();
    super.onClose();
  }
}
