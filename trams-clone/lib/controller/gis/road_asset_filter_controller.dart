import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tram/controller/gis/pavement_map_controller.dart';
import 'package:tram/controller/gis/road_asset_controller.dart';
import 'package:tram/controller/home/root_home_controller.dart';
import 'package:tram/model/basic/gis/filter_inventory_model.dart';
import 'package:tram/model/shared/dropdown_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/pavement_repository.dart';

import '../auth/auth_controller.dart';

class RoadAssetFilterController extends GetxController {
  final repository = PavementRepository();
  final homeController = Get.find<RootHomeController>();
  final roadAssetController = Get.find<RoadAssetController>();
  final auth = Get.find<AuthController>();
  RxList<DropdownModel> packageDropdown = RxList();
  RxList<DropdownModel> districtDropdown = RxList();
  RxList<DropdownModel> routeDropdown = RxList();
  RxList<DropdownModel> inventoryDropdown = RxList();
  //optional
  RxList<DropdownModel> categoryDropdown = RxList();
  RxList<DropdownModel> typeDropdown = RxList();

  Rx<LoaderState> state = LoaderState.initial.obs;

  RxnString package = RxnString();
  RxnString district = RxnString();
  RxnString route = RxnString();
  RxnString inventory = RxnString();
  RxnString category = RxnString();
  RxnString type = RxnString();

  Map<String, String> inventories = {};

  RoadAssetType roadAssetType = RoadAssetType.none;
  RxBool showBridgeOptions = false.obs;

  @override
  void onInit() {
    loadArguments();
    super.onInit();
  }

  manualArguments(Map<String, dynamic> args) async {
    loadArguments(args: args);
  }

  loadArguments({Map<String, dynamic>? args}) {
    if (args == null) return initialLoad();
    package.value = args["pkg"];
    district.value = args["district"];
    route.value = args["route"];

    if (package.value == null ||
        district.value == null ||
        route.value == null) {
      initialLoad(initial: true);
    } else {
      initialLoad(initial: false);
    }
  }

  selectPackage(String v) async {
    package.value = v;
    district.value = null;
    route.value = null;
    await loadDistrict();
    await loadRoute();
  }

  selectDistrict(String v) async {
    district.value = v;
    route.value = null;
    await loadRoute();
  }

  selectRoute(String v) async {
    route.value = v;
  }

  selectItem(String v) async {
    inventory.value = v;
    if (inventories.containsKey(v) && inventories[v] == "Bridge") {
      showBridgeOptions.value = true;
      loadBridgeCategory();
    } else {
      category.value = "-";
      type.value = "-";

      showBridgeOptions.value = false;
    }
    if (inventories.containsKey(v)) {
      roadAssetType = convertToRoadAssetType(inventories[v]!);
    } else {
      roadAssetType = convertToRoadAssetType("");
    }
  }

  selectCategory(String v) {
    category.value = v;
    if (category.value != "-") {
      loadBridgeType();
    } else {
      loadBridgeType(empty: true);
    }
  }

  selectType(String v) {
    type.value = v;
  }

  RoadAssetType convertToRoadAssetType(String v) {
    switch (v) {
      case "Bridge":
        return RoadAssetType.bridge;
      case "Culvert":
        return RoadAssetType.culvert;
      case "Kilometer Post":
        return RoadAssetType.kilometer;
      case "Signboard":
        return RoadAssetType.signboard;
      default:
        return RoadAssetType.none;
    }
  }

  initialLoad({bool initial = true}) async {
    await loadPackage(initial: initial);
    await loadDistrict(initial: initial);
    await loadRoute(initial: initial);
    await loadInventory(initial: initial);
    // await loadCondition(initial: initial);
    // if (!initial) {
    //   applyFilter();
    // }
  }

