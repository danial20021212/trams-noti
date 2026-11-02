import 'package:equatable/equatable.dart';

class FilterInventoryModel extends Equatable {
  const FilterInventoryModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<FilterInventory> data;

  FilterInventoryModel copyWith({
    String? httpStatus,
    List<FilterInventory>? data,
  }) {
    return FilterInventoryModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory FilterInventoryModel.fromJson(Map<String, dynamic> json) {
    return FilterInventoryModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<FilterInventory>.from(
              json["data"]!.map((x) => FilterInventory.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class FilterInventory extends Equatable {
  const FilterInventory({
    required this.id,
    required this.value,
  });

  final int id;
  final String value;

  FilterInventory copyWith({
    int? id,
    String? value,
  }) {
    return FilterInventory(
      id: id ?? this.id,
      value: value ?? this.value,
    );
  }

  factory FilterInventory.fromJson(Map<String, dynamic> json) {
    return FilterInventory(
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
