// ignore_for_file: camel_case_types

import 'package:equatable/equatable.dart';
import 'package:tram/model/form/form_depot/main_listing/form_main_listing_details_model.dart';
import 'package:tram/utils/parsers_utils.dart';

class Form_R_MainListingDetailsModel extends Equatable {
  const Form_R_MainListingDetailsModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<Form_R_MainListingDetailsDataModel> data;

  Form_R_MainListingDetailsModel copyWith({
    String? httpStatus,
    List<Form_R_MainListingDetailsDataModel>? data,
  }) {
    return Form_R_MainListingDetailsModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory Form_R_MainListingDetailsModel.fromJson(Map<String, dynamic> json) {
    return Form_R_MainListingDetailsModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<Form_R_MainListingDetailsDataModel>.from(json["data"]!
              .map((x) => Form_R_MainListingDetailsDataModel.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class Form_R_MainListingDetailsDataModel extends FormMainListingDetails {
  Form_R_MainListingDetailsDataModel({
    required this.projectName,
    required this.district,
    required this.roadId,
    required this.inspectionDate,
    required this.referenceNo,
    required this.structureCode,
    required this.chainage,
    required this.gpsEasting,
    required this.gpsNorthing,
    required this.status,
  });

  String? projectName;
  String? district;
  String? roadId;
  String? inspectionDate;
  String? referenceNo;
  String? structureCode;
  String? chainage;
  String? gpsEasting;
  String? gpsNorthing;
  String? status;

  factory Form_R_MainListingDetailsDataModel.fromJson(
      Map<String, dynamic> json) {
    return Form_R_MainListingDetailsDataModel(
      projectName: ParsersUtils.parseToString(json["ProjectName"]),
      district: ParsersUtils.parseToString(json["district"]),
      roadId: ParsersUtils.parseToString(json["road"]),
      inspectionDate: ParsersUtils.parseToString(json['inspection_date']),
      referenceNo: ParsersUtils.parseToString(json["reference_no"]),
      chainage: ParsersUtils.parseToString(json["Chainage"]),
      structureCode: ParsersUtils.parseToString(json["StructureCode"]),
      gpsEasting: ParsersUtils.parseToString(json["GPS_Easting"]),
      gpsNorthing: ParsersUtils.parseToString(json["GPS_Northing"]),
      status: ParsersUtils.parseToString(json["status"])
    );
  }

  List<Object?> get props => [
        projectName,
        district,
        roadId,
        referenceNo,
        inspectionDate,
        chainage,
        structureCode,
        gpsEasting,
        gpsNorthing,
        status
      ];

  @override
  List<Map<String, String>> getKeyValuePairs() {
    return [
      {
        "Inspection Date":
            inspectionDate?.isNotEmpty == true ? inspectionDate! : "-"
      },
      {"Project Name": projectName?.isNotEmpty == true ? projectName! : "-"},
      {"District": district?.isNotEmpty == true ? district! : "-"},
      {"Road": roadId?.isNotEmpty == true ? roadId! : "-"},
      {"Reference No": referenceNo?.isNotEmpty == true ? referenceNo! : "-"},
      {
        "Structure Code":
            structureCode?.isNotEmpty == true ? structureCode! : "-"
      },
      {"Chainage": chainage?.isNotEmpty == true ? chainage! : "-"},
      {"GPS Easting": gpsEasting?.isNotEmpty == true ? gpsEasting! : "-"},
      {"GPS Northing": gpsNorthing?.isNotEmpty == true ? gpsNorthing! : "-"},

      {"Status": status?.isNotEmpty == true ? status! : "-"},
    ];
  }

  @override
  List<Map<String, String>> getKeyValuePairsInGeneral() {
    return [
      {"Project Name": projectName?.isNotEmpty == true ? projectName! : "-"},
      {"District": district?.isNotEmpty == true ? district! : "-"},
      {"Road": roadId?.isNotEmpty == true ? roadId! : "-"},
      {"Reference No": referenceNo?.isNotEmpty == true ? referenceNo! : "-"},
    ];
  }
}
