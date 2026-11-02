import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tram/controller/gis/pavement_map_controller.dart';
import 'package:tram/controller/home/root_home_controller.dart';
import 'package:tram/screen/gis/maintenance_work_filter.dart';
import 'package:tram/screen/gis/pavement_map_filter.dart';
import 'package:tram/screen/gis/road_asset_filter.dart';

class AllGisMapController extends GetxController {
  late TabController tabController;
  int selctedIndex = 0;

  List<Widget> drawers = [
    const PavementMapFilter(),
    const RoadAssetFilter(),
    const MaintenanceWorkFilter(),
  ];

  Rxn<Widget> floatingButton = Rxn();

  @override
  void onInit() {
    super.onInit();
  }

  to(int i) {
    tabController.animateTo(i);
  }

  @override
  void onReady() {
    tabController.addListener(() {
      selctedIndex = tabController.index;
      final ctr = Get.find<RootHomeController>();
      ctr.setDrawer(drawers[selctedIndex]);
      if (selctedIndex == 0) {
        final pmr = Get.find<PavementMapController>();
        floatingButton.value = pmr.floatingButton;
        ctr.setFLoatingButton(pmr.floatingButton);
      } else {
        floatingButton.value = null;
        ctr.setFLoatingButton(null);
      }
    });
    super.onReady();
  }

  final List<Tab> tabs = [
    Tab(
      height: 40,
      text: "Pavement",
    ),
    Tab(
      height: 40,
      text: "Road Asset",
    ),
    Tab(
      height: 40,
      text: "Maintenance\nWork",
    ),
  ];
}
