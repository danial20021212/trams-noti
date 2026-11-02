import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tram/components/Neumorphic/card_3.dart';
import 'package:tram/controller/road/road_length_controller.dart';
import 'package:tram/model/chart/stacked_bar_chart_data_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';

import '../../components/Neumorphic/navbar.dart';

class RoadLenthScreen extends StatefulWidget {
  const RoadLenthScreen({super.key});

  @override
  State<RoadLenthScreen> createState() => _RoadLengthState();
}

class _RoadLengthState extends State<RoadLenthScreen> {
  final controller = Get.find<RoadlengthController>();
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      canShowMarker: false,
      builder: (data, point, series, pointIndex, seriesIndex) {
        final result = data as StackedBarChartData;
        return Container(
          padding: EdgeInsets.all(10),
          width: 200,
          height: 50,
          child: Column(
            children: [
              Text(
                "Paved: ${result.y}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                "Unpaved ${result.yValue}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicNavBar(
        title: "Road Length",
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
    final stateWide = controller.statewide.value!;
    return NeumorphicCard3(
      "Maintenance Road Length",
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textBold(
          "Statewide",
        ),
        textBold(
          "Total Length: ${stateWide.totalLengthStatewidePavedUnpaved.toStringAsFixed(2)} km",
        ),
        Row(
          children: [
            Expanded(
              child: textBold(
                "Paved: ${stateWide.totalLengthPaved.toStringAsFixed(2)} km",
              ),
            ),
            Expanded(
              child: textBold(
                "Unpaved: ${stateWide.totalLengthUnpaved.toStringAsFixed(2)} km",
              ),
            )
          ],
        ),
        SfCartesianChart(
          plotAreaBorderWidth: 1,
          title: ChartTitle(text: 'Maintenance Road Length'),
          legend: Legend(
            isVisible: true,
            position: LegendPosition.top,
          ),
          primaryXAxis: CategoryAxis(
            title: AxisTitle(text: "Service Provider"),
            majorGridLines: MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: "Road Length (KM)"),
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(size: 0),
          ),
          series: _getStackedBarSeries(),
          tooltipBehavior: _tooltipBehavior,
        ),
      ],
    );
  }

  Widget textBold(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  /// Returns the list of chart series which need to render
  /// on the stacked bar chart.
  List<StackedBarSeries<StackedBarChartData, String>> _getStackedBarSeries() {
    return <StackedBarSeries<StackedBarChartData, String>>[
      StackedBarSeries<StackedBarChartData, String>(
        dataSource: controller.list,
        xValueMapper: (StackedBarChartData sales, _) => sales.x as String,
        yValueMapper: (StackedBarChartData sales, _) => sales.y,
        name: 'Paved(KM)',
        color: Colors.grey,
      ),
      StackedBarSeries<StackedBarChartData, String>(
        dataSource: controller.list,
        xValueMapper: (StackedBarChartData sales, _) => sales.x as String,
        yValueMapper: (StackedBarChartData sales, _) => sales.yValue,
        name: 'Unpaved(KM)',
        color: Colors.orange,
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }
}
