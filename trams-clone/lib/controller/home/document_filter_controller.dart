import 'package:flutter/cupertino.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:tram/controller/home/root_home_controller.dart';
import 'package:tram/model/shared/dropdown_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';

import '../../repository/document_repository.dart';
import '../auth/auth_controller.dart';
import 'document_controller.dart';
 
class DocumentFilterController extends GetxController {
  final repository = DocumentRepository();
  final homeController = Get.find<RootHomeController>();
  // final historyController = Get.find<WorkHistoryController>();
  final documentController = Get.find<DocumentController>();
  final auth = Get.find<AuthController>();
  RxList<DropdownModel> packageDropdown = RxList();

  Rx<LoaderState> state = LoaderState.initial.obs;

  RxnString package = RxnString();
  RxnString docName = RxnString();

  final docNameController = TextEditingController();

  @override
  void onInit() {
    loadArguments();
    super.onInit();
  }

  manualArguments(Map<String, dynamic> args) async {
    loadArguments(args: args);
  }

  loadArguments({Map<String, dynamic>? args}) async {
    documentController.index.value = 0;
    args ??= Get.arguments;
    if (args == null) return initialLoad();
    state.value = LoaderState.loading;
    SmartDialog.showLoading();
    package.value = args["pkg"].toString();
    docName.value = args["docName"].toString();
    docNameController.text = args["docName"].toString();
    if (package.value == null || docName.value == null) {
      await initialLoad(initial: true);
    } else {
      await initialLoad(initial: false);
    }
    SmartDialog.dismiss();
  }

  selectPackage(String v) async {
    package.value = v;
  }

  fillName(String v) {
    docName.value = v;
  }

  Future<void> initialLoad({bool initial = true}) async {
    await loadPackage(initial: initial);
    if (initial) {
      docNameController.text = "";
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

  applyFilter() async {
    if (package.value == null || package.value!.isEmpty) {
      // documentController.index.value = 1;
      // return SmartDialog.showToast("Please Select the Package");
    }
    try {
      homeController.closeDrawer();
      documentController.apply(
        package: package.value != null ? package.value! : (auth.getUserPackage() ?? ""),
        docName: docName.value != null ? docName.value! : "",
      );
    } catch (err) {
      print(err);
      SmartDialog.showToast("Error while load data");
    }
  }

  resetFilter() async {
    clearAll();
    await initialLoad();
  }

  clearAll() {
    package.value = null;
    docName.value = null;
  }
}
