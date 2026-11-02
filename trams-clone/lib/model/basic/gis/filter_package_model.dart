import 'package:equatable/equatable.dart';

class FilterPackageModel extends Equatable {
  const FilterPackageModel({
    required this.httpStatus,
    required this.tblPackage,
  });

  final String httpStatus;
  final List<FilterPackage> tblPackage;

  FilterPackageModel copyWith({
    String? httpStatus,
    List<FilterPackage>? tblPackage,
  }) {
    return FilterPackageModel(
      httpStatus: httpStatus ?? this.httpStatus,
      tblPackage: tblPackage ?? this.tblPackage,
    );
  }

  factory FilterPackageModel.fromJson(Map<String, dynamic> json) {
    return FilterPackageModel(
      httpStatus: json["http_status"] ?? "",
      tblPackage: json["tbl_package"] == null
          ? []
          : List<FilterPackage>.from(
          json["tbl_package"]!.map((x) => FilterPackage.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
    httpStatus,
    tblPackage,
  ];
}

class FilterPackage extends Equatable {
  const FilterPackage({
    required this.packageId,
    required this.packageName,
  });

  final String packageId;
  final String packageName;

  FilterPackage copyWith({
    String? packageId,
    String? packageName,
  }) {
    return FilterPackage(
      packageId: packageId ?? this.packageId,
      packageName: packageName ?? this.packageName,
    );
  }

  factory FilterPackage.fromJson(Map<String, dynamic> json) {
    return FilterPackage(
      packageId: json["package_id"] ?? "",
      packageName: json["package_name"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "package_id": packageId,
    "package_name": packageName,
  };

  @override
  List<Object?> get props => [
    packageId,
    packageName,
  ];
}
