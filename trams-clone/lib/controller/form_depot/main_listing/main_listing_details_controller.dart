import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tram/constant/url.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/form_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/form/form_depot/form_C/form_C_main_listing_model.dart';
import '../../../model/form/form_depot/form_draft/form_draft_model.dart';
import '../../../model/form/form_depot/main_listing/form_main_listing_model.dart';
import '../form_draft_controller.dart';
import 'main_listing_controller.dart';

class MainListingDetailsController extends GetxController {
  String recID = '';
  String formType = '';
  String formTitle = '';
  String packageID = '';
  String districtID = '';
  String routeID = '';
  String parentID = '';
  bool isMainListing = false;
  String bridgeName = '';
  String packageName = '';
  String districtName = '';
  String roadName = '';
  String previousRecID = "";
  String referenceNo = "";

  // --- Pagination Settings ---
  static const int _pageSize = 5;
  List<FormMainListingModel> _allFilteredRecords = [];

  // Track current page for UI highlighting
  RxInt currentPage = 1.obs;

  // Calculate total pages based on record count
  int get totalPages => (_allFilteredRecords.length / _pageSize).ceil();

  Rx<LoaderState> state = LoaderState.initial.obs;
  FormRepository repository = FormRepository(formType: '');
  Rx<dynamic> formDetails = Rxn();
  Rx<dynamic> formTitleMap = Rxn();

  MainListingController? get mainListingController =>
      Get.isRegistered<MainListingController>()
          ? Get.find<MainListingController>()
          : null;

  RxList<FormMainListingModel> currentDisplayList =
      <FormMainListingModel>[].obs;

  RxMap<String, dynamic> argumentsEditForm1 = RxMap<String, dynamic>();
  RxMap<String, dynamic> argumentsEditForm2 = RxMap<String, dynamic>();

  RxList<FormDraft> localDrafts = <FormDraft>[].obs;

  RxString status = "".obs;

  FormCMainListingModel? selectedFormCModel;

  @override
  void onInit() async {
    super.onInit();

    state.listen((v) {
      switch (v) {
        case LoaderState.initial:
        case LoaderState.loading:
          SmartDialog.showLoading(clickMaskDismiss: false);
          break;
        case LoaderState.loaded:
        case LoaderState.failure:
          SmartDialog.dismiss();
          break;
      }
    });

    recID = Get.arguments['recID'] ?? "";
    formType = Get.arguments['formType'] ?? "Unknown";
    formTitle = Get.arguments['formTitle'] ?? 'Unknown';
    packageID = Get.arguments['packageID'] ?? "";
    districtID = Get.arguments['districtID'] ?? "";
    routeID = Get.arguments['routeID'] ?? "";
    parentID = Get.arguments['parentID'] ?? "";
    isMainListing = Get.arguments['isMainListing'] ?? false;
    bridgeName = Get.arguments['bridgeName'] ?? "";
    packageName = Get.arguments['packageName'] ?? "";
    districtName = Get.arguments['districtName'] ?? "";
    roadName = Get.arguments['roadName'] ?? "";
    referenceNo = Get.arguments['refNo'] ?? "";

    selectedFormCModel = Get.arguments['selectedModel'];

    repository = FormRepository(formType: formType);

    await load();
  }

  Future<void> load() async {
    try {
      state.value = LoaderState.loading;
      currentDisplayList.value = [];
      localDrafts.clear(); // Clear existing drafts on reload

      final String type = formType.toLowerCase();

      // ==========================================
      // ROUTER: DIRECT TO SPECIFIC FORM LOGIC
      // ==========================================
      if (type == 'b') {
        await _loadFormBData();
      } else if (type == 'c') {
        await _loadFormCData();
      } else {
        await _loadGeneralFormData();
      }

      state.value = LoaderState.loaded;
    } catch (err) {
      Get.log("Load Exception: ${err.toString()}");
      state.value = LoaderState.failure;
    }
  }

  Future<void> refreshAfterEditorResult(Object? result) async {
    if (result == true) {
      await load();
    }
  }

  Future<bool> refreshUntilInspectionVisible(
    String inspectionID, {
    int attempts = 5,
  }) async {
    final targetID = inspectionID.trim();
    if (targetID.isEmpty) return false;

    for (var attempt = 0; attempt < attempts; attempt++) {
      await load();
      final isVisible = _allFilteredRecords.any((record) {
        final recordID = formType.toLowerCase() == 'c'
            ? record.insRecID?.toString().trim() ?? ''
            : record.recID.toString().trim();
        return recordID == targetID;
      });
      if (isVisible) return true;
      if (attempt < attempts - 1) {
        await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
      }
    }
    return false;
  }

