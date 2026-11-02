import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tram/model/chart/bar_chart_data_model.dart';

class LineChart1 extends StatelessWidget {
  final TooltipBehavior? tooltipBehavior;
  final TrackballBehavior? trackballBehavior;
  final List<BarChartData> chartData;
  final String? xTitle;
  final String? yTitle;
  final String? title;
  final double? yMaximun;
  final double? yMinimun;
  final String? legendItemText;
  // final ChartAxisLabel Function(AxisLabelRenderDetails)? xFormatter;

  const LineChart1(
    this.chartData, {
    super.key,
    this.tooltipBehavior,
    this.xTitle,
    this.yTitle,
    this.title,
    this.yMaximun,
    this.yMinimun,
    this.trackballBehavior,
    this.legendItemText,
    // this.xFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        title: yTitle != null ? AxisTitle(text: yTitle) : AxisTitle(),
      ),
      trackballBehavior: trackballBehavior,
      tooltipBehavior: tooltipBehavior,
      title: title != null ? ChartTitle(text: title!) : ChartTitle(),
      primaryYAxis: NumericAxis(
        maximum: yMaximun,
        minimum: yMinimun,
        title: xTitle != null ? AxisTitle(text: xTitle) : AxisTitle(),
      ),
      legend: legendItemText != null
          ? Legend(
              isVisible: true,
              position: LegendPosition.top,
            )
          : const Legend(),
      series: <CartesianSeries>[
        SplineSeries<BarChartData, String>(
          legendItemText: legendItemText,
          legendIconType: LegendIconType.diamond,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.bottom,
            labelPosition: ChartDataLabelPosition.inside,
          ),
          dataSource: chartData,
          splineType: SplineType.natural,
          enableTooltip: tooltipBehavior != null ? true : false,
          markerSettings: MarkerSettings(isVisible: true),
          // Bind the color for all the data points from the data source
          xValueMapper: (BarChartData data, _) => data.x,
          yValueMapper: (BarChartData data, _) => data.y,
        )
      ],
    );
  }
}
