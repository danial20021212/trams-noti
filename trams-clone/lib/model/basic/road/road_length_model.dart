import 'package:equatable/equatable.dart';

class RoadLengthModel extends Equatable {
  const RoadLengthModel({
    required this.httpStatus,
    required this.dataCharts,
  });

  final String httpStatus;
  final List<RoadLength> dataCharts;

  RoadLengthModel copyWith({
    String? httpStatus,
    List<RoadLength>? dataCharts,
  }) {
    return RoadLengthModel(
      httpStatus: httpStatus ?? this.httpStatus,
      dataCharts: dataCharts ?? this.dataCharts,
    );
  }

  factory RoadLengthModel.fromJson(Map<String, dynamic> json) {
    return RoadLengthModel(
      httpStatus: json["http_status"] ?? "",
      dataCharts: json["dataCharts"] == null
          ? []
          : List<RoadLength>.from(
              json["dataCharts"]!.map((x) => RoadLength.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        dataCharts,
      ];
}

class RoadLength extends Equatable {
  RoadLength({
    required this.serviceProvider,
    required this.pavedRoadLength,
    required this.unpavedRoadLength,
  });

  final String serviceProvider;
  final double pavedRoadLength;
  final double unpavedRoadLength;

  RoadLength copyWith({
    String? serviceProvider,
    double? pavedRoadLength,
    double? unpavedRoadLength,
  }) {
    return RoadLength(
      serviceProvider: serviceProvider ?? this.serviceProvider,
      pavedRoadLength: pavedRoadLength ?? this.pavedRoadLength,
      unpavedRoadLength: unpavedRoadLength ?? this.unpavedRoadLength,
    );
  }

  factory RoadLength.fromJson(Map<String, dynamic> json) {
    return RoadLength(
      serviceProvider: json["ServiceProvider"] ?? "",
      pavedRoadLength: json["PavedRoadLength"] ?? 0.0,
      unpavedRoadLength: json["UnpavedRoadLength"] ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        serviceProvider,
        pavedRoadLength,
        unpavedRoadLength,
      ];
}
