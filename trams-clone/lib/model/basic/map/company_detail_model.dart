import 'package:equatable/equatable.dart';

class CompanyDetailModel extends Equatable {
  CompanyDetailModel({
    required this.httpStatus,
    required this.package,
    required this.totalLength,
    required this.pavedLength,
    required this.unpavedLength,
    required this.logo,
    required this.companyName,
    required this.spCompanyName,
    required this.spContactPerson,
    required this.spContactNo,
    required this.constCompanyName,
    required this.constContactPerson,
    required this.constContactNo,
  });

  final String httpStatus;
  final String package;
  final double totalLength;
  final double pavedLength;
  final double unpavedLength;
  final String logo;
  final String companyName;
  final String spCompanyName;
  final String spContactPerson;
  final String spContactNo;
  final String constCompanyName;
  final String constContactPerson;
  final String constContactNo;

  factory CompanyDetailModel.fromJson(Map<String, dynamic> json) {
    return CompanyDetailModel(
      httpStatus: json["http_status"] ?? "",
      package: json["Package"] ?? "",
      totalLength: json["TotalLength"] ?? 0.0,
      pavedLength: json["PavedLength"] ?? 0.0,
      unpavedLength: json["UnpavedLength"] ?? 0.0,
      logo: json["logo"] ?? "",
      companyName: json["company_name"] ?? "",
      spCompanyName: json["sp_company_name"] ?? "",
      spContactPerson: json["sp_contact_person"] ?? "",
      spContactNo: json["sp_contact_no"] ?? "",
      constCompanyName: json["const_company_name"] ?? "",
      constContactPerson: json["const_contact_person"] ?? "",
      constContactNo: json["const_contact_no"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        package,
        totalLength,
        pavedLength,
        unpavedLength,
        logo,
        companyName,
        spCompanyName,
        spContactPerson,
        spContactNo,
        constCompanyName,
        constContactPerson,
        constContactNo,
      ];
}
