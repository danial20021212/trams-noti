import 'package:equatable/equatable.dart';

class FilterBridgeCategoryModel extends Equatable {
  const FilterBridgeCategoryModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<FilterBridgeCategory> data;

  FilterBridgeCategoryModel copyWith({
    String? httpStatus,
    List<FilterBridgeCategory>? data,
  }) {
    return FilterBridgeCategoryModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory FilterBridgeCategoryModel.fromJson(Map<String, dynamic> json) {
    return FilterBridgeCategoryModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<FilterBridgeCategory>.from(
              json["data"]!.map((x) => FilterBridgeCategory.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class FilterBridgeCategory extends Equatable {
  const FilterBridgeCategory({
    required this.id,
    required this.value,
  });

  final int id;
  final String value;

  FilterBridgeCategory copyWith({
    int? id,
    String? value,
  }) {
    return FilterBridgeCategory(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }

  factory FilterBridgeCategory.fromJson(Map<String, dynamic> json) {
    return FilterBridgeCategory(
      id: json["id"] ?? 0,
      value: json["value"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        id,
        value,
      ];
}
