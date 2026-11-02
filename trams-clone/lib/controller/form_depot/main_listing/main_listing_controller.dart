import 'package:get/get.dart';
import 'dart:async';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tram/model/form/form_depot/form_C/form_C_main_listing_model.dart';

import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/form_repository.dart';
import '../../../model/form/form_depot/main_listing/form_main_listing_model.dart';
import 'package:tram/model/form/form_depot/form_B/form_B_search_model.dart';

import 'main_listing_filter_controller.dart';

class MainListingController extends GetxController {
  String formType = Get.arguments['formType'];

  Rx<LoaderState> state = LoaderState.initial.obs;

  // --- SEPARATE, STRONGLY TYPED CONTROLLERS ---
  final PagingController<int, FormMainListingModel> pagingControllerMain =
      PagingController(firstPageKey: 0);
  final PagingController<int, FormBSearchModel> pagingControllerB =
      PagingController(firstPageKey: 0);
  final PagingController<int, FormCMainListingModel> pagingControllerC =
      PagingController(firstPageKey: 0);

  // --- Search State Variables ---
  RxString searchQuery = ''.obs;
  Worker? _searchWorker;

  // --- Filter State Variables ---
  final RxBool isFilterApplied = false.obs;

  late FormRepository repository;

  RxInt index = 0.obs;

  // --- PAGINATION VARIABLES ---
  final int _pageSize = 10;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;

  // --- SEPARATE, STRONGLY TYPED LISTS ---
  List<FormMainListingModel> _allMainItems = [];
  List<FormBSearchModel> _allBItems = [];
  List<FormCMainListingModel> _allCItems = [];

  @override
  void onInit() async {
    repository = FormRepository(formType: formType);

    _searchWorker = debounce(searchQuery, (callback) {
      if (isFilterApplied.value || searchQuery.isNotEmpty) {
        _refreshActiveController();
        load();
      }
    }, time: const Duration(milliseconds: 800));

    super.onInit();
  }

  @override
  void onClose() {
    _searchWorker?.dispose();
    pagingControllerMain.dispose();
    pagingControllerB.dispose();
    pagingControllerC.dispose();
    super.onClose();
  }

  void updateSearchQuery(String value) {
    searchQuery.value = value;
    Get.log('Search Query: $value');
  }

  String? packageID;
  String? districtID;
  String? routeID;
  String? refNo;

  Future<void> apply({
    required String packageID,
    required String districtID,
    required String routeID,
    required String refNo,
  }) async {
    state.value = LoaderState.loading;
    index.value = 0;
    this.packageID = packageID;
    this.districtID = districtID;
    this.routeID = routeID;
    this.refNo = refNo;

    isFilterApplied.value = true;
    _refreshActiveController();
    await load();
  }

  Future<void> applyFilters() async {
    isFilterApplied.value = true;
    _refreshActiveController();
    await load();
  }

  Future<void> clearFilters() async {
    isFilterApplied.value = false;
    pagingControllerMain.itemList = [];
    pagingControllerB.itemList = [];
    pagingControllerC.itemList = [];
    _allCItems.clear();
    _allMainItems.clear();
    _allBItems.clear();
  }

  Future<void> refreshList() async {
    if (isFilterApplied.value == true) {
      _refreshActiveController();
      await load();
    }
  }

  void _refreshActiveController() {
    final type = formType.toLowerCase();
    if (type == 'b') {
      pagingControllerB.refresh();
    } else if (type == 'c') {
      pagingControllerC.refresh();
    } else {
      pagingControllerMain.refresh();
    }
  }

