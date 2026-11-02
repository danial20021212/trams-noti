import 'package:flutter/widgets.dart';

class SeverityModel {
  final String level;
  final String additionalNote;
  final Text description;

  SeverityModel({
    required this.level,
    this.additionalNote = "",
    required this.description,
  });

}