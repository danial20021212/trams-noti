import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tram/components/Neumorphic/card_3.dart';
import 'package:tram/components/line_chart1.dart';
import 'package:tram/controller/other/spi_controller.dart';
import 'package:tram/model/shared/loader_state_model.dart';

import '../../components/Neumorphic/navbar.dart';

class SPIScreen extends StatefulWidget {
  const SPIScreen({super.key});

  @override
  State<SPIScreen> createState() => _SPIState();
}

class _SPIState extends State<SPIScreen> {
  final controller = Get.find<SPIController>();
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
      appBar: NeumorphicNavBar(
        title: "SPI",
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
    return NeumorphicCard3(
      "Service Provider's Indicator",
      children: [
        LineChart1(
          controller.list,
          yTitle: "Service Provider",
          xTitle: "SPI(%)",
          yMaximun: 104,
          yMinimun: 0,
          tooltipBehavior: _tooltipBehavior,
          legendItemText: "Service Provider's Indicator (SPI)",
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
