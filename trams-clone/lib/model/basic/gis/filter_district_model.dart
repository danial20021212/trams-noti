import 'package:equatable/equatable.dart';

class FilterDistrictModel extends Equatable {
  const FilterDistrictModel({
    required this.httpStatus,
    required this.tblDistrict,
  });

  final String httpStatus;
  final List<FilterDistrict> tblDistrict;

  FilterDistrictModel copyWith({
    String? httpStatus,
    List<FilterDistrict>? tblDistrict,
  }) {
    return FilterDistrictModel(
      httpStatus: httpStatus ?? this.httpStatus,
      tblDistrict: tblDistrict ?? this.tblDistrict,
    );
  }

  factory FilterDistrictModel.fromJson(Map<String, dynamic> json) {
    return FilterDistrictModel(
      httpStatus: json["http_status"] ?? "",
      tblDistrict: json["tbl_district"] == null
          ? []
          : List<FilterDistrict>.from(
          json["tbl_district"]!.map((x) => FilterDistrict.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
    httpStatus,
    tblDistrict,
  ];
}

class FilterDistrict extends Equatable {
  const FilterDistrict({
    required this.packageId,
    required this.division,
    required this.districtId,
    required this.districtName,
    required this.seqNo,
  });

  final String packageId;
  final String division;
  final String districtId;
  final String districtName;
  final String seqNo;

  FilterDistrict copyWith({
    String? packageId,
    String? division,
    String? districtId,
    String? districtName,
    String? seqNo,
  }) {
    return FilterDistrict(
      packageId: packageId ?? this.packageId,
      division: division ?? this.division,
      districtId: districtId ?? this.districtId,
      districtName: districtName ?? this.districtName,
      seqNo: seqNo ?? this.seqNo,
    );
  }

  factory FilterDistrict.fromJson(Map<String, dynamic> json) {
    return FilterDistrict(
      packageId: json["package_id"] ?? "",
      division: json["division"] ?? "",
      districtId: json["district_id"] ?? "",
      districtName: json["district_name"] ?? "",
      seqNo: json["seq_no"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "package_id": packageId,
    "division": division,
    "district_id": districtId,
    "district_name": districtName,
    "seq_no": seqNo,
  };

  @override
  List<Object?> get props => [
    packageId,
    division,
    districtId,
    districtName,
    seqNo,
  ];
}