  // ==========================================
  // 1. DEDICATED FORM B LOGIC
  // ==========================================
  Future<void> _loadFormBData() async {
    if (parentID.isEmpty) {
      Get.log("Error: parentID is empty for Form B");
      throw Exception("Missing parentID");
    }

    debugPrint('=== _loadFormBData ===');
    debugPrint('parentID: $parentID');
    debugPrint(
        'nav - packageID: $packageID, districtID: $districtID, routeID: $routeID, bridgeName: $bridgeName');
    debugPrint(
        'nav - packageName: $packageName, districtName: $districtName, roadName: $roadName');

    final bResponse =
        await repository.showFormBMainListing2(parentID: parentID);

    debugPrint('bResponse.data.length: ${bResponse.data.length}');

    String headerPackage = packageName.isNotEmpty ? packageName : packageID;
    String headerDistrict = districtName.isNotEmpty ? districtName : districtID;
    String headerRoad = roadName.isNotEmpty ? roadName : routeID;
    String headerBridge = bridgeName;
    String headerRefNo = referenceNo;

    if (bResponse.data.isNotEmpty) {
      final firstItem = bResponse.data.first;
      if (firstItem.package.isNotEmpty) headerPackage = firstItem.package;
      if (firstItem.district.isNotEmpty) headerDistrict = firstItem.district;
      if (firstItem.roadName.isNotEmpty) headerRoad = firstItem.roadName;
      if (firstItem.bridgeName.isNotEmpty) headerBridge = firstItem.bridgeName;
      if (firstItem.referenceNo.isNotEmpty) headerRefNo = firstItem.referenceNo;
    }

    formTitleMap.value = [
      {"Package": headerPackage},
      {"District": headerDistrict},
      {"Road Name": headerRoad},
      {"Bridge Name": headerBridge},
      if (headerRefNo.isNotEmpty) {"Reference No.": headerRefNo},
    ];
    debugPrint(
        'header - package: $headerPackage, district: $headerDistrict, roadName: $headerRoad, bridgeName: $headerBridge, refNo: $headerRefNo');

    if (bResponse.data.isNotEmpty) {
      status.value = "";

      List<FormMainListingModel> allData =
          bResponse.data.map<FormMainListingModel>((e) {
        return FormMainListingModel.fromJson({
          "recID": e.recID.toString(),
          "inspection_date": e.inspectionDate,
          "reference_no": e.referenceNo,
        });
      }).toList();

      allData.retainWhere((item) => item.inspectionDate.isNotEmpty);
      sortInspectionRecordsNewestFirst(allData);

      if (allData.isNotEmpty) {
        previousRecID = allData.first.recID;
        referenceNo = allData.first.referenceNo;
        Get.log("Latest Form B inspection: $previousRecID ($referenceNo)");
      } else {
        previousRecID = '';
      }

      _allFilteredRecords = allData;
      jumpToPage(1);
    } else {
      _allFilteredRecords = [];
    }

    // A bridge can have no submitted inspections (and therefore no reference
    // number yet). Drafts still belong to it through the stable parent ID.
    await fetchMatchingDrafts(headerRefNo, parentID: parentID);
  }