  Future<void> load() async {
    final effectivePackageID =
        packageID ?? Get.find<MainListingFilterController>().packageID.value;

    if (!isFilterApplied.value && searchQuery.value.isEmpty) {
      state.value = LoaderState.initial;
      return;
    }

    if (effectivePackageID == null) {
      Get.snackbar("Error", "Please select a package to search");
      return;
    }

    try {
      state.value = LoaderState.loading;

      // ==========================================
      // ROUTER: DIRECT TO SPECIFIC FORM LOGIC
      // ==========================================
      final String type = formType.toLowerCase();

      if (type == 'b') {
        await _loadFormBData(effectivePackageID);
      } else if (type == 'c') {
        await _loadFormCData(effectivePackageID);
      } else {
        await _loadGeneralFormData(effectivePackageID);
      }

      state.value = LoaderState.loaded;
    } catch (e) {
      state.value = LoaderState.failure;
      final type = formType.toLowerCase();
      if (type == 'b') {
        pagingControllerB.error = e;
      } else if (type == 'c') {
        pagingControllerC.error = e;
      } else {
        pagingControllerMain.error = e;
      }
    }
  }

  // ==========================================
  // 1. DEDICATED FORM B LOGIC
  // ==========================================
  Future<void> _loadFormBData(String effectivePackageID) async {
    final res = await repository.searchFormB(
      packageID: effectivePackageID,
      division: districtID,
      roadID: routeID,
      searchBox: "",
    );
    List<FormBSearchModel> allData = res.data;

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      allData = allData.where((item) {
        return item.roadName.toLowerCase().contains(query) ||
            item.district.toLowerCase().contains(query) ||
            item.bridgeName?.toLowerCase().contains(query) == true ||
            item.package.toLowerCase().contains(query);
      }).toList();
    }

    if (refNo != null && refNo!.isNotEmpty) {
      allData.retainWhere(
          (item) => item.parentID.toLowerCase() == refNo!.toLowerCase());
    }

    final uniqueByRef = <String, FormBSearchModel>{};
    for (var item in allData) {
      final key = item.parentID.toLowerCase();
      if (!uniqueByRef.containsKey(key)) uniqueByRef[key] = item;
    }

