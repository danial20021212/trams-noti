import 'package:equatable/equatable.dart';

class FilterDivisionModel extends Equatable {
  const FilterDivisionModel({
    required this.httpStatus,
    required this.tblDivision,
  });

  final String httpStatus;
  final List<FilterDivision> tblDivision;

  FilterDivisionModel copyWith({
    String? httpStatus,
    List<FilterDivision>? tblDistrict,
  }) {
    return FilterDivisionModel(
      httpStatus: httpStatus ?? this.httpStatus,
      tblDivision: tblDistrict ?? tblDivision,
    );
  }

  factory FilterDivisionModel.fromJson(Map<String, dynamic> json) {
    return FilterDivisionModel(
      httpStatus: json["http_status"] ?? "",
      tblDivision: json["tbl_district"] == null
          ? []
          : List<FilterDivision>.from(
          json["tbl_district"]!.map((x) => FilterDivision.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
    httpStatus,
    tblDivision,
  ];
}

class FilterDivision extends Equatable {
  const FilterDivision({
    required this.packageId,
    required this.divisionName,
  });

  final String packageId;
  final String divisionName;

  FilterDivision copyWith({
    String? packageId,
    String? divisionName,
  }) {
    return FilterDivision(
      packageId: packageId ?? this.packageId,
      divisionName: divisionName ?? this.divisionName,
    );
  }

  factory FilterDivision.fromJson(Map<String, dynamic> json) {
    return FilterDivision(
      packageId: json["div_pkg_id"] ?? "",
      divisionName: json["div_name"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
    packageId,
    divisionName,
  ];
}
