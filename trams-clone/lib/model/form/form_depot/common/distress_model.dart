import 'package:equatable/equatable.dart';

class DistressModel extends Equatable {
  const DistressModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<Distress> data;

  DistressModel copyWith({
    String? httpStatus,
    List<Distress>? data,
  }) {
    return DistressModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory DistressModel.fromJson(Map<String, dynamic> json) {
    return DistressModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<Distress>.from(
          json["data"]!.map((x) => Distress.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
    httpStatus,
    data,
  ];
}

class Distress extends Equatable {
  const Distress({required this.distressCode, required this.distressName});

  final String distressCode;
  final String distressName;

  Distress copyWith({
    String? distressCode,
    String? distressName,
  }) {
    return Distress(
        distressCode: distressCode ?? this.distressCode,
        distressName: distressName ?? this.distressName);
  }

  factory Distress.fromJson(Map<String, dynamic> json) {
    return Distress(
        distressCode: json["dt_code"] ?? "",
        distressName: json["dt_name"] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "dt_code": distressCode,
      "dt_name": distressName,
    };
  }

  @override
  List<Object?> get props => [
    distressCode,
    distressName,
  ];
}
