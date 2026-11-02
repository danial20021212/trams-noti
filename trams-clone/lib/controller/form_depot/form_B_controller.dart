// ignore: file_names
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;

import 'package:get/get.dart';
import 'package:tram/controller/form_depot/main_listing/main_listing_details_controller.dart';
import 'package:tram/model/form/form_depot/form_B/form_B_main_listing_details_model.dart';
import 'package:tram/model/form/form_depot/form_B/form_B_model.dart';
import 'package:tram/model/form/form_depot/form_B/filter_bridge_type_model.dart';
import 'package:tram/model/shared/draft_status_model.dart';
import 'package:tram/model/shared/dropdown_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/bridge_type_repository.dart';
import 'package:tram/repository/form_repository.dart';
import 'package:tram/screen/form_depot/form_B/pages/bridge_type_page.dart';
import 'package:tram/screen/form_depot/form_B/pages/secondary_member_page.dart';
import 'package:tram/screen/form_depot/form_B/pages/structure_data_page.dart';
import 'package:tram/screen/form_depot/form_B/pages/primary_member_page.dart';

import '../../model/form/form_depot/common/distress_model.dart';
import '../../repository/pavement_repository.dart';

import '../../screen/form_depot/common/base_form/distress_observed_page.dart';
import '../../screen/form_depot/common/base_form/general_comment_page.dart';
import '../../screen/form_depot/common/base_form/feedback_page.dart';
import '../../screen/form_depot/common/base_form/approval_page.dart';
import '../../screen/form_depot/common/base_form/photographs_page.dart';
import '../../screen/form_depot/form_B/pages/location_data_page.dart';
import '../auth/auth_controller.dart';
import 'common/base_form_controller.dart';
import 'common/inspection_draft_support.dart';
import 'common/inspection_submission_coordinator.dart';
import 'common/inspection_validation.dart';
import 'common/inspection_workflow_state.dart';
import 'form_draft_controller.dart';
import 'main_listing/main_listing_controller.dart';

class FormBController extends GetxController {
  final InspectionWorkflowState _workflow =
      InspectionWorkflowState.fromArguments(Get.arguments);
  final InspectionSubmissionCoordinator _submissionCoordinator =
      const InspectionSubmissionCoordinator();
  RxBool isReviewMode = false.obs;
  final String formPage = Get.arguments['formPage'] ?? 'Unknown';
  bool get isResumeDraft => _workflow.isResumeDraft;
  set isResumeDraft(bool value) => _workflow.isResumeDraft = value;

  Rx<LoaderState> state = LoaderState.initial.obs;
  late Rx<FormBModel> form;

  final btRepository = BridgeTypeRepository();
  final repository = FormRepository(formType: 'B');
  final pavementRepository = PavementRepository();

  final baseFormController = Get.find<BaseFormController>();

  MainListingController? get mainListingController =>
      Get.isRegistered<MainListingController>()
          ? Get.find<MainListingController>()
          : null;

  MainListingDetailsController? get mainListingDetailsController =>
      Get.isRegistered<MainListingDetailsController>()
          ? Get.find<MainListingDetailsController>()
          : null;

  final auth = Get.find<AuthController>();

  Rx<bool> isReadOnly = false.obs;
  PageController? pageController;

  //Use current location state
  RxBool useCurrentLocation = false.obs;

  // Checked members are applicable and must be completed. Unchecked members
  // are excluded from this inspection and submitted with blank member fields.
  RxMap<String, bool> memberCheckboxes = <String, bool>{
    for (final code in [
      'P1',
      'P2',
      'P3',
      'P4',
      'P5',
      'S1',
      'S2',
      'S3',
      'S4',
      'S5',
      'S6',
      'S7',
    ])
      code: true,
  }.obs;

  bool isMemberChecked(String code) => memberCheckboxes[code] ?? true;

  void toggleMember(String code) {
    final checked = !isMemberChecked(code);
    memberCheckboxes[code] = checked;
    if (!checked) _clearMemberData(code);
  }

  void _applyUncheckedMembers(Map<String, dynamic> json) {
    for (final entry in memberCheckboxes.entries) {
      if (entry.value) continue;
      final prefix = entry.key.toLowerCase();
      for (final suffix in const [
        'material',
        'material_other',
        'distress',
        'other_distress',
        'severity',
      ]) {
        json['${prefix}_$suffix'] = '';
      }
    }
  }

  void _clearMemberData(String code) {
    form.update((value) {
      if (value == null) return;
      switch (code) {
        case 'P1':
          value.p1Materials = [];
          value.p1MaterialOther = null;
          value.p1Distress = null;
          value.p1DistressOther = null;
          value.p1Severity = null;
          break;
        case 'P2':
          value.p2Materials = [];
          value.p2MaterialOther = null;
          value.p2Distress = null;
          value.p2DistressOther = null;
          value.p2Severity = null;
          break;
        case 'P3':
          value.p3Materials = [];
          value.p3MaterialOther = null;
          value.p3Distress = null;
          value.p3DistressOther = null;
          value.p3Severity = null;
          break;
        case 'P4':
          value.p4Materials = [];
          value.p4MaterialOther = null;
          value.p4Distress = null;
          value.p4DistressOther = null;
          value.p4Severity = null;
          break;
        case 'P5':
          value.p5Materials = [];
          value.p5MaterialOther = null;
          value.p5Distress = null;
          value.p5DistressOther = null;
          value.p5Severity = null;
          break;
        case 'S1':
          value.s1Materials = [];
          value.s1MaterialOther = null;
          value.s1Distress = null;
          value.s1DistressOther = null;
          value.s1Severity = null;
          break;
        case 'S2':
          value.s2Materials = [];
          value.s2MaterialOther = null;
          value.s2Distress = null;
          value.s2DistressOther = null;
          value.s2Severity = null;
          break;
        case 'S3':
          value.s3Materials = [];
          value.s3MaterialOther = null;
          value.s3Distress = null;
          value.s3DistressOther = null;
          value.s3Severity = null;
          break;
        case 'S4':
          value.s4Materials = [];
          value.s4MaterialOther = null;
          value.s4Distress = null;
          value.s4DistressOther = null;
          value.s4Severity = null;
          break;
        case 'S5':
          value.s5Materials = [];
          value.s5MaterialOther = null;
          value.s5Distress = null;
          value.s5DistressOther = null;
          value.s5Severity = null;
          break;
        case 'S6':
          value.s6Materials = [];
          value.s6MaterialOther = null;
          value.s6Distress = null;
          value.s6DistressOther = null;
          value.s6Severity = null;
          break;
        case 'S7':
          value.s7Materials = [];
          value.s7MaterialOther = null;
          value.s7Distress = null;
          value.s7DistressOther = null;
          value.s7Severity = null;
          break;
      }
    });
  }

  RxList<DropdownModel> packageDropdown = RxList();
  RxList<DropdownModel> districtDropdown = RxList();
  RxList<DropdownModel> roadDropdown = RxList();

  RxList<FilterBridgeType> superstructuresList = RxList();
  RxList<FilterBridgeType> parapetList = RxList();
  RxList<FilterBridgeType> bearingList = RxList();
  RxList<FilterBridgeType> expansionList = RxList();
  RxList<FilterBridgeType> deckList = RxList();
  RxList<FilterBridgeType> abutmentList = RxList();
  RxList<FilterBridgeType> pierList = RxList();

  RxList<DropdownModel> dropDownDistressP1 = RxList();
  RxList<DropdownModel> dropDownDistressP2 = RxList();
  RxList<DropdownModel> dropDownDistressP3 = RxList();
  RxList<DropdownModel> dropDownDistressP4 = RxList();
  RxList<DropdownModel> dropDownDistressP5 = RxList();

