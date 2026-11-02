import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:tram/model/basic/map/package_detail_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/map_repository.dart';

class PackageDetailListingController extends GetxController {
  final scrollController = ScrollController();
  final repository = MapRepository();
  String pkg = Get.arguments["pkg"];

  final p1 = PagingController<int, DivisionModel>(firstPageKey: 0);
  final p2 = PagingController<int, DistrictModel>(firstPageKey: 0);

  String companyName = Get.arguments["company"];
  Rx<PackageDetailModel?> detail = Rxn();

  final List<Tab> tabs = const [
    Tab(
      height: 46,
      text: "Division",
    ),
    Tab(
      height: 46,
      text: "District",
    ),
  ];
  Rx<LoaderState> state = LoaderState.initial.obs;

  load() async {
    try {
      if (state.value == LoaderState.loading) return;
      state.value = LoaderState.loading;
      detail.value = await repository.showPackageDetail(pkg);
      appendList();
      state.value = LoaderState.loaded;
    } catch (err) {
      print(err);
      appendError(err);
      state.value = LoaderState.failure;
    }
  }

  appendList() {
    p1.appendLastPage(detail.value!.division);
    p2.appendLastPage(detail.value!.district);
  }

  appendError(Object err) {
    print(err);
    p1.error = err;
    p2.error = err;
  }

  @override
  void onInit() {
    load();
    p1.addPageRequestListener((pageKey) {
      load();
    });
    p2.addPageRequestListener((pageKey) {
      load();
    });
    super.onInit();
  }
}