  loadPackage({initial = true}) async {
    try {
      state.value = LoaderState.loading;
      final data = await repository.showFilterPackage();
      if (auth.getUserPackage()?.isEmpty ?? true) {
        packageDropdown.value = data.tblPackage
            .map((e) => DropdownModel(e.packageId, e.packageName))
            .toList();
      } else {
        packageDropdown.value = data.tblPackage
            .expand((e) => [
                  if (auth.getUserPackage() == e.packageId)
                    DropdownModel(e.packageId, e.packageName)
                ])
            .toList();
      }

      if (packageDropdown.isNotEmpty && initial) {
        // package.value = packageDropdown[0].id;
      }
      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  loadDistrict({initial = true}) async {
    if (package.value == null || package.value!.isEmpty) return;
    try {
      state.value = LoaderState.loading;
      districtDropdown.clear();
      final data = await repository.showFilterDistrict(package.value!);

      districtDropdown.addAll(data.tblDistrict
          .map((e) => DropdownModel(e.districtId, e.districtName))
          .toList());
      if (districtDropdown.isNotEmpty && initial) {
        // district.value = districtDropdown[0].id;
      }
      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  loadRoute({initial = true}) async {
    if (package.value == null || package.value!.isEmpty) return;
    if (district.value == null || district.value!.isEmpty) return;
    try {
      state.value = LoaderState.loading;
      if (initial) {
        route.value = null;
      }

      routeDropdown.clear();
      final data =
          await repository.showFilterRoute(package.value!, district.value!);
      routeDropdown.addAll(data.tblRoute
          .map((e) => DropdownModel(e.routeId, "${e.routeNo} - ${e.routeName}"))
          .toList());
      if (routeDropdown.isNotEmpty && initial) {
        // route.value = routeDropdown[0].id;
      }
      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  loadInventory({initial = true}) async {
    try {
      state.value = LoaderState.loading;
      inventoryDropdown.clear();
      final data = await repository.showFilterInventory();
      inventoryDropdown.addAll(
          data.data.map((e) => DropdownModel("${e.id}", e.value)).toList());
      inventories = {
        for (var element in data.data) "${element.id}": element.value
      };
      // bridgeId =
      //     data.data.firstWhereOrNull((element) => element.name == "Bridge")?.id;
      if (inventoryDropdown.isNotEmpty && initial) {
        selectItem(inventoryDropdown[0].id);
      }
      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  loadBridgeCategory({initial = true}) async {
    try {
      state.value = LoaderState.loading;
      final data = await repository.showFilterBridgeCategory();
      categoryDropdown.clear();
      categoryDropdown.add(
        const DropdownModel("-", "-"),
      );
      if (initial) {
        selectCategory(categoryDropdown[0].id);
      }
      categoryDropdown.addAll(
          data.data.map((e) => DropdownModel("${e.id}", e.value)).toList());
      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  loadBridgeType({initial = true, empty = false}) async {
    try {
      if (category.value == null) return;
      state.value = LoaderState.loading;
      typeDropdown.clear();

      typeDropdown.add(
        const DropdownModel("-", "-"),
      );
      if (initial) {
        type.value = typeDropdown[0].id;
      }
      if (!empty) {
        final data = await repository.showFilterBridgeType(category.value);
        typeDropdown.addAll(data.data
            .map((e) => DropdownModel(e.bridgeId, e.bridgeType))
            .toList());
      }
      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }

  applyFilter() async {
    if (package.value == null || package.value!.isEmpty) {
      return SmartDialog.showToast("Please Select the Package");
    }
    if (district.value == null || district.value!.isEmpty) {
      return SmartDialog.showToast("Please Select the District");
    }
    if (route.value == null || route.value!.isEmpty) {
      // return SmartDialog.showToast("Please Select the Route");
    }
    if (inventory.value == null || inventory.value!.isEmpty) {
      return SmartDialog.showToast("Please Select the Inventory");
    }
    try {
      state.value = LoaderState.loading;
      final cgy = category.value != null && category.value != "-";
      final typ = type.value != null && type.value != "-";
      final roadAsset = await repository.showRoadAsset(
        package: package.value!,
        district: district.value!,
        route: route.value,
        inventory: inventory.value!,
        category: showBridgeOptions.value && cgy ? category.value : null,
        type: showBridgeOptions.value && typ ? type.value : null,
      );
      state.value = LoaderState.loaded;
      homeController.closeDrawer();
      if (roadAsset.extraMessage.isNotEmpty) {
        roadAssetController.to();
        return SmartDialog.showToast(roadAsset.extraMessage);
      } else if (roadAsset.fileName.isEmpty) {
        roadAssetController.to();
        return SmartDialog.showToast("No Record Found");
      }
      roadAssetController.to(roadAsset, roadAssetType);
    } catch (err) {
      state.value = LoaderState.failure;
      SmartDialog.showToast("Error while load data");
    }
  }

  resetFilter() async {
    clearAll();
    await initialLoad();
    roadAssetController.to();
  }

  clearAll() {
    package.value = null;
    district.value = null;
    route.value = null;
    inventory.value = null;
    category.value = null;
    type.value = null;
  }
}
