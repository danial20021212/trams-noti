import 'package:equatable/equatable.dart';

class RoadConditionRatingCostModel extends Equatable {
  const RoadConditionRatingCostModel({
    required this.httpStatus,
    required this.paved,
    required this.unpaved,
  });

  final String httpStatus;

  final List<RoadConditionCost> paved;
  final List<RoadConditionCost> unpaved;

  @override
  List<Object?> get props => [
        httpStatus,
        paved,
        unpaved,
      ];
}

class RoadConditionRatingCostBeforeProceedModel extends Equatable {
  const RoadConditionRatingCostBeforeProceedModel({
    required this.httpStatus,
    required this.pavedPkg1,
    required this.pavedPkg2,
    required this.pavedPkg3,
    required this.pavedPkg4,
    required this.pavedPkg5,
    required this.unPavedPkg1,
    required this.unPavedPkg2,
    required this.unPavedPkg3,
    required this.unPavedPkg4,
    required this.unPavedPkg5,
  });

  final String httpStatus;
  final RoadConditionCost pavedPkg1;
  final RoadConditionCost pavedPkg2;
  final RoadConditionCost pavedPkg3;
  final RoadConditionCost pavedPkg4;
  final RoadConditionCost pavedPkg5;
  final RoadConditionCost unPavedPkg1;
  final RoadConditionCost unPavedPkg2;
  final RoadConditionCost unPavedPkg3;
  final RoadConditionCost unPavedPkg4;
  final RoadConditionCost unPavedPkg5;

  List<RoadConditionCost> paved() {
    return [
      pavedPkg1,
      pavedPkg2,
      pavedPkg3,
      pavedPkg4,
      pavedPkg5,
    ];
  }

  List<RoadConditionCost> unpaved() {
    return [
      unPavedPkg1,
      unPavedPkg2,
      unPavedPkg3,
      unPavedPkg4,
      unPavedPkg5,
    ];
  }

  factory RoadConditionRatingCostBeforeProceedModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return RoadConditionRatingCostBeforeProceedModel(
      httpStatus: json["http_status"] ?? "",
      pavedPkg1: json["PavedPkg1"] == null
          ? RoadConditionCost.emptyCost()
          : RoadConditionCost.fromJson(json["PavedPkg1"]),
      pavedPkg2: json["PavedPkg2"] == null
          ? RoadConditionCost.emptyCost()
          : RoadConditionCost.fromJson(json["PavedPkg2"]),
      pavedPkg3: json["PavedPkg3"] == null
          ? RoadConditionCost.emptyCost()
          : RoadConditionCost.fromJson(json["PavedPkg3"]),
      pavedPkg4: json["PavedPkg4"] == null
          ? RoadConditionCost.emptyCost()
          : RoadConditionCost.fromJson(json["PavedPkg4"]),
      pavedPkg5: json["PavedPkg5"] == null
          ? RoadConditionCost.emptyCost()
          : RoadConditionCost.fromJson(json["PavedPkg5"]),
      unPavedPkg1: json["UnPavedPkg1"] == null
          ? RoadConditionCost.emptyCost()
          : RoadConditionCost.fromJson(json["UnPavedPkg1"]),
      unPavedPkg2: json["UnPavedPkg2"] == null
          ? RoadConditionCost.emptyCost()
          : RoadConditionCost.fromJson(json["UnPavedPkg2"]),
      unPavedPkg3: json["UnPavedPkg3"] == null
          ? RoadConditionCost.emptyCost()
          : RoadConditionCost.fromJson(json["UnPavedPkg3"]),
      unPavedPkg4: json["UnPavedPkg4"] == null
          ? RoadConditionCost.emptyCost()
          : RoadConditionCost.fromJson(json["UnPavedPkg4"]),
      unPavedPkg5: json["UnPavedPkg5"] == null
          ? RoadConditionCost.emptyCost()
          : RoadConditionCost.fromJson(json["UnPavedPkg5"]),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        pavedPkg1,
        pavedPkg2,
        pavedPkg3,
        pavedPkg4,
        pavedPkg5,
        unPavedPkg1,
        unPavedPkg2,
        unPavedPkg3,
        unPavedPkg4,
        unPavedPkg5,
      ];
}

class RoadConditionCost extends Equatable {
  const RoadConditionCost({
    required this.achievement,
    required this.condition2Cost,
    required this.condition3Cost,
  });

  final String achievement;
  final String condition2Cost;
  final String condition3Cost;

  factory RoadConditionCost.fromJson(List<dynamic> json) {
    return RoadConditionCost(
      achievement: json[0]["Achievement"] ?? "",
      condition2Cost: json[1]["Condition2Cost"] ?? "",
      condition3Cost: json[2]["Condition3Cost"] ?? "",
    );
  }

  factory RoadConditionCost.emptyCost() {
    return const RoadConditionCost(
      achievement: "",
      condition2Cost: "",
      condition3Cost: "",
    );
  }

  @override
  List<Object?> get props => [
        achievement,
        condition2Cost,
        condition3Cost,
      ];
}
