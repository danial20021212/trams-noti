import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tram/controller/gis/maintenance_work_controller.dart';
import 'package:tram/controller/gis/pavement_map_controller.dart';
import 'package:tram/controller/home/root_home_controller.dart';
import 'package:tram/model/shared/dropdown_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/pavement_repository.dart';

import '../auth/auth_controller.dart';

class MaintenanceWorkFilterController extends GetxController {
  final repository = PavementRepository();
  final homeController = Get.find<RootHomeController>();
  final maintenanceController = Get.find<MaintenanceWorkController>();
  final auth = Get.find<AuthController>();
  RxList<DropdownModel> packageDropdown = RxList();
  RxList<DropdownModel> districtDropdown = RxList();
  RxList<DropdownModel> routeDropdown = RxList();

  RxList<DropdownModel> programDropdown = RxList();

  Rx<LoaderState> state = LoaderState.initial.obs;

  RxnString package = RxnString();
  RxnString district = RxnString();
  RxnString route = RxnString();
  RxnString program = RxnString();
  RxnString year = RxnString();

  final dateController = TextEditingController();

  @override
  void onInit() {
    loadArguments();
    super.onInit();
  }

  manualArguments(Map<String, dynamic> args) async {
    loadArguments(args: args);
  }

  loadArguments({Map<String, dynamic>? args}) {
    args ??= Get.arguments;
    if (args == null) return initialLoad();
    package.value = args["pkg"];
    district.value = args["district"];
    route.value = args["route"];
    program.value = args["program"];
    year.value = args["year"];
    dateController.text = args["year"];
    if (package.value == null ||
        district.value == null ||
        route.value == null ||
        program.value == null ||
        year.value == null) {
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

  selectProgram(String v) async {
    program.value = v;
  }

  selectDate(String v) {
    dateController.text = v;
    year.value = v;
  }

  initialLoad({bool initial = true}) async {
    await loadPackage(initial: initial);
    await loadDistrict(initial: initial);
    await loadRoute(initial: initial);
    await loadWorkProgram(initial: initial);
    if (initial) {
      dateController.text = DateTime.now().year.toString();
      year.value = DateTime.now().year.toString();
    }
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

  loadWorkProgram({initial = true}) async {
    try {
      state.value = LoaderState.loading;
      programDropdown.clear();
      final data = await repository.showFilterWorkProgram();
      print(data);
      programDropdown
          .addAll(data.data.map((e) => DropdownModel(e.id, e.name)).toList());
      if (programDropdown.isNotEmpty && initial) {
        program.value = programDropdown[0].id;
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
    if (program.value == null || program.value!.isEmpty) {
      return SmartDialog.showToast("Please Select the Program");
    }
    try {
      state.value = LoaderState.loading;
      final maintenance = await repository.showMaintenanceWork(
          package: package.value!,
          district: district.value!,
          route:
              (route.value == null || route.value!.isEmpty) ? "" : route.value!,
          year: year.value!,
          program: program.value!);
      state.value = LoaderState.loaded;
      homeController.closeDrawer();
      if (maintenance.extraMessage.isNotEmpty) {
        maintenanceController.to();
        return SmartDialog.showToast(maintenance.extraMessage);
      } else if (maintenance.fileName.isEmpty) {
        maintenanceController.to();
        return SmartDialog.showToast("No Record Found");
      }
      maintenanceController.to(maintenance);
    } catch (err) {
      state.value = LoaderState.failure;
      SmartDialog.showToast("Error while load data");
    }
  }

  resetFilter() async {
    clearAll();
    await initialLoad();
    maintenanceController.to();
  }

  clearAll() {
    package.value = null;
    district.value = null;
    route.value = null;
    program.value = null;
    year.value = null;
  }
}
