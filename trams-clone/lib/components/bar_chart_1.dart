import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tram/model/chart/bar_chart_data_model.dart';

class BarChart1 extends StatelessWidget {
  final TooltipBehavior? tooltipBehavior;
  final List<BarChartData> chartData;
  final String? xTitle;
  final String? ytitle;
  final String? title;
  final double? xMaximun;
  final ChartAxisLabel Function(AxisLabelRenderDetails)? xFormatter;

  const BarChart1(
    this.chartData, {
    super.key,
    this.tooltipBehavior,
    this.xTitle,
    this.ytitle,
    this.title,
    this.xMaximun,
    this.xFormatter,
  });
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        title: title != null ? ChartTitle(text: title!) : ChartTitle(),
        primaryXAxis: CategoryAxis(
          title: ytitle != null ? AxisTitle(text: ytitle) : AxisTitle(),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: xMaximun,
          axisLabelFormatter: xFormatter,
          title: xTitle != null ? AxisTitle(text: xTitle) : AxisTitle(),
        ),
        tooltipBehavior: tooltipBehavior,
        series: <CartesianSeries<BarChartData, String>>[
          BarSeries<BarChartData, String>(
            dataSource: chartData,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
            xValueMapper: (BarChartData data, _) => data.x,
            yValueMapper: (BarChartData data, _) => data.y,
            color: Color.fromRGBO(8, 142, 255, 1),
          ),
        ]);
  }
}
