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
    required this.recID,
    required this.name,
  });

  final int recID;
  final String name;

  FilterBridgeType copyWith({
    int? recID,
    String? name,
  }) {
    return FilterBridgeType(
      recID: recID ?? this.recID,
      name: name ?? this.name,
    );
  }

  factory FilterBridgeType.fromJson(Map<String, dynamic> json) {
    return FilterBridgeType(
      recID: json["rec_id"] ?? 0,
      name: json["name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "rec_id": recID,
      "name": name,
    };
  }

  @override
  List<Object?> get props => [
    recID,
    name,
  ];
}