
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tram/components/Neumorphic/card_3.dart';
import 'package:tram/components/line_chart1.dart';
import 'package:tram/controller/other/pai_controller.dart';
import 'package:tram/model/shared/loader_state_model.dart';

import '../../components/Neumorphic/navbar.dart';

class PAIScreen extends StatefulWidget {
  const PAIScreen({super.key});

  @override
  State<PAIScreen> createState() => _PAIState();
}

class _PAIState extends State<PAIScreen> {

  final controller = Get.find<PAIController>();
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NeumorphicNavBar(
        title: "PAI",
        showDrawer: false,
        color: Color(0xfff3f8fe),
      ),
      body: Neumorphic(
        style: const NeumorphicStyle(
          color: Color(0xfff3f8fe),
        ),
        child: Obx(() {

          switch (controller.state.value) {
            case LoaderState.initial:
            case LoaderState.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case LoaderState.loaded:
              return ListView(
                children: [
                  _buildStackedBarChart(),
                ],
              );
            case LoaderState.failure:
              return const Center(
                child: Text("Failed to load data"),
              );
          }
        }),
      ),
    );
  }


  Widget _buildStackedBarChart() {
    print(controller.list);
    return NeumorphicCard3(
      "Physical Accomplishment Index",
      children: [
        Column(
          children: [
            LineChart1(
              controller.list,
              yTitle: "Service Provider",
              xTitle: "PAI",
              // yMaximun: 1.03,
              yMinimun: 0.0,
              tooltipBehavior: controller.tooltip,
              legendItemText: "Physical Accomplishment Index (PAI)",
            )
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
