import 'package:equatable/equatable.dart';

class PaiThresholdModel extends Equatable {
  const PaiThresholdModel({
    required this.httpStatus,
    required this.paiXAxis,
    required this.paiYAxis, // Keep this as List<String>
    required this.threshold,
    this.displayMonth, // Optional fields
    this.displayYear,  // Optional fields
  });

  final String httpStatus;
  final List<String> paiXAxis;
  final List<String> paiYAxis; // Remain as String
  final double threshold;
  final String? displayMonth; // Optional field for display month
  final int? displayYear;     // Optional field for display year

  PaiThresholdModel copyWith({
    String? httpStatus,
    List<String>? paiXAxis,
    List<String>? paiYAxis, // Keep this as String
    double? threshold,
    String? displayMonth,
    int? displayYear,
  }) {
    return PaiThresholdModel(
      httpStatus: httpStatus ?? this.httpStatus,
      paiXAxis: paiXAxis ?? this.paiXAxis,
      paiYAxis: paiYAxis ?? this.paiYAxis, // Keep this as String
      threshold: threshold ?? this.threshold,
      displayMonth: displayMonth ?? this.displayMonth,
      displayYear: displayYear ?? this.displayYear,
    );
  }

  factory PaiThresholdModel.fromJson(Map<String, dynamic> json) {
    return PaiThresholdModel(
      httpStatus: json["http_status"] ?? "",
      paiXAxis: json["PAI_XAxis"] == null
          ? []
          : List<String>.from(json["PAI_XAxis"]!.map((x) => x)),
      paiYAxis: json["PAI_YAxis"] == null
          ? []
          : List<String>.from(
          json["PAI_YAxis"]!.map((x) => x.toString())), // Convert to String
      threshold: (json["threshold"] ?? 0).toDouble(), // Parse threshold as double
      displayMonth: json["display_month"], // Optional field
      displayYear: json["display_year"],   // Optional field
    );
  }

  @override
  List<Object?> get props => [
    httpStatus,
    paiXAxis,
    paiYAxis, // Keep this as String
    threshold,
    displayMonth,
    displayYear,
  ];
}
