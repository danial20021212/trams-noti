import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/controller/gis/all_gis_map_controller.dart';
import 'package:tram/screen/form_depot/common/form_depot_screen.dart';
import 'package:tram/screen/form_depot/form_draft/form_draft_screen.dart';
import 'package:tram/screen/home/coming_soon_screen.dart';
import 'package:tram/screen/home/dashboard_screen.dart';
import 'package:tram/screen/home/document_screen.dart';
import 'package:tram/screen/home/home_screen.dart';
import 'package:tram/screen/work_history/work_history_filter.dart';
import 'package:tram/screen/work_history/work_history_screen.dart';

import '../../screen/gis/all_gis_map_screen.dart';
import '../../screen/home/document_filter.dart';
import '../../widget/form_depot/form_depot_text_scope.dart';

class RootHomeController extends GetxController {
  RxInt index = 0.obs;
  RxInt notificationCount = 6.obs;
  final auth = Get.find<AuthController>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  late List<Widget> screens;

  List<Widget?> drawers = [
    null,
    null,
    const DocumentFilter(),
    null,
    const WorkHistoryFilter(),
    const FormDepotTextScope(child: FormDraftScreen())
  ];

  List<Widget?> floatingButtons = [
    null,
    null,
    null,
    null,
    null,
    null
  ];

  final comingSoon = const ComingSoonScreen();

  late Rx<Widget?> drawer;
  late Rx<Widget?> floatingButton;

  to(int i) {
    if (screens.asMap().containsKey(i)) {
      drawer.value = drawers[i];
      floatingButton.value = floatingButtons[i];
      index.value = i;
    } else {
      index.value = 4;
    }
    if (index.value == 3) {
      final ctr = Get.find<AllGisMapController>();
      drawer.value = ctr.drawers[ctr.selctedIndex];
      print(ctr.floatingButton);
      floatingButton.value = ctr.floatingButton.value;
    }
    closeDrawer();
  }

  setDrawer(Widget? widget) {
    drawer.value = widget;
  }

  setFLoatingButton(Widget? widget) {
    floatingButton.value = widget;
  }

  closeDrawer() {
    if (scaffoldKey.currentState?.isDrawerOpen ?? false) {
      scaffoldKey.currentState!.closeDrawer();
    }
  }

  logout() { 
    auth.logout();
  }

  @override
  void onInit() {
    screens = [
      const HomeScreen(),
      const DashboardScreen(),
      const DocumemntScreen(),
      const AllGisMapScreen(),
      const WorkHistoryScreen(),
      const FormDepotTextScope(child: FormDepotScreen())
    ];
    drawer = drawers[index.value].obs;
    floatingButton = floatingButtons[index.value].obs;
    super.onInit();
  }
}
