import 'package:equatable/equatable.dart';

class FilterConditionModel extends Equatable {
  const FilterConditionModel({
    required this.httpStatus,
    required this.tblConditionName,
  });

  final String httpStatus;

  final List<FilterCondition> tblConditionName;

  FilterConditionModel copyWith({
    String? httpStatus,
    List<FilterCondition>? tblConditionName,
  }) {
    return FilterConditionModel(
      httpStatus: httpStatus ?? this.httpStatus,
      tblConditionName: tblConditionName ?? this.tblConditionName,
    );
  }

  factory FilterConditionModel.fromJson(Map<String, dynamic> json) {
    return FilterConditionModel(
      httpStatus: json["http_status"] ?? "",
      tblConditionName: json["tbl_condition_name"] == null
          ? []
          : List<FilterCondition>.from(json["tbl_condition_name"]!
              .map((x) => FilterCondition.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        tblConditionName,
      ];
}

class FilterCondition extends Equatable {
  const FilterCondition({
    required this.conditionId,
    required this.conditionName,
  });

  final String conditionId;
  final String conditionName;

  FilterCondition copyWith({
    String? conditionId,
    String? conditionName,
  }) {
    return FilterCondition(
      conditionId: conditionId ?? this.conditionId,
      conditionName: conditionName ?? this.conditionName,
    );
  }

  factory FilterCondition.fromJson(Map<String, dynamic> json) {
    return FilterCondition(
      conditionId: json["condition_id"] ?? "",
      conditionName: json["condition_name"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        conditionId,
        conditionName,
      ];
}
