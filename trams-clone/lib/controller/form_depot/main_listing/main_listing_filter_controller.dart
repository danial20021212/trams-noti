import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/controller/form_depot/main_listing/main_listing_controller.dart';
import 'package:tram/controller/home/root_home_controller.dart';
import 'package:tram/model/shared/dropdown_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/pavement_repository.dart';

class MainListingFilterController extends GetxController {
  final repository = PavementRepository();
  final mainListingController = Get.find<MainListingController>();
  final auth = Get.find<AuthController>();

  Rx<LoaderState> state = LoaderState.initial.obs;
  RxList<DropdownModel> packageDropdown = RxList();
  RxList<DropdownModel> divisionDropdown = RxList();
  RxList<DropdownModel> districtDropdown = RxList();
  RxList<DropdownModel> routeDropdown = RxList();

  RxnString packageID = RxnString();
  RxnString districtID = RxnString();
  RxnString routeID = RxnString();

  RxnString roadCode = RxnString();
  RxnString roadName = RxnString();

  final Map<String, List<DropdownModel>> _formCDistrictsByDivision = {};
  final Map<String, String> _formCRouteDistrictIDs = {};

  bool get usesDivisionFilter =>
      {"b", "c"}.contains(mainListingController.formType.toLowerCase());

  bool get isFormC => mainListingController.formType.toLowerCase() == "c";

  @override
  void onInit() {
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

    initialLoad(initial: true);
  }

  void selectPackage(String v) async {
    packageID.value = v;
    districtID.value = null; // Clear lower selections
    routeID.value = null;
    _formCDistrictsByDivision.clear();
    _formCRouteDistrictIDs.clear();

    // Conditionally load the next dropdown & route based on Form Type
    if (usesDivisionFilter) {
      await loadDivision(initial: false);
      await loadRoute2(initial: false);
    } else {
      await loadDistrict(initial: false);
      await loadRoute(initial: false);
    }
  }

  void selectDistrict(String v) async {
    districtID.value = v;
    routeID.value = null;

    // Conditionally load the route based on Form Type
    if (usesDivisionFilter) {
      await loadRoute2(initial: false);
    } else {
      await loadRoute(initial: false);
    }
  }

  void selectRoute(String v) async {
    routeID.value = v;

    final selectedRoute = routeDropdown.firstWhere(
      (route) => route.id == v,
      orElse: () => const DropdownModel('', ''), // fallback
    );

    // Check if the string follows the expected "Code - Name" format
    if (selectedRoute.value.isNotEmpty && selectedRoute.value.contains(' - ')) {
      final parts = selectedRoute.value.split(' - ');

      // 1. Assign Road Code (The part BEFORE the first hyphen)
      roadCode.value = parts[0].trim();

      // 2. Assign Road Name (The part AFTER the first hyphen)
      roadName.value = parts.sublist(1).join(' - ').trim();
    } else {
      // Optional: Clear values if format is invalid or selection is empty
      roadCode.value = null;
      roadName.value = null;
    }
  }

  Future<void> initialLoad({bool initial = true}) async {
    await loadPackage(initial: initial);

    // Conditionally load the next dropdown & route based on Form Type
    if (usesDivisionFilter) {
      await loadDivision(initial: initial);
      await loadRoute2(initial: initial);
    } else {
      await loadDistrict(initial: initial);
      await loadRoute(initial: initial);
    }

    if (initial) {
      mainListingController.index.value = 1;
    }
    if (!initial) {
      applyFilter();
    }
  }

  loadPackage({initial = true}) async {
    try {
      state.value = LoaderState.loading;
      final data = await repository.showFilterPackage();

      if (auth.getUserPackage()?.isEmpty ?? true) {
        packageDropdown.assignAll(data.tblPackage
            .map((e) => DropdownModel(e.packageId, e.packageName))
            .toList());
      } else {
        final String userPkg = auth.getUserPackage()!.trim();
        packageDropdown.assignAll(data.tblPackage
            .where((e) => e.packageId.trim() == userPkg)
            .map((e) => DropdownModel(e.packageId, e.packageName))
            .toList());
      }

      state.value = LoaderState.loaded;
    } catch (err) {
      print(
          "Error loading packages: $err"); // Good to print the error for debugging
      state.value = LoaderState.failure;
    }
  }

