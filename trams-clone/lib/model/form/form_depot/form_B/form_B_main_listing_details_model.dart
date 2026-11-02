// ignore_for_file: camel_case_types

import 'package:equatable/equatable.dart';
import 'package:tram/model/form/form_depot/main_listing/form_main_listing_details_model.dart';
import 'package:tram/utils/parsers_utils.dart';

class Form_B_MainListingDetailsModel extends Equatable {
  const Form_B_MainListingDetailsModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<Form_B_MainListingDetailsDataModel> data;

  Form_B_MainListingDetailsModel copyWith({
    String? httpStatus,
    List<Form_B_MainListingDetailsDataModel>? data,
  }) {
    return Form_B_MainListingDetailsModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory Form_B_MainListingDetailsModel.fromJson(Map<String, dynamic> json) {
    return Form_B_MainListingDetailsModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<Form_B_MainListingDetailsDataModel>.from(json["data"]!
              .map((x) => Form_B_MainListingDetailsDataModel.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class Form_B_MainListingDetailsDataModel extends FormMainListingDetails {
  Form_B_MainListingDetailsDataModel(
      {required this.inspectionDate,
      required this.projectName,
      required this.district,
      required this.roadId,
      required this.referenceNo,
      required this.riverName,
      required this.chainage,
      required this.structureCode,
      required this.gpsEasting,
      required this.gpsNorthing,
      required this.superstructure,
      required this.parapet,
      required this.bearing,
      required this.expansion,
      required this.noOfExpansion,
      required this.deck,
      required this.abutment,
      required this.pier,
      required this.status});

  String? inspectionDate;
  String? projectName;
  String? district;
  String? roadId;
  String? referenceNo;
  String? riverName;
  String? chainage;
  String? structureCode;
  String? gpsEasting;
  String? gpsNorthing;
  String? superstructure;
  String? parapet;
  String? bearing;
  String? expansion;
  String? noOfExpansion;
  String? deck;
  String? abutment;
  String? pier;
  String? status;

  factory Form_B_MainListingDetailsDataModel.fromJson(
      Map<String, dynamic> json) {
    return Form_B_MainListingDetailsDataModel(
      inspectionDate: ParsersUtils.parseToString(json["inspection_date"]),
      projectName: ParsersUtils.parseToString(json["ProjectName"]),
      district: ParsersUtils.parseToString(json["district"]),
      roadId: ParsersUtils.parseToString(json["road"]),
      referenceNo: ParsersUtils.parseToString(json["reference_no"]),
      riverName: ParsersUtils.parseToString(json["RiverName"]),
      chainage: ParsersUtils.parseToString(json["Chainage"]),
      structureCode: ParsersUtils.parseToString(json["StructureCode"]),
      gpsEasting: ParsersUtils.parseToString(json["GPS_Easting"]),
      gpsNorthing: ParsersUtils.parseToString(json["GPS_Northing"]),
      superstructure: ParsersUtils.parseToString(json["superstructure"]),
      parapet: ParsersUtils.parseToString(json["parapet"]),
      bearing: ParsersUtils.parseToString(json["bearing"]),
      expansion: ParsersUtils.parseToString(json["Expansion"]),
      noOfExpansion: ParsersUtils.parseToString(json["noOfExpansion"]),
      deck: ParsersUtils.parseToString(json["deck"]),
      abutment: ParsersUtils.parseToString(json["abutment"]),
      pier: ParsersUtils.parseToString(json["pier"]),
      status: ParsersUtils.parseToString(json["status"]),
    );
  }

  List<Object?> get props => [
        projectName,
        district,
        roadId,
        referenceNo,
        riverName,
        chainage,
        structureCode,
        gpsEasting,
        gpsNorthing,
        superstructure,
        parapet,
        bearing,
        expansion,
        noOfExpansion,
        deck,
        abutment,
        pier,
        status
      ];





  // FULL VERSION
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
      {"River Name": riverName?.isNotEmpty == true ? riverName! : "-"},
      {"Chainage": chainage?.isNotEmpty == true ? chainage! : "-"},
      {
        "Structure Code":
        structureCode?.isNotEmpty == true ? structureCode! : "-"
      },
      {"GPS Easting": gpsEasting?.isNotEmpty == true ? gpsEasting! : "-"},
      {"GPS Northing": gpsNorthing?.isNotEmpty == true ? gpsNorthing! : "-"},
      {
        "Superstructure":
        superstructure?.isNotEmpty == true ? superstructure! : "-"
      },
      {"Parapet": parapet?.isNotEmpty == true ? parapet! : "-"},
      {"Bearing": bearing?.isNotEmpty == true ? bearing! : "-"},
      {"Expansion": expansion?.isNotEmpty == true ? expansion! : "-"},
      {
        "Number of Expansions":
        noOfExpansion?.isNotEmpty == true ? noOfExpansion! : "-"
      },
      {"Deck": deck?.isNotEmpty == true ? deck! : "-"},
      {"Abutment": abutment?.isNotEmpty == true ? abutment! : "-"},
      {"Pier": pier?.isNotEmpty == true ? pier! : "-"},
      {"Status": status?.isNotEmpty == true ? status! : "-"},
    ];
  }

  // SUMMARY VERSION
  @override
  List<Map<String, String>> getKeyValuePairsInGeneral() {
    return [
      {"Project Name": projectName?.isNotEmpty == true ? projectName! : "-"},
      {"District": district?.isNotEmpty == true ? district! : "-"},
      {"Road": roadId?.isNotEmpty == true ? roadId! : "-"},
      {"Reference No": referenceNo?.isNotEmpty == true ? referenceNo! : "-"},
      {"River Name": riverName?.isNotEmpty == true ? riverName! : "-"},
    ];
  }
}