  RxList<DropdownModel> dropDownDistressS1 = RxList();
  RxList<DropdownModel> dropDownDistressS2 = RxList();
  RxList<DropdownModel> dropDownDistressS3 = RxList();
  RxList<DropdownModel> dropDownDistressS4 = RxList();
  RxList<DropdownModel> dropDownDistressS5 = RxList();
  RxList<DropdownModel> dropDownDistressS6 = RxList();
  RxList<DropdownModel> dropDownDistressS7 = RxList();

  RxList<Widget> newRecordPages = <Widget>[
    const LocationDataPage(),
    const BridgeTypePage(),
    const StructureDataPage(),
  ].obs;

  RxList<Widget> newInspectionPages = <Widget>[
    const PrimaryMemberPage(),
    const SecondaryMemberPage(),
    const PhotographsPage(),
    const DistressObservedPage(),
    const GeneralCommentPage(),
    const FeedbackPage(),
    const ApprovalPage(),
  ].obs;

  RxList<Widget> reviewFormB2Pages = <Widget>[
    const PhotographsPage(),
    const DistressObservedPage(),
    const GeneralCommentPage(),
    const FeedbackPage()
  ].obs;

  @override
  void onInit() async {
    super.onInit();
    form = FormBModel().obs;
    state.listen((v) {
      switch (v) {
        case LoaderState.initial:
        case LoaderState.loading:
          SmartDialog.showLoading(
              clickMaskDismiss: false, backType: SmartBackType.block);
          break;
        case LoaderState.loaded:
        case LoaderState.failure:
          SmartDialog.dismiss();
          break;
      }
    });

    if (Get.arguments['parentID'] != null) {
      setParentID(Get.arguments['parentID'].toString());
    }

    final draftId = _workflow.activeDraftId;
    setRecID = Get.arguments["recID"] ?? "";
    isReadOnly.value = Get.arguments["status"] == "Approved"
        ? true
        : Get.arguments["status"] == "Pending"
            ? false
            : false;

    if (formPage == "record") {
      await _loadFilterBridgeType();
      await _loadDistress();
    }

    if (formPage == "inspection" && !isResumeDraft) {
      await _loadPreviousData();
    }

    if (formPage == "review_B2") {
      isReviewMode.value = true;
    }

    if (isResumeDraft && draftId != null) {
      await _resumeDraft(draftId);
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
    await _loadFilterBridgeType();
    await _loadDistress();
    try {
      final previousRecID = Get.arguments["previousRecID"];
      setInspectionDate = DateFormat('yyyy-MM-dd')
          .format(Get.arguments['inspectionDate'] as DateTime);

      // Don't even hit the API if there is no previous record
      if (previousRecID == null || previousRecID.toString().isEmpty) {
        return;
      }

      state.value = LoaderState.loading;

      if (mainListingDetailsController != null) {
        setPackageID(mainListingDetailsController!.packageID);
        setDistrictID(mainListingDetailsController!.districtID);
        setRoadID(mainListingDetailsController!.routeID);
        setBridgeName(mainListingDetailsController!.bridgeName);
        setReferenceNo = mainListingDetailsController!.referenceNo;
      }

      // 1. Inherit the General & Location Data directly using previousRecID if add new record
      // try {
      //   final detailsResponse = await repository.showFormMainListingDetails(recID: previousRecID);
      //   if (detailsResponse != null && detailsResponse.data.isNotEmpty) {
      //     final details = detailsResponse.data.first;
      //     _populateFormFromDetails(details);
      //   }
      // } catch (e) {
      //   Get.log("Failed to fetch location details for inheritance: $e");
      // }

      // 2. Inherit the Material Data from previousRecID
      Form_B_InspectionDetailsModel data =
          await repository.showInspectionDetails(recID: previousRecID);

      // ONLY assign if data exists
      if (data.data.isNotEmpty) {
        final previous = data.data.first;

        // 1. Inherit Structure Data
        setStLaneWidth = previous.stLaneWidth ?? "";
        setStNoOfLane = previous.stNoOfLane ?? "";
        setStSpanLength = previous.stSpanLength ?? "";
        setStNoOfSpan = previous.stNoOfSpan ?? "";
        setStBridgeLength = previous.stBridgeLength ?? "";
        setStMedian = previous.stMedian ?? "";
        setStBridgeWidth = previous.stBridgeWidth ?? "";
        setStWalkway = previous.stWalkway ?? "";

        // 2. Inherit Primary Materials, Distress, & Severity
        setP1Materials = previous.p1Materials ?? [];
        setP1MaterialOther = previous.p1MaterialOther ?? "";
        setP1Distress = previous.p1Distress ?? "ND";
        setP1DistressOther = previous.p1DistressOther ?? "";
        setP1Severity = previous.p1Severity ?? "1";

        setP2Materials = previous.p2Materials ?? [];
        setP2MaterialOther = previous.p2MaterialOther ?? "";
        setP2Distress = previous.p2Distress ?? "ND";
        setP2DistressOther = previous.p2DistressOther ?? "";
        setP2Severity = previous.p2Severity ?? "1";

        setP3Materials = previous.p3Materials ?? [];
        setP3MaterialOther = previous.p3MaterialOther ?? "";
        setP3Distress = previous.p3Distress ?? "ND";
        setP3DistressOther = previous.p3DistressOther ?? "";
        setP3Severity = previous.p3Severity ?? "1";

        setP4Materials = previous.p4Materials ?? [];
        setP4MaterialOther = previous.p4MaterialOther ?? "";
        setP4Distress = previous.p4Distress ?? "ND";
        setP4DistressOther = previous.p4DistressOther ?? "";
        setP4Severity = previous.p4Severity ?? "1";

        setP5Materials = previous.p5Materials ?? [];
        setP5MaterialOther = previous.p5MaterialOther ?? "";
        setP5Distress = previous.p5Distress ?? "ND";
        setP5DistressOther = previous.p5DistressOther ?? "";
        setP5Severity = previous.p5Severity ?? "1";

        // 3. Inherit Secondary Materials, Distress, & Severity
        setS1Materials = previous.s1Materials ?? [];
        setS1MaterialOther = previous.s1MaterialOther ?? "";
        setS1Distress = previous.s1Distress ?? "ND";
        setS1DistressOther = previous.s1DistressOther ?? "";
        setS1Severity = previous.s1Severity ?? "1";

        setS2Materials = previous.s2Materials ?? [];
        setS2MaterialOther = previous.s2MaterialOther ?? "";
        setS2Distress = previous.s2Distress ?? "ND";
        setS2DistressOther = previous.s2DistressOther ?? "";
        setS2Severity = previous.s2Severity ?? "1";

        setS3Materials = previous.s3Materials ?? [];
        setS3MaterialOther = previous.s3MaterialOther ?? "";
        setS3Distress = previous.s3Distress ?? "ND";
        setS3DistressOther = previous.s3DistressOther ?? "";
        setS3Severity = previous.s3Severity ?? "1";

        setS4Materials = previous.s4Materials ?? [];
        setS4MaterialOther = previous.s4MaterialOther ?? "";
        setS4Distress = previous.s4Distress ?? "ND";
        setS4DistressOther = previous.s4DistressOther ?? "";
        setS4Severity = previous.s4Severity ?? "1";

        setS5Materials = previous.s5Materials ?? [];
        setS5MaterialOther = previous.s5MaterialOther ?? "";
        setS5Distress = previous.s5Distress ?? "ND";
        setS5DistressOther = previous.s5DistressOther ?? "";
        setS5Severity = previous.s5Severity ?? "1";

        setS6Materials = previous.s6Materials ?? [];
        setS6MaterialOther = previous.s6MaterialOther ?? "";
        setS6Distress = previous.s6Distress ?? "ND";
        setS6DistressOther = previous.s6DistressOther ?? "";
        setS6Severity = previous.s6Severity ?? "1";

        setS7Materials = previous.s7Materials ?? [];
        setS7MaterialOther = previous.s7MaterialOther ?? "";
        setS7Distress = previous.s7Distress ?? "ND";
        setS7DistressOther = previous.s7DistressOther ?? "";
        setS7Severity = previous.s7Severity ?? "1";

        form.refresh();
      }
      state.value = LoaderState.loaded;
    } catch (e) {
      state.value = LoaderState.failure;
      Get.log("Load Previous Data Error : ${e.toString()}");
    }
  }

  Future<void> _loadFilterBridgeType() async {
    try {
      state.value = LoaderState.loading;
      final box = GetStorage();

      // 1. Attempt to read from the local cache first
      final List rawSuper = box.read('cache_superstructure') ?? [];
      final List rawParapet = box.read('cache_parapet') ?? [];
      final List rawBearing = box.read('cache_bearing') ?? [];
      final List rawExpansion = box.read('cache_expansion') ?? [];
      final List rawDeck = box.read('cache_deck') ?? [];
      final List rawAbutment = box.read('cache_abutment') ?? [];
      final List rawPier = box.read('cache_pier') ?? [];

      // 2. If the cache has data, parse it and exit early
      if (rawSuper.isNotEmpty) {
        Get.log("Loading Bridge Types from local cache...");
        superstructuresList.assignAll(
            rawSuper.map((e) => FilterBridgeType.fromJson(e)).toList());
        parapetList.assignAll(
            rawParapet.map((e) => FilterBridgeType.fromJson(e)).toList());
        bearingList.assignAll(
            rawBearing.map((e) => FilterBridgeType.fromJson(e)).toList());
        expansionList.assignAll(
            rawExpansion.map((e) => FilterBridgeType.fromJson(e)).toList());
        deckList.assignAll(
            rawDeck.map((e) => FilterBridgeType.fromJson(e)).toList());
        abutmentList.assignAll(
            rawAbutment.map((e) => FilterBridgeType.fromJson(e)).toList());
        pierList.assignAll(
            rawPier.map((e) => FilterBridgeType.fromJson(e)).toList());

        state.value = LoaderState.loaded;
        return; // UI is loaded, exit the function
      }

      // 3. Fallback: Cache is empty, so fetch from the remote API
      Get.log("Cache is empty. Fetching Bridge Types from API...");
      final results = await Future.wait([
        btRepository.showFilterBtSuperstructure(),
        btRepository.showFilterBtParapet(),
        btRepository.showFilterBtBearing(),
        btRepository.showFilterBtExpansion(),
        btRepository.showFilterBtDeck(),
        btRepository.showFilterBtAbutment(),
        btRepository.showFilterBtPier(),
      ]);

      // Assign the API results to your reactive lists
      superstructuresList.assignAll(results[0].data);
      parapetList.assignAll(results[1].data);
      bearingList.assignAll(results[2].data);
      expansionList.assignAll(results[3].data);
      deckList.assignAll(results[4].data);
      abutmentList.assignAll(results[5].data);
      pierList.assignAll(results[6].data);

      // 4. Save the newly fetched data to the cache for future offline use
      box.write('cache_superstructure',
          results[0].data.map((e) => e.toJson()).toList());
      box.write(
          'cache_parapet', results[1].data.map((e) => e.toJson()).toList());
      box.write(
          'cache_bearing', results[2].data.map((e) => e.toJson()).toList());
      box.write(
          'cache_expansion', results[3].data.map((e) => e.toJson()).toList());
      box.write('cache_deck', results[4].data.map((e) => e.toJson()).toList());
      box.write(
          'cache_abutment', results[5].data.map((e) => e.toJson()).toList());
      box.write('cache_pier', results[6].data.map((e) => e.toJson()).toList());

      state.value = LoaderState.loaded;
    } catch (err) {
      Get.log("Error loading Bridge Types: $err");
      state.value = LoaderState.failure;
    }
  }

  Future<void> _loadDistress() async {
    try {
      state.value = LoaderState.loading;

      //----- Reading reference data from Cache START ----
      final box = GetStorage();
      void sortS1List(List<DropdownModel> list) {
        final s1Order = ["damaged", "inadequate", "no distress", "other"];
        list.sort((a, b) {
          int indexA = s1Order
              .indexWhere((item) => a.value.toLowerCase().contains(item));
          int indexB = s1Order
              .indexWhere((item) => b.value.toLowerCase().contains(item));
          if (indexA == -1) indexA = 999;
          if (indexB == -1) indexB = 999;
          return indexA.compareTo(indexB);
        });
      }

      // 1. Attempt to read from the local cache first
      final List rawP1 = box.read('cache_distress_P1') ?? [];
      final List rawP2 = box.read('cache_distress_P2') ?? [];
      final List rawP3 = box.read('cache_distress_P3') ?? [];
      final List rawP4 = box.read('cache_distress_P4') ?? [];
      final List rawP5 = box.read('cache_distress_P5') ?? [];
      final List rawS1 = box.read('cache_distress_S1') ?? [];
      final List rawS2 = box.read('cache_distress_S2') ?? [];
      final List rawS3 = box.read('cache_distress_S3') ?? [];
      final List rawS4 = box.read('cache_distress_S4') ?? [];
      final List rawS5 = box.read('cache_distress_S5') ?? [];
      final List rawS6 = box.read('cache_distress_S6') ?? [];
      final List rawS7 = box.read('cache_distress_S7') ?? [];

      // Helper to convert JSON from cache into DropdownModel
      DropdownModel mapFromCache(dynamic json) {
        final distress = Distress.fromJson(json);
        return DropdownModel(distress.distressCode, distress.distressName);
      }

      // 2. If the cache has data, parse it and exit early
      if (rawP1.isNotEmpty) {
        Get.log("Loading Distress from local cache...");
        dropDownDistressP1.value = rawP1.map((e) => mapFromCache(e)).toList();
        dropDownDistressP2.value = rawP2.map((e) => mapFromCache(e)).toList();
        dropDownDistressP3.value = rawP3.map((e) => mapFromCache(e)).toList();
        dropDownDistressP4.value = rawP4.map((e) => mapFromCache(e)).toList();
        dropDownDistressP5.value = rawP5.map((e) => mapFromCache(e)).toList();
        List<DropdownModel> cachedS1List =
            rawS1.map((e) => mapFromCache(e)).toList();
        sortS1List(cachedS1List);
        dropDownDistressS1.value = cachedS1List;
        dropDownDistressS2.value = rawS2.map((e) => mapFromCache(e)).toList();
        dropDownDistressS3.value = rawS3.map((e) => mapFromCache(e)).toList();
        dropDownDistressS4.value = rawS4.map((e) => mapFromCache(e)).toList();
        dropDownDistressS5.value = rawS5.map((e) => mapFromCache(e)).toList();
        dropDownDistressS6.value = rawS6.map((e) => mapFromCache(e)).toList();
        dropDownDistressS7.value = rawS7.map((e) => mapFromCache(e)).toList();

        state.value = LoaderState.loaded;
        return; // UI is loaded, exit the function
      }
      //----- Reading reference data from Cache END ----

      // 3. Fallback: Cache is empty, so fetch from the remote API
      Get.log("Cache is empty. Fetching Distress from API...");
      final results = await Future.wait([
        repository.showDistress(distressGroup: 'P1'),
        repository.showDistress(distressGroup: 'P2'),
        repository.showDistress(distressGroup: 'P3'),
        repository.showDistress(distressGroup: 'P4'),
        repository.showDistress(distressGroup: 'P5'),
        repository.showDistress(distressGroup: 'S1'),
        repository.showDistress(distressGroup: 'S2'),
        repository.showDistress(distressGroup: 'S3'),
        repository.showDistress(distressGroup: 'S4'),
        repository.showDistress(distressGroup: 'S5'),
        repository.showDistress(distressGroup: 'S6'),
        repository.showDistress(distressGroup: 'S7'),
      ]);

      // Assign the API results to your reactive lists
      dropDownDistressP1.value = results[0]
          .data
          .map((e) => DropdownModel(e.distressCode, e.distressName))
          .toList();
      dropDownDistressP2.value = results[1]
          .data
          .map((e) => DropdownModel(e.distressCode, e.distressName))
          .toList();
      dropDownDistressP3.value = results[2]
          .data
          .map((e) => DropdownModel(e.distressCode, e.distressName))
          .toList();
      dropDownDistressP4.value = results[3]
          .data
          .map((e) => DropdownModel(e.distressCode, e.distressName))
          .toList();
      dropDownDistressP5.value = results[4]
          .data
          .map((e) => DropdownModel(e.distressCode, e.distressName))
          .toList();

      List<DropdownModel> apiS1List = results[5]
          .data
          .map((e) => DropdownModel(e.distressCode, e.distressName))
          .toList();
      sortS1List(apiS1List);
      dropDownDistressS1.value = apiS1List;

      dropDownDistressS2.value = results[6]
          .data
          .map((e) => DropdownModel(e.distressCode, e.distressName))
          .toList();

      dropDownDistressS3.value = results[7]
          .data
          .map((e) => DropdownModel(e.distressCode, e.distressName))
          .toList();
      dropDownDistressS4.value = results[8]
          .data
          .map((e) => DropdownModel(e.distressCode, e.distressName))
          .toList();
      dropDownDistressS5.value = results[9]
          .data
          .map((e) => DropdownModel(e.distressCode, e.distressName))
          .toList();
      dropDownDistressS6.value = results[10]
          .data
          .map((e) => DropdownModel(e.distressCode, e.distressName))
          .toList();
      dropDownDistressS7.value = results[11]
          .data
          .map((e) => DropdownModel(e.distressCode, e.distressName))
          .toList();

      // 4. Save the newly fetched data to the cache for future offline use
      box.write(
          'cache_distress_P1', results[0].data.map((e) => e.toJson()).toList());
      box.write(
          'cache_distress_P2', results[1].data.map((e) => e.toJson()).toList());
      box.write(
          'cache_distress_P3', results[2].data.map((e) => e.toJson()).toList());
      box.write(
          'cache_distress_P4', results[3].data.map((e) => e.toJson()).toList());
      box.write(
          'cache_distress_P5', results[4].data.map((e) => e.toJson()).toList());
      box.write(
          'cache_distress_S1', results[5].data.map((e) => e.toJson()).toList());
      box.write(
          'cache_distress_S2', results[6].data.map((e) => e.toJson()).toList());
      box.write(
          'cache_distress_S3', results[7].data.map((e) => e.toJson()).toList());
      box.write(
          'cache_distress_S4', results[8].data.map((e) => e.toJson()).toList());
      box.write(
          'cache_distress_S5', results[9].data.map((e) => e.toJson()).toList());
      box.write('cache_distress_S6',
          results[10].data.map((e) => e.toJson()).toList());
      box.write('cache_distress_S7',
          results[11].data.map((e) => e.toJson()).toList());

      state.value = LoaderState.loaded;
    } catch (err) {
      Get.log("Error loading Distress: $err");
      state.value = LoaderState.failure;
    }
  }

  // Future<void> submitNewRecord() async {
  //   setPackageID(baseFormController.getPackageID);
  //   setDistrictID(baseFormController.getDistrictID);
  //   setRoadID(baseFormController.getRoadID);
  //   setRoadName(baseFormController.getRoadName);
  //
  //   Get.log(jsonEncode(form.toJson()));
  //
  //   try {
  //     state.value = LoaderState.loading;
  //     //save new record without inspection date first
  //     setInspectionDate = "";
  //     final response = await FormRepository(formType: "B")
  //         .submitNewInspectionForm(mapForm: form.value.toJson());
  //     state.value = LoaderState.loaded;
  //     //back to main listing screen
  //     Get.back();
  //     //apply filters so it show new data saved just now
  //     await mainListingController!.apply(
  //       packageID: getPackageID!,
  //       districtID: getDistrictID!,
  //       routeID: getRoadID!,
  //       refNo: getReferenceNo,
  //     );
  //
  //     SmartDialog.showToast(response.data['data']);
  //   } catch (e) {
  //     Get.log(e.toString());
  //     state.value = LoaderState.failure;
  //     SmartDialog.showToast("Failed submit");
  //   }
  // }

  Future<void> submitNewInspection() async {
    if (!_workflow.beginSubmission()) return;
    try {
      await _submitNewInspection();
    } finally {
      _workflow.endSubmission();
    }
  }

  Future<void> _submitNewInspection() async {
    // --- 1. PULL ROUTING DATA FROM BASE CONTROLLER (ONLY IF NEW RECORD) ---
    // If it is a direct inspection, the routing data is already safely loaded from _loadPreviousData()
    // if (formPage == 'record') {
    //   setPackageID(baseFormController.getPackageID);
    //   setDistrictID(baseFormController.getDistrictID);
    //   setRoadID(baseFormController.getRoadID);
    //   setRoadName(baseFormController.getRoadName);
    // }

    // A resumed draft already owns its saved routing data, so never let an
    // unrelated details context overwrite the restored values.
    final sourceDetails = isResumeDraft ? null : mainListingDetailsController;
    if (sourceDetails != null) {
      if (sourceDetails.parentID.isNotEmpty) {
        setParentID(sourceDetails.parentID);
      }
      setPackageID(sourceDetails.packageID);
      setDistrictID(sourceDetails.districtID);
      setRoadID(sourceDetails.routeID);
      setBridgeName(sourceDetails.bridgeName);
      if (sourceDetails.referenceNo.isNotEmpty) {
        setReferenceNo = sourceDetails.referenceNo;
      }
    }

    // The editor may be reused after its first successful submission. Always
    // restore the parent from the fresh navigation arguments before creating
    // the next API payload.
    final arguments = Get.arguments;
    if (arguments is Map) {
      final argumentParentID = arguments['parentID']?.toString().trim() ?? '';
      if (argumentParentID.isNotEmpty) {
        setParentID(argumentParentID);
      }
    }

    // --- 1.5. AUTO-FILL DATE IF MISSING ---
    if (getInspectionDate.toString().isEmpty) {
      setInspectionDate = DateFormat('yyyy-MM-dd')
          .format(Get.arguments['inspectionDate'] as DateTime);
    }

    if (!_validateSubmission()) return;

    var serverSubmissionCompleted = false;

    try {
      state.value = LoaderState.loading;

      final Map<String, dynamic> apiPayload = form.value.toApiSubmitJson();
      _applyUncheckedMembers(apiPayload);
      Get.log("Submitting API payload: ${jsonEncode(apiPayload)}");

      final submission = await _submissionCoordinator.submit(
        existingInspectionID: _workflow.submittedInspectionID,
        submitMain: () async {
          final res = await FormRepository(formType: "B")
              .submitNewInspectionFormB(mapForm: apiPayload);
          return res.data;
        },
        resolveInspectionID: (responseData) => resolveGeneralInspectionID(
          responseData,
          formType: 'B',
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
        final apiError = submission.error;
        Get.log("API Error intercepted: $apiError");
        SmartDialog.showToast("Connection issue. Saving to drafts...",
            displayTime: const Duration(seconds: 3));
        return;
      }

      serverSubmissionCompleted = true;
      _workflow.submissionCompleted = true;
      final latestRecId = submission.inspectionID;

      // --- 3. UI CLEANUP ---
      // Capture this before cleanup resets the draft flag; submissions opened
      // from Local Drafts must still navigate to the refreshed details list.
      final wasResumeDraft = isResumeDraft;
      try {
        await removeSubmittedDraft();
      } catch (e) {
        Get.log('Post-submit Form B draft cleanup warning: $e');
      }

      final openedFromDetails = mainListingDetailsController != null;

      if (openedFromDetails) {
        try {
          await mainListingDetailsController!
              .refreshUntilInspectionVisible(latestRecId);
        } catch (e) {
          Get.log('Post-submit Form B list refresh warning: $e');
        }
      }
      final navigationArguments = <String, dynamic>{
        'formType': 'B',
        'formTitle': 'BRIDGE VISUAL INSPECTION (RECORD & FORM)',
        'parentID': getParentID,
        'recID': getParentID,
        'isMainListing': true,
        'packageID': getPackageID,
        'districtID': getDistrictID,
        'routeID': getRoadID,
        'bridgeName': getBridgeName,
        'refNo': getReferenceNo,
      };
      final isNewRecordFlow = (formPage == 'record') &&
          (Get.arguments != null && Get.arguments['formPage'] == 'inspection');

      // Resetting the editor is local cleanup only.
      // Do not allow it to block successful navigation.
      try {
        resetEditorStateAfterSuccessfulSubmission();
      } catch (e) {
        Get.log('Post-submit Form B editor reset warning: $e');
      }

      state.value = LoaderState.loaded;
      SmartDialog.showToast('Inspection submitted successfully');

      // --- 4. NAVIGATION AFTER SUCCESS ---
      if (openedFromDetails) {
        // Draft/new inspection was opened from the Form B details page.
        // Return there and tell it to refresh.
        Get.back(result: true);
        return;
      }

      if (isNewRecordFlow) {
        Get.close(2);
        return;
      }

      // Draft was opened somewhere else, e.g. a global Draft screen.
      // Send the user to the inspection records/details page.
      if (wasResumeDraft) {
        Get.offNamed(
          '/main_listing_form_details',
          arguments: navigationArguments,
        );
        return;
      }

      Get.back();
    } catch (e) {
      if (serverSubmissionCompleted) {
        Get.log(
          'Post-submit local/UI error '
          '(server submission already succeeded): $e',
        );

        state.value = LoaderState.loaded;

        SmartDialog.showToast(
          'Inspection submitted successfully',
        );

        // The server already accepted the inspection.
        // Make sure the user does not remain on a submit-able form.
        if (Get.currentRoute == '/base_form') {
          Get.back(result: true);
        }

        return;
      }

      Get.log("Internal Error during submit: ${e.toString()}");
      state.value = LoaderState.failure;
      SmartDialog.showToast("Failed to process inspection");
    }
  }

  void resetEditorStateAfterSuccessfulSubmission() {
    // Clear inspection answers while retaining the bridge identity needed if
    // GetX reuses this editor controller for the next inspection.
    form.value = FormBModel(
      parentID: getParentID,
      packageID: getPackageID,
      districtID: getDistrictID,
      roadID: getRoadID,
      roadName: getRoadName,
      bridgeName: getBridgeName,
      referenceNo: getReferenceNo,
    );
    useCurrentLocation.value = false;
    memberCheckboxes.updateAll((_, __) => true);
    isReviewMode.value = false;
    isResumeDraft = false;
    baseFormController.resetEditorState();

    if (pageController != null && pageController!.hasClients) {
      pageController!.jumpToPage(0);
    }
    form.refresh();
  }

  Future<void> fetchCurrentLocation(bool value) async {
    useCurrentLocation.value = value;
    if (!value) return;

    try {
      state.value = LoaderState.loading;
      // 1. Check if service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state.value = LoaderState.failure;
        useCurrentLocation.value = false;
        // Show a dialog asking them to open settings
        Get.defaultDialog(
          titlePadding: const EdgeInsets.all(10),
          contentPadding: const EdgeInsets.all(20),
          title: "Location Disabled",
          middleText:
              "Please enable location services to automatically fetch your coordinates.",
          textConfirm: "Open Settings",
          textCancel: "Cancel",
          onConfirm: () async {
            Get.back();
            await Geolocator.openLocationSettings(); // Opens device settings
          },
        );
        return;
      }

      // 2. Check Permissions
      LocationPermission permission = await Geolocator.checkPermission();

      // Handle standard denial (user said no once, we can ask again)
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state.value = LoaderState.failure;
          useCurrentLocation.value = false;
          Get.snackbar("Permission Denied",
              "Location permissions are required to use this feature.");
          return;
        }
      }

      // Handle permanent denial (OS blocks the permission popup)
      if (permission == LocationPermission.deniedForever) {
        state.value = LoaderState.failure;
        useCurrentLocation.value = false;

        // Show a dialog forcing them to go to settings
        Get.defaultDialog(
          titlePadding: const EdgeInsets.all(10),
          contentPadding: const EdgeInsets.all(20),
          title: "Permission Required",
          middleText:
              "Location permissions are permanently denied. Please enable them in your app settings to continue.",
          textConfirm: "Open Settings",
          textCancel: "Cancel",
          onConfirm: () async {
            Get.back();
            await Geolocator
                .openAppSettings(); // Opens the App's specific settings page
          },
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        state.value = LoaderState.failure;
        useCurrentLocation.value = false;
        Get.snackbar("Error", "Location permissions are permanently denied.");
        return;
      }

      // 3. Get Position
      // Using high accuracy for engineering/road forms
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          //timeLimit: Duration(seconds: 30),
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
      Get.log("Latitude: ${position.latitude}");
      Get.log("Longitude: ${position.longitude}");

      //setGpsEasting = position.latitude.toStringAsFixed(6);
      //setGpsNorting = position.longitude.toStringAsFixed(6);

      setGpsEasting = pointForward.x.toStringAsFixed(3);
      setGpsNorting = pointForward.y.toStringAsFixed(3);

      state.value = LoaderState.loaded;
    } catch (e) {
      useCurrentLocation.value = false;
      state.value = LoaderState.failure;
      Get.snackbar("Error", "Failed to get location, please try again !");
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
        .deleteRequired(draftId, formType: 'Form B');

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

    // The root binding normally owns this controller, but routes restored by
    // the OS can reach the editor before that binding has registered it.
    if (!Get.isRegistered<FormDraftController>()) {
      Get.put(FormDraftController());
    }

    final formDraftController = Get.find<FormDraftController>();

    try {
      state.value = LoaderState.loading;

      // --- Check if we are resuming a draft ---
      final wasResumeDraft = isResumeDraft;
      final currentDraftId = _currentDraftId;

      if (_workflow.submittedInspectionID == null) {
        setRecID = "";
      }

      // ==========================================
      // FIX: PULL ROUTING & DATE DATA BEFORE SAVING
      // ==========================================
      if (!isResumeDraft && mainListingDetailsController != null) {
        setPackageID(mainListingDetailsController!.packageID);
        setDistrictID(mainListingDetailsController!.districtID);
        setRoadID(mainListingDetailsController!.routeID);
        setBridgeName(mainListingDetailsController!.bridgeName);
      }

      // Auto-fill date if it hasn't been set
      if (getInspectionDate.toString().isEmpty) {
        setInspectionDate = DateTime.now().toIso8601String();
      }
      // ==========================================

      // --- Combine Form B data with BaseFormController Data ---
      Map<String, dynamic> combinedJson = form.value.toDraftJson();
      _applyUncheckedMembers(combinedJson);
      combinedJson['member_checkboxes'] =
          memberCheckboxes.map((key, value) => MapEntry(key, value));

      bool isNewRecord = (formPage == 'record');

      // We safely check arguments just in case it came from the Continue button
      if (Get.arguments != null && Get.arguments is Map) {
        if (Get.arguments['is_new_record'] == true) {
          isNewRecord = true;
        }
      }

      combinedJson['is_new_record'] = isNewRecord;
      final detailsContext = mainListingDetailsController;
      InspectionDraftSupport.addCommonData(
        combinedJson,
        baseController: baseFormController,
        useCurrentLocation: useCurrentLocation.value,
        submittedInspectionID: _workflow.submittedInspectionID,
        packageName: detailsContext?.packageName ?? '',
        districtName: detailsContext?.districtName ?? '',
        roadName: getRoadName.isNotEmpty
            ? getRoadName
            : detailsContext?.roadName ?? '',
      );

      // 1. Convert the ENTIRE combined state to a JSON string
      final String formDataJson = jsonEncode(combinedJson);

      Get.log('Saving Draft Data: $formDataJson');

      final savedDraftID =
          await InspectionDraftStore(formDraftController).upsert(
        draftID: currentDraftId,
        formType: 'Form B',
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
        // Since the controller was initialized on the 'record' page, if the
        // active arguments say 'inspection', both stacked form screens close.
        final isSecondScreen = (formPage == 'record') &&
            (Get.arguments != null &&
                Get.arguments['formPage'] == 'inspection');

        if (isSecondScreen) {
          Get.close(2);
        } else {
          Get.back();
        }

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
    await _loadFilterBridgeType();
    await _loadDistress();
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
        final savedCheckboxes = jsonData['member_checkboxes'];
        if (savedCheckboxes is Map) {
          for (final code in memberCheckboxes.keys.toList()) {
            memberCheckboxes[code] = savedCheckboxes[code] == true;
          }
        }
        // 1. Decode Form B Model
        form.value = FormBModel.fromJson(jsonData);
        form.refresh();

        // --- SAFELY RESTORE ROUTING DATA INTO BASE CONTROLLER ---
        String? savedPackageId = jsonData['packageId']?.toString();
        String? savedDistrictId = jsonData['districtId']?.toString();
        String? savedRoadId = jsonData['roadId']?.toString();
        String? savedRoadName = jsonData['RoadName']?.toString();
        String? savedBridgeName = jsonData['bridgeName']?.toString();

        if (savedPackageId != null && savedPackageId.isNotEmpty) {
          baseFormController.setPackageID = savedPackageId;
          // IMPORTANT: Must load districts before setting the District ID!
          await baseFormController.loadDistrict();
        }

        if (savedDistrictId != null && savedDistrictId.isNotEmpty) {
          baseFormController.setDistrictID = savedDistrictId;
          // IMPORTANT: Must load routes before setting the Route ID!
          await baseFormController.loadRoute();
        }

        if (savedRoadId != null && savedRoadId.isNotEmpty) {
          baseFormController.setRoadID = savedRoadId;
          baseFormController.setRoadName = savedRoadName ?? "";
        }

        if (savedBridgeName != null && savedBridgeName.isNotEmpty) {
          setBridgeName(savedBridgeName);
        }

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

  void _populateFormFromDetails(Form_B_MainListingDetailsDataModel details) {
    setReferenceNo = details.referenceNo ?? "";
    setRiverName = details.riverName ?? "";
    setChainageKilometre = details.chainage ?? "";
    setStructureCode = details.structureCode ?? "";
    setGpsEasting = details.gpsEasting ?? "";
    setGpsNorting = details.gpsNorthing ?? "";

    setBtSuperstructureID = superstructuresList
        .firstWhere(
          (e) => e.name == details.superstructure,
          orElse: () => const FilterBridgeType(recID: 0, name: ""),
        )
        .recID;

    setBtParapetID = parapetList
        .firstWhere(
          (e) => e.name == details.parapet,
          orElse: () => const FilterBridgeType(recID: 0, name: ""),
        )
        .recID;

    setBtBearingID = bearingList
        .firstWhere(
          (e) => e.name == details.bearing,
          orElse: () => const FilterBridgeType(recID: 0, name: ""),
        )
        .recID;

    setBtExpansionID = expansionList
        .firstWhere(
          (e) => e.name == details.expansion,
          orElse: () => const FilterBridgeType(recID: 0, name: ""),
        )
        .recID;

    setBtDeckID = deckList
        .firstWhere(
          (e) => e.name == details.deck,
          orElse: () => const FilterBridgeType(recID: 0, name: ""),
        )
        .recID;

    setBtAbutmentID = abutmentList
        .firstWhere(
          (e) => e.name == details.abutment,
          orElse: () => const FilterBridgeType(recID: 0, name: ""),
        )
        .recID;

    setBtPierID = pierList
        .firstWhere(
          (e) => e.name == details.pier,
          orElse: () => const FilterBridgeType(recID: 0, name: ""),
        )
        .recID;

    setBtNoOfExpansion = details.noOfExpansion ?? "";
  }

  bool validateRecordData() {
    List<String> errors = [];

    // 1. Validate Dropdowns (Routing Data)
    if (baseFormController.getPackageID == null ||
        baseFormController.getPackageID!.isEmpty) {
      errors.add("Package must be selected.");
    }
    if (baseFormController.getDistrictID == null ||
        baseFormController.getDistrictID!.isEmpty) {
      errors.add("District must be selected.");
    }
    if (baseFormController.getRoadID == null ||
        baseFormController.getRoadID!.isEmpty) {
      errors.add("Road Code must be selected.");
    }

    // 2. Validate Text Fields
    if (getReferenceNo.trim().isEmpty) {
      errors.add("Reference No. is required.");
    }
    if (getChainageKilometre.trim().isEmpty) {
      errors.add("Chainage / Kilometre is required.");
    }
    if (getRiverName.trim().isEmpty) {
      errors.add("River Name is required.");
    }
    if (getGpsEasting.trim().isEmpty) {
      errors.add("GPS Easting is required.");
    }
    if (getGpsNorting.trim().isEmpty) {
      errors.add("GPS Northing is required.");
    }

    if (errors.isNotEmpty) {
      String combinedErrorMessage = errors.map((e) => '• $e').join('\n');
      _showValidationErrorDialog(combinedErrorMessage);
      return false;
    }

    return true;
  }

  bool _validateSubmission() {
    List<String> errors = [];

    if (getParentID == null || getParentID!.trim().isEmpty) {
      errors.add("Bridge parent record is missing. Please reopen the bridge.");
    }

    // -- CHECK MATERIALS & DISTRESS --
    List<Map<String, dynamic>> validationFields = [
      {
        "name": "P1",
        "materials": getP1Materials,
        "materialOther": getP1MaterialOther,
        "distress": getP1Distress,
        "distressOther": getP1DistressOther
      },
      {
        "name": "P2",
        "materials": getP2Materials,
        "materialOther": getP2MaterialOther,
        "distress": getP2Distress,
        "distressOther": getP2DistressOther
      },
      {
        "name": "P3",
        "materials": getP3Materials,
        "materialOther": getP3MaterialOther,
        "distress": getP3Distress,
        "distressOther": getP3DistressOther
      },
      {
        "name": "P4",
        "materials": getP4Materials,
        "materialOther": getP4MaterialOther,
        "distress": getP4Distress,
        "distressOther": getP4DistressOther
      },
      {
        "name": "P5",
        "materials": getP5Materials,
        "materialOther": getP5MaterialOther,
        "distress": getP5Distress,
        "distressOther": getP5DistressOther
      },
      {
        "name": "S1",
        "materials": getS1Materials,
        "materialOther": getS1MaterialOther,
        "distress": getS1Distress,
        "distressOther": getS1DistressOther
      },
      {
        "name": "S2",
        "materials": getS2Materials,
        "materialOther": getS2MaterialOther,
        "distress": getS2Distress,
        "distressOther": getS2DistressOther
      },
      {
        "name": "S3",
        "materials": getS3Materials,
        "materialOther": getS3MaterialOther,
        "distress": getS3Distress,
        "distressOther": getS3DistressOther
      },
      {
        "name": "S4",
        "materials": getS4Materials,
        "materialOther": getS4MaterialOther,
        "distress": getS4Distress,
        "distressOther": getS4DistressOther
      },
      {
        "name": "S5",
        "materials": getS5Materials,
        "materialOther": getS5MaterialOther,
        "distress": getS5Distress,
        "distressOther": getS5DistressOther
      },
      {
        "name": "S6",
        "materials": getS6Materials,
        "materialOther": getS6MaterialOther,
        "distress": getS6Distress,
        "distressOther": getS6DistressOther
      },
      {
        "name": "S7",
        "materials": getS7Materials,
        "materialOther": getS7MaterialOther,
        "distress": getS7Distress,
        "distressOther": getS7DistressOther
      },
    ];

    List<String> missingMaterials = [];
    List<String> missingMaterialOtherTexts = [];
    List<String> missingDistressOtherTexts = [];

    for (var field in validationFields) {
      String name = field["name"];
      if (!isMemberChecked(name)) continue;
      List<dynamic> materials = field["materials"];
      String materialOther = field["materialOther"];
      String distress = field["distress"];
      String distressOther = field["distressOther"];

      // Rule A: Make sure at least one material is selected
      if (materials.isEmpty) {
        missingMaterials.add(name);
      }
      // Rule B: If "O" is selected, the 'other' material text field must not be empty
      else if (materials.contains("O") && materialOther.trim().isEmpty) {
        missingMaterialOtherTexts.add(name);
      }

      // Rule C: If "OTH" (Other) is selected for distress, the 'other' distress text field must not be empty
      if (distress == "OTH" && distressOther.trim().isEmpty) {
        missingDistressOtherTexts.add(name);
      }
    }

    if (missingMaterials.isNotEmpty) {
      errors.add("Materials not selected for: ${missingMaterials.join(', ')}.");
    }

    if (missingMaterialOtherTexts.isNotEmpty) {
      errors.add(
          "Please specify the 'Other' material for: ${missingMaterialOtherTexts.join(', ')}.");
    }

    if (missingDistressOtherTexts.isNotEmpty) {
      errors.add(
          "Please specify the 'Other' distress for: ${missingDistressOtherTexts.join(', ')}.");
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

  // void backPage() {
  //   if (pageController != null && pageController!.hasClients) {
  //     pageController!.previousPage(
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeIn,
  //     );
  //   }
  // }

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

  //basic
  //--GETTERS
  String? get getParentID => form.value.parentID;
  String? get getPackageID => form.value.packageID;
  String? get getDistrictID => form.value.districtID;
  String? get getRoadID => form.value.roadID;
  String get getRoadName => form.value.roadName ?? "";
  String get getBridgeName => form.value.bridgeName ?? "";

  String? get getRecID => form.value.recID;
  get getInspectionDate => form.value.inspectionDate ?? "";

  //--SETTERS
  set setRecID(String value) => form.value.recID = value;
  set setInspectionDate(String value) => form.value.inspectionDate = value;

  void setParentID(String? v) => form.update((val) => val?.parentID = v);
  void setPackageID(String? v) => form.update((val) => val?.packageID = v);
  void setDistrictID(String? v) => form.update((val) => val?.districtID = v);
  void setRoadID(String? v) => form.update((val) => val?.roadID = v);
  void setRoadName(String? v) => form.update((val) => val?.roadName = v);
  void setBridgeName(String? v) => form.update((val) => val?.bridgeName = v);

  //1. Location data
  //---GETTERS
  get getReferenceNo => form.value.referenceNo ?? "";
  get getChainageKilometre => form.value.chainageKilometre ?? "";
  get getStructureCode => form.value.structureCode ?? "";
  get getRiverName => form.value.riverName ?? "";
  get getGpsEasting => form.value.gpsEasting ?? "";
  get getGpsNorting => form.value.gpsNorting ?? "";
  //--SETTERS
  set setReferenceNo(String value) => form.value.referenceNo = value;
  set setChainageKilometre(String value) =>
      form.value.chainageKilometre = value;
  set setStructureCode(String value) => form.value.structureCode = value;
  set setRiverName(String value) => form.value.riverName = value;
  set setGpsEasting(String value) =>
      form.update((val) => form.value.gpsEasting = value);
  set setGpsNorting(String value) =>
      form.update((val) => form.value.gpsNorting = value);

  //2. Bridge type
  //---GETTERS
  get getBtSuperstructureID => form.value.btSuperstructureID ?? 0;
  get getBtParapetID => form.value.btParapetID ?? 0;
  get getBtBearingID => form.value.btBearingID ?? 0;
  get getBtExpansionID => form.value.btExpansionID ?? 0;
  get getBtDeckID => form.value.btDeckID ?? 0;
  get getBtAbutmentID => form.value.btAbutmentID ?? 0;
  get getBtPierID => form.value.btPierID ?? 0;

  get getBtNoOfExpansion => form.value.btNoOfExpansion ?? "";
  get getBtNoOfExpansionFirstPart =>
      RegExp(r'^(\d+)@').firstMatch(getBtNoOfExpansion)?.group(1)?.trim() ?? "";
  get getBtNoOfExpansionSecondPart =>
      RegExp(r'@(\d+)').firstMatch(getBtNoOfExpansion)?.group(1)?.trim() ?? "";

//--SETTERS
  set setBtSuperstructureID(int value) => form.value.btSuperstructureID = value;
  set setBtParapetID(int value) => form.value.btParapetID = value;
  set setBtBearingID(int value) => form.value.btBearingID = value;
  set setBtExpansionID(int value) => form.value.btExpansionID = value;
  set setBtDeckID(int value) => form.value.btDeckID = value;
  set setBtAbutmentID(int value) => form.value.btAbutmentID = value;
  set setBtPierID(int value) => form.value.btPierID = value;

  set setBtNoOfExpansion(String value) => form.value.btNoOfExpansion = value;

  setBtNoOfExpansionFirstPart(String firstPart) {
    final parts = (getBtNoOfExpansion ?? '').split('@');
    final secondPart = parts.length > 1 ? parts[1] : '';
    setBtNoOfExpansion =
        "$firstPart@$secondPart${secondPart.contains('meter per expansion joint') ? '' : ' meter per expansion joint'}";
  }

  setBtNoOfExpansionSecondPart(String secondPart) {
    final parts = (getBtNoOfExpansion ?? '').split('@');
    final firstPart = parts.isNotEmpty ? parts[0] : '';
    setBtNoOfExpansion =
        "$firstPart@$secondPart${secondPart.contains('meter per expansion joint') ? '' : ' meter per expansion joint'}";
  }

  // 3. Structure Data
// ---GETTERS
  get getStLaneWidth => form.value.stLaneWidth ?? "";
  get getStNoOfLane => form.value.stNoOfLane ?? "";
  get getStSpanLength => form.value.stSpanLength ?? "";
  get getStNoOfSpan => form.value.stNoOfSpan ?? "";
  get getStBridgeLength => form.value.stBridgeLength ?? "";
  get getStMedian => form.value.stMedian ?? "";
  get getStBridgeWidth => form.value.stBridgeWidth ?? "";
  get getStWalkway => form.value.stWalkway ?? "";
// ---SETTERS
  set setStLaneWidth(String value) => form.value.stLaneWidth = value;
  set setStNoOfLane(String value) => form.value.stNoOfLane = value;
  set setStSpanLength(String value) => form.value.stSpanLength = value;
  set setStNoOfSpan(String value) => form.value.stNoOfSpan = value;
  set setStBridgeLength(String value) => form.value.stBridgeLength = value;
  set setStMedian(String value) => form.value.stMedian = value;
  set setStBridgeWidth(String value) => form.value.stBridgeWidth = value;
  set setStWalkway(String value) => form.value.stWalkway = value;

// 4. Primary Member Page
// ---GETTERS
  get getP1Materials => form.value.p1Materials ?? [];
  get getP1MaterialOther => form.value.p1MaterialOther ?? "";
  get getP1Distress => form.value.p1Distress ?? "ND"; //ND = No distress
  get getP1DistressOther => form.value.p1DistressOther ?? "";
  get getP1Severity => form.value.p1Severity ?? "1";
  get getP2Materials => form.value.p2Materials ?? [];
  get getP2MaterialOther => form.value.p2MaterialOther ?? "";
  get getP2Distress => form.value.p2Distress ?? "ND";
  get getP2DistressOther => form.value.p2DistressOther ?? "";
  get getP2Severity => form.value.p2Severity ?? "1";
  get getP3Materials => form.value.p3Materials ?? [];
  get getP3MaterialOther => form.value.p3MaterialOther ?? "";
  get getP3Distress => form.value.p3Distress ?? "ND";
  get getP3DistressOther => form.value.p3DistressOther ?? "";
  get getP3Severity => form.value.p3Severity ?? "1";
  get getP4Materials => form.value.p4Materials ?? [];
  get getP4MaterialOther => form.value.p4MaterialOther ?? "";
  get getP4Distress => form.value.p4Distress ?? "ND";
  get getP4DistressOther => form.value.p4DistressOther ?? "";
  get getP4Severity => form.value.p4Severity ?? "1";
  get getP5Materials => form.value.p5Materials ?? [];
  get getP5MaterialOther => form.value.p5MaterialOther ?? "";
  get getP5Distress => form.value.p5Distress ?? "ND";
  get getP5DistressOther => form.value.p5DistressOther ?? "";
  get getP5Severity => form.value.p5Severity ?? "1";
// ---SETTERS
  set setP1Materials(List<String> value) => form.value.p1Materials = value;
  set setP1MaterialOther(String value) => form.value.p1MaterialOther = value;
  set setP1Distress(String value) => form.value.p1Distress = value;
  set setP1DistressOther(String value) => form.value.p1DistressOther = value;
  set setP1Severity(String value) => form.value.p1Severity = value;
  set setP2Materials(List<String> value) => form.value.p2Materials = value;
  set setP2MaterialOther(String value) => form.value.p2MaterialOther = value;
  set setP2Distress(String value) => form.value.p2Distress = value;
  set setP2DistressOther(String value) => form.value.p2DistressOther = value;
  set setP2Severity(String value) => form.value.p2Severity = value;
  set setP3Materials(List<String> value) => form.value.p3Materials = value;
  set setP3MaterialOther(String value) => form.value.p3MaterialOther = value;
  set setP3Distress(String value) => form.value.p3Distress = value;
  set setP3DistressOther(String value) => form.value.p3DistressOther = value;
  set setP3Severity(String value) => form.value.p3Severity = value;
  set setP4Materials(List<String> value) => form.value.p4Materials = value;
  set setP4MaterialOther(String value) => form.value.p4MaterialOther = value;
  set setP4Distress(String value) => form.value.p4Distress = value;
  set setP4DistressOther(String value) => form.value.p4DistressOther = value;
  set setP4Severity(String value) => form.value.p4Severity = value;
  set setP5Materials(List<String> value) => form.value.p5Materials = value;
  set setP5MaterialOther(String value) => form.value.p5MaterialOther = value;
  set setP5Distress(String value) => form.value.p5Distress = value;
  set setP5DistressOther(String value) => form.value.p5DistressOther = value;
  set setP5Severity(String value) => form.value.p5Severity = value;

// 5. Secondary Member Page
// ---GETTERS
  get getS1Materials => form.value.s1Materials ?? [];
  get getS1MaterialOther => form.value.s1MaterialOther ?? "";
  get getS1Distress => form.value.s1Distress ?? "ND";
  get getS1DistressOther => form.value.s1DistressOther ?? "";
  get getS1Severity => form.value.s1Severity ?? "1";
  get getS2Materials => form.value.s2Materials ?? [];
  get getS2MaterialOther => form.value.s2MaterialOther ?? "";
  get getS2Distress => form.value.s2Distress ?? "ND";
  get getS2DistressOther => form.value.s2DistressOther ?? "";
  get getS2Severity => form.value.s2Severity ?? "1";
  get getS3Materials => form.value.s3Materials ?? [];
  get getS3MaterialOther => form.value.s3MaterialOther ?? "";
  get getS3Distress => form.value.s3Distress ?? "ND";
  get getS3DistressOther => form.value.s3DistressOther ?? "";
  get getS3Severity => form.value.s3Severity ?? "1";
  get getS4Materials => form.value.s4Materials ?? [];
  get getS4MaterialOther => form.value.s4MaterialOther ?? "";
  get getS4Distress => form.value.s4Distress ?? "ND";
  get getS4DistressOther => form.value.s4DistressOther ?? "";
  get getS4Severity => form.value.s4Severity ?? "1";
  get getS5Materials => form.value.s5Materials ?? [];
  get getS5MaterialOther => form.value.s5MaterialOther ?? "";
  get getS5Distress => form.value.s5Distress ?? "ND";
  get getS5DistressOther => form.value.s5DistressOther ?? "";
  get getS5Severity => form.value.s5Severity ?? "1";
  get getS6Materials => form.value.s6Materials ?? [];
  get getS6MaterialOther => form.value.s6MaterialOther ?? "";
  get getS6Distress => form.value.s6Distress ?? "ND";
  get getS6DistressOther => form.value.s6DistressOther ?? "";
  get getS6Severity => form.value.s6Severity ?? "1";
  get getS7Materials => form.value.s7Materials ?? [];
  get getS7MaterialOther => form.value.s7MaterialOther ?? "";
  get getS7Distress => form.value.s7Distress ?? "ND";
  get getS7DistressOther => form.value.s7DistressOther ?? "";
  get getS7Severity => form.value.s7Severity ?? "1";
// ---SETTERS
  set setS1Materials(List<String> value) => form.value.s1Materials = value;
  set setS1MaterialOther(String value) => form.value.s1MaterialOther = value;
  set setS1Distress(String value) => form.value.s1Distress = value;
  set setS1DistressOther(String value) => form.value.s1DistressOther = value;
  set setS1Severity(String value) => form.value.s1Severity = value;
  set setS2Materials(List<String> value) => form.value.s2Materials = value;
  set setS2MaterialOther(String value) => form.value.s2MaterialOther = value;
  set setS2Distress(String value) => form.value.s2Distress = value;
  set setS2DistressOther(String value) => form.value.s2DistressOther = value;
  set setS2Severity(String value) => form.value.s2Severity = value;
  set setS3Materials(List<String> value) => form.value.s3Materials = value;
  set setS3MaterialOther(String value) => form.value.s3MaterialOther = value;
  set setS3Distress(String value) => form.value.s3Distress = value;
  set setS3DistressOther(String value) => form.value.s3DistressOther = value;
  set setS3Severity(String value) => form.value.s3Severity = value;
  set setS4Materials(List<String> value) => form.value.s4Materials = value;
  set setS4MaterialOther(String value) => form.value.s4MaterialOther = value;
  set setS4Distress(String value) => form.value.s4Distress = value;
  set setS4DistressOther(String value) => form.value.s4DistressOther = value;
  set setS4Severity(String value) => form.value.s4Severity = value;
  set setS5Materials(List<String> value) => form.value.s5Materials = value;
  set setS5MaterialOther(String value) => form.value.s5MaterialOther = value;
  set setS5Distress(String value) => form.value.s5Distress = value;
  set setS5DistressOther(String value) => form.value.s5DistressOther = value;
  set setS5Severity(String value) => form.value.s5Severity = value;
  set setS6Materials(List<String> value) => form.value.s6Materials = value;
  set setS6MaterialOther(String value) => form.value.s6MaterialOther = value;
  set setS6Distress(String value) => form.value.s6Distress = value;
  set setS6DistressOther(String value) => form.value.s6DistressOther = value;
  set setS6Severity(String value) => form.value.s6Severity = value;
  set setS7Materials(List<String> value) => form.value.s7Materials = value;
  set setS7MaterialOther(String value) => form.value.s7MaterialOther = value;
  set setS7Distress(String value) => form.value.s7Distress = value;
  set setS7DistressOther(String value) => form.value.s7DistressOther = value;
  set setS7Severity(String value) => form.value.s7Severity = value;
}
