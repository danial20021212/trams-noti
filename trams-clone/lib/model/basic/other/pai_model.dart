import 'package:equatable/equatable.dart';

class PaiModel extends Equatable {
  const PaiModel({
    required this.httpStatus,
    required this.paiXAxis,
    required this.paiYAxis,
  });

  final String httpStatus;
  final List<String> paiXAxis;
  final List<String> paiYAxis;

  PaiModel copyWith({
    String? httpStatus,
    List<String>? paiXAxis,
    List<String>? paiYAxis,
  }) {
    return PaiModel(
      httpStatus: httpStatus ?? this.httpStatus,
      paiXAxis: paiXAxis ?? this.paiXAxis,
      paiYAxis: paiYAxis ?? this.paiYAxis,
    );
  }

  factory PaiModel.fromJson(Map<String, dynamic> json) {
    return PaiModel(
      httpStatus: json["http_status"] ?? "",
      paiXAxis: json["PAI_XAxis"] == null
          ? []
          : List<String>.from(json["PAI_XAxis"]!.map((x) => x)),
      paiYAxis: json["PAI_YAxis"] == null
          ? []
          : List<String>.from(json["PAI_YAxis"]!.map((x) => x)),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        paiXAxis,
        paiYAxis,
      ];
}
