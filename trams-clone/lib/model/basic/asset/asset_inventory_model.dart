import 'package:equatable/equatable.dart';

class AssetInventoryModel extends Equatable {
  const AssetInventoryModel({
    required this.httpStatus,
    required this.statewide,
    required this.roadLength,
    required this.pavedRoad,
    required this.roadQuantity,
    required this.culvertQuantity,
    required this.bridgeQuantity,
    required this.signageQuantity,
    required this.guardrailQuantity,
    required this.solarStreetLightingQuantity,
    required this.streetLightingQuantity,
    required this.trafficLightQuantity,
  });

  final String httpStatus;
  final Statewide? statewide;
  final List<RoadLength> roadLength;
  final List<PavedRoad> pavedRoad;
  final List<RoadQuantity> roadQuantity;
  final List<CulvertQuantity> culvertQuantity;
  final List<BridgeQuantity> bridgeQuantity;
  final List<SignageQuantity> signageQuantity;
  final List<GuardrailQuantity> guardrailQuantity;
  final List<SolarStreetLightingQuantity> solarStreetLightingQuantity;
  final List<StreetLightingQuantity> streetLightingQuantity;
  final List<TrafficLightQuantity> trafficLightQuantity;

  factory AssetInventoryModel.fromJson(Map<String, dynamic> json) {
    return AssetInventoryModel(
      httpStatus: json["http_status"] ?? "",
      statewide: json["Statewide"]?[0] == null
          ? null
          : Statewide.fromJson(json["Statewide"][0]),
      roadLength: json["RoadLength"] == null
          ? []
          : List<RoadLength>.from(
              json["RoadLength"]!.map((x) => RoadLength.fromJson(x))),
      pavedRoad: json["PavedRoad"] == null
          ? []
          : List<PavedRoad>.from(
              json["PavedRoad"]!.map((x) => PavedRoad.fromJson(x))),
      roadQuantity: json["RoadQuantity"] == null
          ? []
          : List<RoadQuantity>.from(
              json["RoadQuantity"]!.map((x) => RoadQuantity.fromJson(x))),
      culvertQuantity: json["CulvertQuantity"] == null
          ? []
          : List<CulvertQuantity>.from(
              json["CulvertQuantity"]!.map((x) => CulvertQuantity.fromJson(x))),
      bridgeQuantity: json["BridgeQuantity"] == null
          ? []
          : List<BridgeQuantity>.from(
              json["BridgeQuantity"]!.map((x) => BridgeQuantity.fromJson(x))),
      signageQuantity: json["SignageQuantity"] == null
          ? []
          : List<SignageQuantity>.from(
              json["SignageQuantity"]!.map((x) => SignageQuantity.fromJson(x))),
      guardrailQuantity: json["GuardrailQuantity"] == null
          ? []
          : List<GuardrailQuantity>.from(json["GuardrailQuantity"]!
              .map((x) => GuardrailQuantity.fromJson(x))),
      solarStreetLightingQuantity: json["SolarStreetLightingQuantity"] == null
          ? []
          : List<SolarStreetLightingQuantity>.from(
              json["SolarStreetLightingQuantity"]!
                  .map((x) => SolarStreetLightingQuantity.fromJson(x))),
      streetLightingQuantity: json["StreetLightingQuantity"] == null
          ? []
          : List<StreetLightingQuantity>.from(json["StreetLightingQuantity"]!
              .map((x) => StreetLightingQuantity.fromJson(x))),
      trafficLightQuantity: json["TrafficLightQuantity"] == null
          ? []
          : List<TrafficLightQuantity>.from(json["TrafficLightQuantity"]!
              .map((x) => TrafficLightQuantity.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        statewide,
        roadLength,
        pavedRoad,
        roadQuantity,
        culvertQuantity,
        bridgeQuantity,
        signageQuantity,
        guardrailQuantity,
        solarStreetLightingQuantity,
        streetLightingQuantity,
        trafficLightQuantity,
      ];
}

class BridgeQuantity extends Equatable {
  const BridgeQuantity({
    required this.serviceProvider,
    required this.bridgeQuantity,
  });

  final String serviceProvider;
  final int bridgeQuantity;

  double value() => bridgeQuantity.toDouble();

  factory BridgeQuantity.fromJson(Map<String, dynamic> json) {
    return BridgeQuantity(
      serviceProvider: json["ServiceProvider"] ?? "",
      bridgeQuantity: json["BridgeQuantity"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        serviceProvider,
        bridgeQuantity,
      ];
}

class CulvertQuantity extends Equatable {
  const CulvertQuantity({
    required this.serviceProvider,
    required this.culvertQuantity,
  });

  final String serviceProvider;
  final int culvertQuantity;

  double value() => culvertQuantity.toDouble();

  factory CulvertQuantity.fromJson(Map<String, dynamic> json) {
    return CulvertQuantity(
      serviceProvider: json["ServiceProvider"] ?? "",
      culvertQuantity: json["CulvertQuantity"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        serviceProvider,
        culvertQuantity,
      ];
}

class PavedRoad extends Equatable {
  const PavedRoad({
    required this.serviceProvider,
    required this.pavedRoadLengthPercentage,
  });

  final String serviceProvider;
  final double pavedRoadLengthPercentage;

  double value() => pavedRoadLengthPercentage;

  factory PavedRoad.fromJson(Map<String, dynamic> json) {
    return PavedRoad(
      serviceProvider: json["ServiceProvider"] ?? "",
      pavedRoadLengthPercentage: (json["PavedRoadLengthPercentage"] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        serviceProvider,
        pavedRoadLengthPercentage,
      ];
}

class RoadLength extends Equatable {
  const RoadLength({
    required this.serviceProvider,
    required this.roadLength,
  });

  final String serviceProvider;
  final double roadLength;

  double value() => roadLength;

  factory RoadLength.fromJson(Map<String, dynamic> json) {
    return RoadLength(
      serviceProvider: json["ServiceProvider"] ?? "",
       roadLength: (json["RoadLength"] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        serviceProvider,
        roadLength,
      ];
}

class RoadQuantity extends Equatable {
  const RoadQuantity({
    required this.serviceProvider,
    required this.roadQuantity,
  });

  final String serviceProvider;
  final int roadQuantity;

  double value() => roadQuantity.toDouble();

  factory RoadQuantity.fromJson(Map<String, dynamic> json) {
    return RoadQuantity(
      serviceProvider: json["ServiceProvider"] ?? "",
      roadQuantity: json["RoadQuantity"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        serviceProvider,
        roadQuantity,
      ];
}

class SignageQuantity extends Equatable {
  const SignageQuantity({
    required this.serviceProvider,
    required this.signageQuantity,
  });

  final String serviceProvider;
  final int signageQuantity;

  double value() => signageQuantity.toDouble();

  factory SignageQuantity.fromJson(Map<String, dynamic> json) {
    return SignageQuantity(
      serviceProvider: json["ServiceProvider"] ?? "",
      signageQuantity: json["SignageQuantity"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        serviceProvider,
        signageQuantity,
      ];
}

class GuardrailQuantity extends Equatable {
  const GuardrailQuantity({
    required this.serviceProvider,
    required this.guardrailQuantity,
  });

  final String serviceProvider;
  final int guardrailQuantity;

  double value() => guardrailQuantity.toDouble();

  factory GuardrailQuantity.fromJson(Map<String, dynamic> json) {
    return GuardrailQuantity(
      serviceProvider: json["ServiceProvider"] ?? "",
      guardrailQuantity: json["GuardrailQuantity"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        serviceProvider,
        guardrailQuantity,
      ];
}

class SolarStreetLightingQuantity extends Equatable {
  const SolarStreetLightingQuantity({
    required this.serviceProvider,
    required this.solarStreetLightingQuantity,
  });

  final String serviceProvider;
  final int solarStreetLightingQuantity;

  double value() => solarStreetLightingQuantity.toDouble();

  factory SolarStreetLightingQuantity.fromJson(Map<String, dynamic> json) {
    return SolarStreetLightingQuantity(
      serviceProvider: json["ServiceProvider"] ?? "",
      solarStreetLightingQuantity: json["SolarStreetLightingQuantity"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        serviceProvider,
        solarStreetLightingQuantity,
      ];
}

class StreetLightingQuantity extends Equatable {
  const StreetLightingQuantity({
    required this.serviceProvider,
    required this.streetLightingQuantity,
  });

  final String serviceProvider;
  final int streetLightingQuantity;

  double value() => streetLightingQuantity.toDouble();

  factory StreetLightingQuantity.fromJson(Map<String, dynamic> json) {
    return StreetLightingQuantity(
      serviceProvider: json["ServiceProvider"] ?? "",
      streetLightingQuantity: json["StreetLightingQuantity"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        serviceProvider,
        streetLightingQuantity,
      ];
}

class TrafficLightQuantity extends Equatable {
  const TrafficLightQuantity({
    required this.serviceProvider,
    required this.trafficLightQuantity,
  });

  final String serviceProvider;
  final int trafficLightQuantity;

  double value() => trafficLightQuantity.toDouble();

  factory TrafficLightQuantity.fromJson(Map<String, dynamic> json) {
    return TrafficLightQuantity(
      serviceProvider: json["ServiceProvider"] ?? "",
      trafficLightQuantity: json["TrafficLightQuantity"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        serviceProvider,
        trafficLightQuantity,
      ];
}

class Statewide extends Equatable {
  const Statewide({
    required this.pavedRoad,
    required this.roadQuantity,
    required this.culvertQuantity,
    required this.bridgeQuantity,
    required this.signageQuantity,
    required this.guardrailQuantity,
    required this.solarStreetLightingQuantity,
    required this.streetLightingQuantity,
    required this.trafficLightQuantity,
  });

  final double pavedRoad;
  final int roadQuantity;
  final int culvertQuantity;
  final int bridgeQuantity;
  final int signageQuantity;
  final int guardrailQuantity;
  final int solarStreetLightingQuantity;
  final int streetLightingQuantity;
  final int trafficLightQuantity;

  factory Statewide.fromJson(Map<String, dynamic> json) {
    return Statewide(
      pavedRoad: (json["PavedRoad"] ?? 0).toDouble(),
      roadQuantity: json["RoadQuantity"] ?? 0,
      culvertQuantity: json["CulvertQuantity"] ?? 0,
      bridgeQuantity: json["BridgeQuantity"] ?? 0,
      signageQuantity: json["SignageQuantity"] ?? 0,
      guardrailQuantity: json["GuardrailQuantity"] ?? 0,
      solarStreetLightingQuantity: json["SolarStreetLightingQuantity"] ?? 0,
      streetLightingQuantity: json["StreetLightingQuantity"] ?? 0,
      trafficLightQuantity: json["TrafficLightQuantity"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        pavedRoad,
        roadQuantity,
        culvertQuantity,
        bridgeQuantity,
        signageQuantity,
        guardrailQuantity,
        solarStreetLightingQuantity,
        streetLightingQuantity,
        trafficLightQuantity,
      ];
}

class ChartItem extends Equatable {
  const ChartItem({
    required this.title,
    required this.value,
  });

  final String title;
  final double value;

  ChartItem copyWith({
    String? title,
    double? value,
  }) {
    return ChartItem(
      title: title ?? this.title,
      value: value ?? this.value,
    );
  }

  factory ChartItem.fromJson(List<dynamic> json) {
    return ChartItem(
      title: json[0] ?? "",
      value: (json[1] ?? 0).toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        title,
        value,
      ];
}
