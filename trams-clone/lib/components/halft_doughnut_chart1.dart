import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tram/model/chart/bar_chart_data_model.dart';

class HalfDoughnutChart1 extends StatelessWidget {
  final List<BarChartData> chartData;
  final TooltipBehavior? tooltipBehavior;
  final Legend? legend;
  const HalfDoughnutChart1(
    this.chartData, {
    super.key,
    this.tooltipBehavior,
    this.legend = const Legend(),
  });
  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      margin: EdgeInsets.zero,
      legend: legend!,
      onLegendItemRender: (legendRenderArgs) {
        legendRenderArgs.text = (legendRenderArgs.pointIndex! + 1).toString();
      },
      tooltipBehavior: tooltipBehavior,
      series: <CircularSeries>[
        DoughnutSeries<BarChartData, String>(
          dataSource: chartData,
          legendIconType: LegendIconType.circle,
          xValueMapper: (BarChartData data, _) => data.x,
          yValueMapper: (BarChartData data, _) => data.y,
          pointColorMapper: (BarChartData data, index) => data.color,
          // Starting angle of doughnut
          startAngle: 270,
          // Ending angle of doughnut
          endAngle: 90,
        )
      ],
    );
  }
}