    _allBItems = uniqueByRef.values.toList();
    pagingControllerB.itemList = [];
    pagingControllerB.appendLastPage(_allBItems);
  }

  // ==========================================
  // 2. DEDICATED FORM C LOGIC
  // ==========================================
  Future<void> _loadFormCData(String effectivePackageID) async {
    List<FormCMainListingModel> allData = [];

    if (searchQuery.value.isNotEmpty) {
      final res = await repository.searchFormC(
        packageID: effectivePackageID,
        searchBox: searchQuery.value,
      );

      // --- MANUAL ASSIGNMENT HERE ---
      // Mapping each FormCSearchModel into a FormCMainListingModel
      allData = res.data.map<FormCMainListingModel>((searchItem) {
        return FormCMainListingModel.fromJson({
          "recID": searchItem.recID.toString(),
          "inspection_date": searchItem.inspectionDate,
          "reference_no": searchItem.referenceNo,
          // Add any other specific Form C fields your UI needs below:
          // "project_name": searchItem.projectName ?? "",
          // "road_name": searchItem.roadName ?? "",
        });
      }).toList();
    } else {
      final res = await repository.showFormCMainListing(
        packageID: effectivePackageID,
        districtID: districtID!,
        routeID: routeID!,
      );
      allData = res.data;
    }

    if (refNo != null && refNo!.isNotEmpty) {
      allData.retainWhere(
          (item) => item.referenceNo.toLowerCase() == refNo!.toLowerCase());
    }

    // Collapse repeated rows (e.g. one per past inspection date) down to one
    // representative entry per structure. Prefer the structure's own
    // database ID for this: it's always assigned by the backend, unlike
    // referenceNo, which can legitimately be left unset ("-") on more than
    // one road at once - deduping on referenceNo alone was collapsing every
    // such road into a single entry and hiding the rest of them. recID is
    // this list's equivalent of what Form B already keys its own dedup on
    // (parentID): a real identity rather than a business-assigned label.
    final uniqueByStructure = <String, FormCMainListingModel>{};
    for (var item in allData) {
      final hasRecID = item.recID.isNotEmpty && item.recID != '-';
      final key = hasRecID
          ? 'id:${item.recID.toLowerCase()}'
          : 'ref:${item.referenceNo.toLowerCase()}';
      uniqueByStructure.putIfAbsent(key, () => item);
    }

    _allCItems = uniqueByStructure.values.toList();
    totalPages.value = _allCItems.isEmpty
        ? 1
        : (_allCItems.length + _pageSize - 1) ~/ _pageSize;
    jumpToPage(1);
  }

  // ==========================================
  // 3. DEDICATED GENERAL FORM LOGIC (A, R, G, etc.)
  // ==========================================
  Future<void> _loadGeneralFormData(String effectivePackageID) async {
    List<FormMainListingModel> allData = [];

    if (searchQuery.value.isNotEmpty) {
      final res = await repository.searchForm(
        packageID: effectivePackageID,
        searchBox: searchQuery.value,
      );
      allData = res.data;
    } else {
      final res = await repository.showFormMainListing(
        packageID: packageID!,
        districtID: districtID!,
        routeID: routeID!,
      );
      allData = res.data;
    }

    if (refNo != null && refNo!.isNotEmpty) {
      allData.retainWhere(
          (item) => item.referenceNo.toLowerCase() == refNo!.toLowerCase());
    }

    allData.sort((a, b) {
      final dateA = parseDMY(a.inspectionDate);
      final dateB = parseDMY(b.inspectionDate);
      final dateComparison = dateB.compareTo(dateA);
      if (dateComparison != 0) return dateComparison;
      final idA = int.tryParse(a.recID) ?? 0;
      final idB = int.tryParse(b.recID) ?? 0;
      return idB.compareTo(idA);
    });

    final uniqueByRef = <String, FormMainListingModel>{};
    for (var item in allData) {
      final key = item.referenceNo.toLowerCase();
      if (!uniqueByRef.containsKey(key)) uniqueByRef[key] = item;
    }

    _allMainItems = uniqueByRef.values.toList();

    // Standard append for general forms
    pagingControllerMain.itemList = [];
    pagingControllerMain.appendLastPage(_allMainItems);
  }

  // ==========================================
  // HELPERS
  // ==========================================
  void jumpToPage(int page) {
    if (formType.toLowerCase() != 'c') return;

    currentPage.value = page;

    int startIndex = (page - 1) * _pageSize;
    int endIndex = startIndex + _pageSize;

    if (endIndex > _allCItems.length) {
      endIndex = _allCItems.length;
    }

    if (startIndex < _allCItems.length) {
      final pageItems = _allCItems.sublist(startIndex, endIndex);

      // We MUST feed pagingControllerC here so the UI knows data has loaded
      pagingControllerC.value = PagingState(
        itemList: pageItems,
        nextPageKey: null,
      );
    } else {
      pagingControllerC.value = const PagingState(
        itemList: [],
        nextPageKey: null,
      );
    }
  }

  void reset() {
    state.value = LoaderState.initial;
    packageID = null;
    districtID = null;
    routeID = null;
    isFilterApplied.value = false;

    pagingControllerMain.itemList = [];
    pagingControllerB.itemList = [];
    pagingControllerC.itemList = [];
    pagingControllerC.refresh();
    pagingControllerMain.refresh();
    pagingControllerB.refresh();
  }

  DateTime parseDMY(String? date) {
    final value = date?.trim() ?? '';
    if (value.isEmpty) return DateTime(1900);

    final dateOnly = value.split(RegExp(r'[ T]')).first;
    final separator = dateOnly.contains('/') ? '/' : '-';
    final parts = dateOnly.split(separator);
    if (parts.length != 3) return DateTime(1900);

    final isYearFirst = parts[0].length == 4;
    final day = int.tryParse(isYearFirst ? parts[2] : parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(isYearFirst ? parts[0] : parts[2]);

    if (day == null || month == null || year == null) return DateTime(1900);
    return DateTime(year, month, day);
  }
}
