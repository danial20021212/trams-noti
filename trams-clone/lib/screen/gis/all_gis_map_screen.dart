import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:get/get.dart';
import 'package:tram/controller/gis/all_gis_map_controller.dart';
import 'package:tram/screen/gis/maintenance_work_screen.dart';
import 'package:tram/screen/gis/pavement_map_filter.dart';
import 'package:tram/screen/gis/pavement_map_screen.dart';
import 'package:tram/screen/gis/road_asset_screen.dart';
import 'package:tram/screen/home/coming_soon_screen.dart';

import '../../components/Neumorphic/navbar.dart';

class AllGisMapScreen extends StatefulWidget {
  const AllGisMapScreen({super.key});

  @override
  State<AllGisMapScreen> createState() => _AllGisState();
}

class _AllGisState extends State<AllGisMapScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<AllGisMapController>();

  @override
  void initState() {
    controller.tabController =
        TabController(length: controller.tabs.length, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: const NeumorphicStyle(
        color: Color(0xfff3f8fe),
      ),
      child: Column(
        children: [
          TabBar(
            controller: controller.tabController,
            tabs: controller.tabs,
            labelColor: Colors.blue,
            labelStyle: TextStyle(
              fontSize: 14,
            ),
            unselectedLabelColor: Colors.black,
          ),
          Expanded(
            child: TabBarView(
                controller: controller.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  PavementMapScreen(),
                  RoadAssetScreen(),
                  MaintenanceWorkScreen(),
                ]),
          ),
        ],
      ),
    );
  }
}
