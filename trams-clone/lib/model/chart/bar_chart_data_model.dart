import 'package:flutter/material.dart';

class BarChartData {
  BarChartData(
    this.x,
    this.y, {
    this.title = "",
    this.description = "",
    this.color = Colors.green,
  });

  final String x;
  final double y;

  final String title;
  final String description;
  final Color color;
}