  // ==========================================
  // 2. DEDICATED FORM C LOGIC
  // ==========================================
  Future<void> _loadFormCData() async {
    debugPrint('=== _loadFormCData ===');
    debugPrint('recID: $recID');
    debugPrint('parentID: $parentID');
    debugPrint('selectedFormCModel?.recID: ${selectedFormCModel?.recID}');
    debugPrint(
        'selectedFormCModel?.referenceNo: ${selectedFormCModel?.referenceNo}');
    debugPrint('URL: ${UrlStorage.formCMainListingDetails}');

    if (recID.isEmpty) {
      Get.log("Error: recID is empty for Form C");
      throw Exception("Missing recID");
    }

    final detailsResponse =
        await repository.showFormCMainListingDetails(recID: recID);
    final selectedReferenceNo = selectedFormCModel?.referenceNo ?? "";
    final selectedRecords = detailsResponse.recordsForSelection(
      parentRecID: recID,
      referenceNo: selectedReferenceNo,
    );
    debugPrint('detailsResponse data count: ${detailsResponse.data.length}');
    debugPrint('selected record count: ${selectedRecords.length}');
    if (selectedRecords.isNotEmpty) {
      debugPrint('first item insRecID: ${selectedRecords.first.insRecID}');
      debugPrint(
          'first item referenceNo: ${selectedRecords.first.referenceNo}');
    }
    formDetails.value = detailsResponse.copyWith(data: selectedRecords);

    // Use the details API response for header fields (confirmed to have correct data)
    String currentRefNo = "";
    if (selectedRecords.isNotEmpty) {
      final firstItem = selectedRecords.first;
      currentRefNo =
          selectedReferenceNo.isNotEmpty && selectedReferenceNo != "-"
              ? selectedReferenceNo
              : firstItem.referenceNo ?? "";
      status.value = firstItem.status ?? "";

      formTitleMap.value = [
        {
          "Package": firstItem.projectName?.isNotEmpty == true
              ? firstItem.projectName!
              : packageID
        },
        {
          "District": firstItem.district?.isNotEmpty == true
              ? firstItem.district!
              : districtID
        },
        {
          "Road Name": firstItem.roadName?.isNotEmpty == true
              ? firstItem.roadName!
              : routeID
        },
        {"Reference No.": currentRefNo},
      ];
    } else if (selectedFormCModel != null) {
      currentRefNo = selectedFormCModel!.referenceNo;
      formTitleMap.value = [
        {
          "Package": selectedFormCModel!.projectName != "-"
              ? selectedFormCModel!.projectName
              : packageID
        },
        {
          "District": selectedFormCModel!.district != "-"
              ? selectedFormCModel!.district
              : districtID
        },
        {
          "Road Name": selectedFormCModel!.roadName != "-"
              ? selectedFormCModel!.roadName
              : routeID
        },
        {"Reference No.": currentRefNo},
      ];
    }

    // Populate the Header Card
    //await loadTitle();

    await fetchMatchingDrafts(currentRefNo, parentID: recID);

    List<FormMainListingModel> allData =
        selectedRecords.map<FormMainListingModel>((e) {
      return FormMainListingModel.fromJson({
        "recID": recID, //PARENT ID
        "insRecID": e.insRecID?.toString() ?? "", // SUB ID
        "inspection_date": e.inspectionDate ?? "",
        "reference_no": e.referenceNo ?? "",
        "status": e.status ?? "",
      });
    }).toList();

    allData.retainWhere((item) => item.inspectionDate.isNotEmpty);

    sortInspectionRecordsNewestFirst(
      allData,
      useChildInspectionID: true,
    );

    if (allData.isNotEmpty) {
      // Prefill Add New Inspection from the latest record actually displayed,
      // using its child inspection ID rather than the parent Form C ID.
      previousRecID = allData.first.insRecID ?? '';
      referenceNo = allData.first.referenceNo;
    } else {
      previousRecID = '';
    }

    _allFilteredRecords = allData;
    jumpToPage(1);
  }

  // ==========================================
  // 3. DEDICATED GENERAL FORM LOGIC
  // ==========================================
  Future<void> _loadGeneralFormData() async {
    if (recID.isEmpty) {
      Get.log("Error: recID is empty for Form $formType");
      throw Exception("Missing recID");
    }

    final detailsResponse =
        await repository.showFormMainListingDetails(recID: recID);

    formDetails.value = detailsResponse;
    await loadTitle();

    if (detailsResponse.data.isNotEmpty) {
      status.value = detailsResponse.data.first.status ?? "";
    }
    final currentRefNo = detailsResponse.data.isEmpty
        ? ''
        : detailsResponse.data.first.referenceNo ?? '';

    await fetchMatchingDrafts(currentRefNo, parentID: recID);

    final listResponse = await repository.showFormMainListing(
      packageID: packageID,
      districtID: districtID,
      routeID: routeID,
    );

    final allData = listResponse.data;

    allData.retainWhere(
        (item) => item.referenceNo.toLowerCase() == currentRefNo.toLowerCase());

    allData.retainWhere((item) => item.inspectionDate.isNotEmpty);

    allData.sort((a, b) {
      final dateA = parseDate(a.inspectionDate);
      final dateB = parseDate(b.inspectionDate);

      int dateComparison = dateB.compareTo(dateA);
      if (dateComparison != 0) {
        return dateComparison;
      }

      int idA = int.tryParse(a.recID.toString()) ?? 0;
      int idB = int.tryParse(b.recID.toString()) ?? 0;

      return idB.compareTo(idA);
    });

    previousRecID = allData.isEmpty ? '' : allData.first.recID;

    _allFilteredRecords = allData;
    jumpToPage(1);
  }