  loadDivision({initial = true}) async {
    if (packageID.value == null || packageID.value!.isEmpty) return;
    try {
      state.value = LoaderState.loading;
      divisionDropdown.clear();
      final data = await repository.showFilterDivision(packageID.value!);

      divisionDropdown.addAll(data.tblDivision
          .map((e) => DropdownModel(e.divisionName, e.divisionName))
          .toList());
      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  loadDistrict({initial = true}) async {
    if (packageID.value == null || packageID.value!.isEmpty) return;
    try {
      state.value = LoaderState.loading;
      districtDropdown.clear();
      final data = await repository.showFilterDistrict(packageID.value!);

      districtDropdown.addAll(data.tblDistrict
          .map((e) => DropdownModel(e.districtId, e.districtName))
          .toList());
      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  loadRoute({initial = true}) async {
    if (packageID.value == null || packageID.value!.isEmpty) return;
    if (districtID.value == null || districtID.value!.isEmpty) return;
    try {
      state.value = LoaderState.loading;
      routeDropdown.clear();

      // The API naturally accepts either a district ID or a Division Name here
      final data =
          await repository.showFilterRoute(packageID.value!, districtID.value!);

      routeDropdown.addAll(data.tblRoute
          .map((e) => DropdownModel(e.routeId, "${e.routeNo} - ${e.routeName}"))
          .toList());
      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  loadRoute2({initial = true}) async {
    if (packageID.value == null || packageID.value!.isEmpty) return;
    if (districtID.value == null || districtID.value!.isEmpty) return;
    try {
      state.value = LoaderState.loading;
      routeDropdown.clear();

      // The API naturally accepts either a district ID or a Division Name here
      final data = await repository.showFilterRoute2(
          packageID.value!, districtID.value!);

      routeDropdown.addAll(data.tblRoute
          .map((e) => DropdownModel(e.routeId, "${e.routeNo} - ${e.routeName}"))
          .toList());
      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  Future<void> applyFilter() async {
    if (packageID.value == null || packageID.value!.isEmpty) {
      mainListingController.index.value = 1;
      return SmartDialog.showToast("Please Select the Package");
    }
    if (districtID.value == null || districtID.value!.isEmpty) {
      mainListingController.index.value = 1;
      return SmartDialog.showToast("Please Select the Division");
    }
    if (routeID.value == null || routeID.value!.isEmpty) {
      mainListingController.index.value = 1;
      return SmartDialog.showToast("Please Select the Route");
    }

    state.value = LoaderState.loading;

    try {
      String listingDistrictID = districtID.value!;
      if (isFormC) {
        final resolvedDistrictID = await _resolveFormCDistrictID();
        if (resolvedDistrictID == null || resolvedDistrictID.isEmpty) {
          mainListingController.index.value = 1;
          state.value = LoaderState.loaded;
          return SmartDialog.showToast(
            "Unable to find the district ID for the selected Road",
          );
        }

        listingDistrictID = resolvedDistrictID;
        debugPrint(
          'Form C filter: Division ${districtID.value} resolved to districtId $listingDistrictID',
        );
      }

      await mainListingController.apply(
        packageID: packageID.value!,
        districtID: listingDistrictID,
        routeID: (routeID.value == null ||
                routeID.value!.isEmpty ||
                routeID.value == "-")
            ? ""
            : routeID.value!,
        refNo: "",
      );

      state.value = LoaderState.loaded;
    } catch (err) {
      print(err);
      SmartDialog.showToast("Error while load data");
      state.value = LoaderState.failure;
    }
  }

  clearAll() {
    packageID.value = null;
    districtID.value = null;
    routeID.value = null;

    divisionDropdown.clear();
    districtDropdown.clear();
    routeDropdown.clear();
    _formCDistrictsByDivision.clear();
    _formCRouteDistrictIDs.clear();

    mainListingController.reset();
  }

  Future<String?> _resolveFormCDistrictID() async {
    final cachedDistrictID = _formCRouteDistrictIDs[routeID.value];
    if (cachedDistrictID != null && cachedDistrictID.isNotEmpty) {
      return cachedDistrictID;
    }

    if (_formCDistrictsByDivision.isEmpty) {
      await _loadFormCDistrictLookup();
    }

    final divisionKey = districtID.value!.trim().toLowerCase();
    final candidates = List<DropdownModel>.from(
      _formCDistrictsByDivision[divisionKey] ?? const <DropdownModel>[],
    );

    if (candidates.isEmpty) {
      final exactDistrict = districtDropdown.firstWhere(
        (district) => district.value.trim().toLowerCase() == divisionKey,
        orElse: () => const DropdownModel('', ''),
      );
      return exactDistrict.id.isEmpty ? null : exactDistrict.id;
    }

    // The district sharing the Division name is the most common match, so
    // check it first and avoid unnecessary API requests where possible.
    candidates.sort((a, b) {
      final aExact = a.value.trim().toLowerCase() == divisionKey ? 0 : 1;
      final bExact = b.value.trim().toLowerCase() == divisionKey ? 0 : 1;
      return aExact.compareTo(bExact);
    });

    for (final district in candidates) {
      try {
        final routes =
            await repository.showFilterRoute(packageID.value!, district.id);
        for (final route in routes.tblRoute) {
          _formCRouteDistrictIDs[route.routeId] = district.id;
        }
        final containsSelectedRoute =
            routes.tblRoute.any((route) => route.routeId == routeID.value);
        if (containsSelectedRoute) return district.id;
      } catch (err) {
        debugPrint(
          'Unable to check routes for district ${district.id}: $err',
        );
      }
    }

    return null;
  }

  Future<void> _loadFormCDistrictLookup() async {
    final data = await repository.showFilterDistrict(packageID.value!);

    districtDropdown.assignAll(data.tblDistrict
        .map((district) =>
            DropdownModel(district.districtId, district.districtName))
        .toList());

    _formCDistrictsByDivision.clear();
    for (final district in data.tblDistrict) {
      final divisionKey = district.division.trim().toLowerCase();
      if (divisionKey.isEmpty || district.districtId.isEmpty) continue;

      _formCDistrictsByDivision
          .putIfAbsent(divisionKey, () => <DropdownModel>[])
          .add(DropdownModel(district.districtId, district.districtName));
    }
  }
}
