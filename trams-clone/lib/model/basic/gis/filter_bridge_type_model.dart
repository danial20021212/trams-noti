import 'package:equatable/equatable.dart';

class FilterBridgeTypeModel extends Equatable {
  const FilterBridgeTypeModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;

  final List<FilterBridgeType> data;

  FilterBridgeTypeModel copyWith({
    String? httpStatus,
    List<FilterBridgeType>? data,
  }) {
    return FilterBridgeTypeModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory FilterBridgeTypeModel.fromJson(Map<String, dynamic> json) {
    return FilterBridgeTypeModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<FilterBridgeType>.from(
              json["data"]!.map((x) => FilterBridgeType.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class FilterBridgeType extends Equatable {
  const FilterBridgeType({
    required this.bridgeId,
    required this.bridgeType,
    required this.bridgeCategory,
  });

  final String bridgeId;
  final String bridgeType;
  final String bridgeCategory;

  FilterBridgeType copyWith({
    String? bridgeId,
    String? bridgeType,
    String? bridgeCategory,
  }) {
    return FilterBridgeType(
      bridgeId: bridgeId ?? this.bridgeId,
      bridgeType: bridgeType ?? this.bridgeType,
      bridgeCategory: bridgeCategory ?? this.bridgeCategory,
    );
  }

  factory FilterBridgeType.fromJson(Map<String, dynamic> json) {
    return FilterBridgeType(
      bridgeId: json["bridge_id"] ?? "",
      bridgeType: json["bridge_type"] ?? "",
      bridgeCategory: json["bridge_category"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        bridgeId,
        bridgeType,
        bridgeCategory,
      ];
}