  // ==========================================
  // HELPERS
  // ==========================================
  Future<void> fetchMatchingDrafts(String refNo, {String? parentID}) async {
    try {
      if (!Get.isRegistered<FormDraftController>()) {
        Get.lazyPut(() => FormDraftController());
      }
      final draftCtrl = Get.find<FormDraftController>();

      await draftCtrl.fetchAllDrafts();

      List<FormDraft> matchingDrafts = [];

      for (var draft in draftCtrl.drafts) {
        String parsedFormType = draft.formType.replaceAll("Form ", "").trim();
        if (parsedFormType.toLowerCase() == formType.toLowerCase()) {
          try {
            final Map<String, dynamic> jsonData = jsonDecode(draft.formData);
            final String draftRefNo = jsonData['referenceNo']?.toString() ?? "";
            final draftOwnerValue = jsonData['parentID'] ??
                jsonData['parentId'] ??
                jsonData['recID'];
            final String draftParentID =
                draftOwnerValue?.toString().trim() ?? "";
            final normalizedParentID = parentID?.trim() ?? "";

            final matchesParent = normalizedParentID.isNotEmpty &&
                draftParentID == normalizedParentID;
            final matchesLegacyReference = refNo.isNotEmpty &&
                draftParentID.isEmpty &&
                draftRefNo.toLowerCase() == refNo.toLowerCase();

            if (matchesParent || matchesLegacyReference) {
              matchingDrafts.add(draft);
            }
          } catch (e) {
            Get.log("Failed to parse draft JSON for comparison: $e");
          }
        }
      }
      localDrafts.value = matchingDrafts;
    } catch (e) {
      Get.log("Error fetching matching drafts: $e");
    }
  }

  void jumpToPage(int page) {
    currentPage.value = page;

    int startIndex = (page - 1) * _pageSize;
    int endIndex = startIndex + _pageSize;

    if (startIndex >= _allFilteredRecords.length) {
      currentDisplayList.value = [];
      return;
    }

    List<FormMainListingModel> pageItems = _allFilteredRecords.sublist(
      startIndex,
      endIndex > _allFilteredRecords.length
          ? _allFilteredRecords.length
          : endIndex,
    );

    currentDisplayList.value = pageItems;
  }

  Future<void> loadTitle() async {
    final details = formDetails.value;
    if (details == null || details.data.isEmpty) {
      formTitleMap.value = [];
      return;
    }
    final firstItem = details.data.first;

    // We safely check if the model has a getKeyValuePairs method
    try {
      if (isMainListing) {
        formTitleMap.value = firstItem.getKeyValuePairsInGeneral();
      } else {
        formTitleMap.value = firstItem.getKeyValuePairs();
      }
    } catch (e) {
      formTitleMap.value = [
        {"title": "Unknown Form Data", "value": "N/A"}
      ];
    }
  }

  Future<void> downloadPDF() async {
    try {
      state.value = LoaderState.loading;
      final res = await repository.getPDFForm(formID: recID);
      _launchUrl(Uri.parse(res.data['url']));
      state.value = LoaderState.loaded;
    } catch (e) {
      Get.snackbar("Download PDF Error", e.toString());
      Get.log(e.toString());
      state.value = LoaderState.failure;
    }
  }

  Future<bool> _launchUrl(Uri url) async {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
    return true;
  }

  DateTime parseDate(String? dateString) {
    final value = dateString?.trim() ?? '';
    if (value.isEmpty) {
      return DateTime(1900);
    }

    final isoDate = DateTime.tryParse(value);
    if (isoDate != null) return isoDate;

    final dateOnly = value.split(RegExp(r'[ T]')).first;
    for (final format in const [
      'dd-MM-yyyy',
      'dd/MM/yyyy',
      'yyyy/MM/dd',
      'MM/dd/yyyy',
    ]) {
      try {
        return DateFormat(format).parseStrict(dateOnly);
      } on FormatException {
        // Try the next known API/display format.
      }
    }

    Get.log("Date parsing error for: $dateString");
    return DateTime(1900);
  }

  void sortInspectionRecordsNewestFirst(
    List<FormMainListingModel> records, {
    bool useChildInspectionID = false,
  }) {
    records.sort((a, b) {
      final dateComparison =
          parseDate(b.inspectionDate).compareTo(parseDate(a.inspectionDate));
      if (dateComparison != 0) return dateComparison;

      final idA = useChildInspectionID ? a.insRecID ?? '' : a.recID;
      final idB = useChildInspectionID ? b.insRecID ?? '' : b.recID;
      final numericIDA = int.tryParse(idA);
      final numericIDB = int.tryParse(idB);
      if (numericIDA != null && numericIDB != null) {
        return numericIDB.compareTo(numericIDA);
      }
      return idB.compareTo(idA);
    });
  }

  set setPreviousRecID(String recID) => previousRecID = recID;
  String get getPreviousRecID => previousRecID;
}
