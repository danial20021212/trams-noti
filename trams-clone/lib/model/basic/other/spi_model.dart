import 'package:equatable/equatable.dart';

class SpiModel extends Equatable {
  const SpiModel({
    required this.httpStatus,
    required this.spiXAxis,
    required this.spiYAxis,
  });

  final String httpStatus;
  final List<String> spiXAxis;
  final List<String> spiYAxis;

  SpiModel copyWith({
    String? httpStatus,
    List<String>? spiXAxis,
    List<String>? spiYAxis,
  }) {
    return SpiModel(
      httpStatus: httpStatus ?? this.httpStatus,
      spiXAxis: spiXAxis ?? this.spiXAxis,
      spiYAxis: spiYAxis ?? this.spiYAxis,
    );
  }

  factory SpiModel.fromJson(Map<String, dynamic> json) {
    return SpiModel(
      httpStatus: json["http_status"] ?? "",
      spiXAxis: json["SPI_XAxis"] == null
          ? []
          : List<String>.from(json["SPI_XAxis"]!.map((x) => x)),
      spiYAxis: json["SPI_YAxis"] == null
          ? []
          : List<String>.from(json["SPI_YAxis"]!.map((x) => x)),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        spiXAxis,
        spiYAxis,
      ];
}
