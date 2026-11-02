import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';

class SpeedChart1 extends StatelessWidget {
  final List<GaugeRange> gauges;
  final double value;

  const SpeedChart1(this.value, this.gauges, {super.key});

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          axisLabelStyle: GaugeTextStyle(
            fontSize: 12,
          ),
          minimum: 0,
          maximum: 100.01,
          ranges: gauges,
          interval: 10,
          pointers: <GaugePointer>[NeedlePointer(value: value)],
          // annotations: <GaugeAnnotation>[
          //   GaugeAnnotation(
          //       widget: Container(
          //         child: Text(
          //           '90.0',
          //           style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          //         ),
          //       ),
          //       angle: 90,
          //       positionFactor: 0.5)
          // ],
        )
      ],
    );
  }
}
