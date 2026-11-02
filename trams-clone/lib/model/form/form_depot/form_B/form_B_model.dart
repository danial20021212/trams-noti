// ignore_for_file: file_names, must_be_immutable, camel_case_types
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:tram/model/form/form_depot/main_listing/inspection_detail_model.dart';
import 'package:tram/utils/parsers_utils.dart';

import '../common/severity_model.dart';

class Form_B_InspectionDetailsModel extends Equatable {
  const Form_B_InspectionDetailsModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<FormBModel> data;

  Form_B_InspectionDetailsModel copyWith({
    String? httpStatus,
    List<FormBModel>? data,
  }) {
    return Form_B_InspectionDetailsModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory Form_B_InspectionDetailsModel.fromJson(Map<String, dynamic> json) {
    return Form_B_InspectionDetailsModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<FormBModel>.from(
              json["data"]!.map((x) => FormBModel.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class FormBModel extends InspectionDetailModel {
  String? recID;
  String? parentID;
  String? inspectionDate;
  String? referenceNo;
  String? packageID;
  String? districtID;
  String? roadID;
  String? roadName;
  String? bridgeName;
  String? riverName;
  String? chainageKilometre;
  String? structureCode;
  String? gpsEasting;
  String? gpsNorting;
  int? btSuperstructureID;
  int? btParapetID;
  int? btBearingID;
  int? btExpansionID;
  int? btDeckID;
  int? btAbutmentID;
  int? btPierID;
  String? btNoOfExpansion;
  String? stLaneWidth;
  String? stNoOfLane;
  String? stSpanLength;
  String? stNoOfSpan;
  String? stBridgeLength;
  String? stMedian;
  String? stBridgeWidth;
  String? stWalkway;
  List<String>? p1Materials;
  String? p1MaterialOther;
  String? p1Distress;
  String? p1DistressOther;
  String? p1Severity;
  List<String>? p2Materials;
  String? p2MaterialOther;
  String? p2Distress;
  String? p2DistressOther;
  String? p2Severity;
  List<String>? p3Materials;
  String? p3MaterialOther;
  String? p3Distress;
  String? p3DistressOther;
  String? p3Severity;
  List<String>? p4Materials;
  String? p4MaterialOther;
  String? p4Distress;
  String? p4DistressOther;
  String? p4Severity;
  List<String>? p5Materials;
  String? p5MaterialOther;
  String? p5Distress;
  String? p5DistressOther;
  String? p5Severity;
  List<String>? s1Materials;
  String? s1MaterialOther;
  String? s1Distress;
  String? s1DistressOther;
  String? s1Severity;
  List<String>? s2Materials;
  String? s2MaterialOther;
  String? s2Distress;
  String? s2DistressOther;
  String? s2Severity;
  List<String>? s3Materials;
  String? s3MaterialOther;
  String? s3Distress;
  String? s3DistressOther;
  String? s3Severity;
  List<String>? s4Materials;
  String? s4MaterialOther;
  String? s4Distress;
  String? s4DistressOther;
  String? s4Severity;
  List<String>? s5Materials;
  String? s5MaterialOther;
  String? s5Distress;
  String? s5DistressOther;
  String? s5Severity;
  List<String>? s6Materials;
  String? s6MaterialOther;
  String? s6Distress;
  String? s6DistressOther;
  String? s6Severity;
  List<String>? s7Materials;
  String? s7MaterialOther;
  String? s7Distress;
  String? s7DistressOther;
  String? s7Severity;

  FormBModel(
      {this.recID,
      this.parentID,
      this.inspectionDate,
      this.packageID,
      this.districtID,
      this.roadID,
      this.roadName,
      this.bridgeName,
      this.referenceNo,
      this.chainageKilometre,
      this.structureCode,
      this.riverName,
      this.gpsEasting,
      this.gpsNorting,
      this.btSuperstructureID,
      this.btParapetID,
      this.btBearingID,
      this.btExpansionID,
      this.btDeckID,
      this.btAbutmentID,
      this.btPierID,
      this.btNoOfExpansion,
      this.stLaneWidth,
      this.stNoOfLane,
      this.stSpanLength,
      this.stNoOfSpan,
      this.stBridgeLength,
      this.stMedian,
      this.stBridgeWidth,
      this.stWalkway,
      this.p1Materials,
      this.p1MaterialOther,
      this.p1DistressOther,
      this.p1Distress,
      this.p1Severity,
      this.p2Materials,
      this.p2MaterialOther,
      this.p2Distress,
      this.p2DistressOther,
      this.p2Severity,
      this.p3Materials,
      this.p3MaterialOther,
      this.p3Distress,
      this.p3DistressOther,
      this.p3Severity,
      this.p4Materials,
      this.p4MaterialOther,
      this.p4Distress,
      this.p4DistressOther,
      this.p4Severity,
      this.p5Materials,
      this.p5MaterialOther,
      this.p5Distress,
      this.p5DistressOther,
      this.p5Severity,
      this.s1Materials,
      this.s1MaterialOther,
      this.s1Distress,
      this.s1DistressOther,
      this.s1Severity,
      this.s2Materials,
      this.s2MaterialOther,
      this.s2Distress,
      this.s2DistressOther,
      this.s2Severity,
      this.s3Materials,
      this.s3MaterialOther,
      this.s3Distress,
      this.s3DistressOther,
      this.s3Severity,
      this.s4Materials,
      this.s4MaterialOther,
      this.s4Distress,
      this.s4DistressOther,
      this.s4Severity,
      this.s5Materials,
      this.s5MaterialOther,
      this.s5Distress,
      this.s5DistressOther,
      this.s5Severity,
      this.s6Materials,
      this.s6MaterialOther,
      this.s6Distress,
      this.s6DistressOther,
      this.s6Severity,
      this.s7Materials,
      this.s7MaterialOther,
      this.s7Distress,
      this.s7DistressOther,
      this.s7Severity});

  factory FormBModel.fromJson(Map<String, dynamic> json) {
    return FormBModel(
      recID: ParsersUtils.parseToString(json['recID']),
      parentID: ParsersUtils.parseToString(json['parentID']),
      inspectionDate: ParsersUtils.parseToString(json['inspection_date']),
      referenceNo: ParsersUtils.parseToString(json['referenceNo']),
      packageID: ParsersUtils.parseToString(json['packageId']),
      districtID: ParsersUtils.parseToString(json['districtId']),
      roadID: ParsersUtils.parseToString(json['roadId']),
      roadName: ParsersUtils.parseToString(json['RoadName']),
      riverName: ParsersUtils.parseToString(json['RiverName']),
      bridgeName: ParsersUtils.parseToString(
          json['bridgeName'] ?? json['BridgeName'] ?? json['RiverName']),
      chainageKilometre: ParsersUtils.parseToString(json['Chainage']),
      structureCode: ParsersUtils.parseToString(json['StructureCode']),
      gpsEasting: ParsersUtils.parseToString(json['GPS_Easting']),
      gpsNorting: ParsersUtils.parseToString(json['GPS_Northing']),
      btSuperstructureID: json['bt_superstructure'] != null
          ? int.tryParse(json['bt_superstructure'].toString())
          : null,
      btParapetID: json['bt_parapet'] != null
          ? int.tryParse(json['bt_parapet'].toString())
          : null,
      btBearingID: json['bt_bearing'] != null
          ? int.tryParse(json['bt_bearing'].toString())
          : null,
      btExpansionID: json['bt_expansion'] != null
          ? int.tryParse(json['bt_expansion'].toString())
          : null,
      btDeckID: json['bt_deck'] != null
          ? int.tryParse(json['bt_deck'].toString())
          : null,
      btAbutmentID: json['bt_abutment'] != null
          ? int.tryParse(json['bt_abutment'].toString())
          : null,
      btPierID: json['bt_pier'] != null
          ? int.tryParse(json['bt_pier'].toString())
          : null,
      btNoOfExpansion: ParsersUtils.parseToString(json['bt_noOfExpansion']),

      // --- Structure details ---
      stLaneWidth: ParsersUtils.parseToString(json['st_laneWidth']),
      stNoOfLane: ParsersUtils.parseToString(json['st_NoOfLane']),
      stSpanLength: ParsersUtils.parseToString(json['st_spanLength']),
      stNoOfSpan: ParsersUtils.parseToString(json['st_NoOfSpan']),
      stBridgeLength: ParsersUtils.parseToString(json['st_BridgeLength']),
      stMedian: ParsersUtils.parseToString(json['st_median']),
      stBridgeWidth: ParsersUtils.parseToString(json['st_bridgeWidth']),
      stWalkway: ParsersUtils.parseToString(json['st_walkway']),

      // --- Pier sections (p1-p5) ---
      p1Materials: ParsersUtils.parseToStringList(json['p1_material']),
      p1MaterialOther: ParsersUtils.parseToString(json['p1_material_other']),
      p1Distress: ParsersUtils.parseToString(json['p1_distress']),
      p1DistressOther: ParsersUtils.parseToString(json['p1_other_distress']),
      p1Severity: ParsersUtils.parseToString(json['p1_severity']),

      p2Materials: ParsersUtils.parseToStringList(json['p2_material']),
      p2MaterialOther: ParsersUtils.parseToString(json['p2_material_other']),
      p2Distress: ParsersUtils.parseToString(json['p2_distress']),
      p2DistressOther: ParsersUtils.parseToString(json['p2_other_distress']),
      p2Severity: ParsersUtils.parseToString(json['p2_severity']),

      p3Materials: ParsersUtils.parseToStringList(json['p3_material']),
      p3MaterialOther: ParsersUtils.parseToString(json['p3_material_other']),
      p3Distress: ParsersUtils.parseToString(json['p3_distress']),
      p3DistressOther: ParsersUtils.parseToString(json['p3_other_distress']),
      p3Severity: ParsersUtils.parseToString(json['p3_severity']),

      p4Materials: ParsersUtils.parseToStringList(json['p4_material']),
      p4MaterialOther: ParsersUtils.parseToString(json['p4_material_other']),
      p4Distress: ParsersUtils.parseToString(json['p4_distress']),
      p4DistressOther: ParsersUtils.parseToString(json['p4_other_distress']),
      p4Severity: ParsersUtils.parseToString(json['p4_severity']),

      p5Materials: ParsersUtils.parseToStringList(json['p5_material']),
      p5MaterialOther: ParsersUtils.parseToString(json['p5_material_other']),
      p5Distress: ParsersUtils.parseToString(json['p5_distress']),
      p5DistressOther: ParsersUtils.parseToString(json['p5_other_distress']),
      p5Severity: ParsersUtils.parseToString(json['p5_severity']),

      // --- Span sections (s1-s7) ---
      s1Materials: ParsersUtils.parseToStringList(json['s1_material']),
      s1MaterialOther: ParsersUtils.parseToString(json['s1_material_other']),
      s1Distress: ParsersUtils.parseToString(json['s1_distress']),
      s1DistressOther: ParsersUtils.parseToString(json['s1_other_distress']),
      s1Severity: ParsersUtils.parseToString(json['s1_severity']),

      s2Materials: ParsersUtils.parseToStringList(json['s2_material']),
      s2MaterialOther: ParsersUtils.parseToString(json['s2_material_other']),
      s2Distress: ParsersUtils.parseToString(json['s2_distress']),
      s2DistressOther: ParsersUtils.parseToString(json['s2_other_distress']),
      s2Severity: ParsersUtils.parseToString(json['s2_severity']),

      s3Materials: ParsersUtils.parseToStringList(json['s3_material']),
      s3MaterialOther: ParsersUtils.parseToString(json['s3_material_other']),
      s3Distress: ParsersUtils.parseToString(json['s3_distress']),
      s3DistressOther: ParsersUtils.parseToString(json['s3_other_distress']),
      s3Severity: ParsersUtils.parseToString(json['s3_severity']),

      s4Materials: ParsersUtils.parseToStringList(json['s4_material']),
      s4MaterialOther: ParsersUtils.parseToString(json['s4_material_other']),
      s4Distress: ParsersUtils.parseToString(json['s4_distress']),
      s4DistressOther: ParsersUtils.parseToString(json['s4_other_distress']),
      s4Severity: ParsersUtils.parseToString(json['s4_severity']),

      s5Materials: ParsersUtils.parseToStringList(json['s5_material']),
      s5MaterialOther: ParsersUtils.parseToString(json['s5_material_other']),
      s5Distress: ParsersUtils.parseToString(json['s5_distress']),
      s5DistressOther: ParsersUtils.parseToString(json['s5_other_distress']),
      s5Severity: ParsersUtils.parseToString(json['s5_severity']),

      s6Materials: ParsersUtils.parseToStringList(json['s6_material']),
      s6MaterialOther: ParsersUtils.parseToString(json['s6_material_other']),
      s6Distress: ParsersUtils.parseToString(json['s6_distress']),
      s6DistressOther: ParsersUtils.parseToString(json['s6_other_distress']),
      s6Severity: ParsersUtils.parseToString(json['s6_severity']),

      s7Materials: ParsersUtils.parseToStringList(json['s7_material']),
      s7MaterialOther: ParsersUtils.parseToString(json['s7_material_other']),
      s7Distress: ParsersUtils.parseToString(json['s7_distress']),
      s7DistressOther: ParsersUtils.parseToString(json['s7_other_distress']),
      s7Severity: ParsersUtils.parseToString(json['s7_severity']),
    );
  }

  Map<String, dynamic> toJson() {
    // Helper function: returns "1" if the severity is null or empty
    String formatSeverity(String? severity) {
      if (severity == null || severity.trim().isEmpty) {
        return "1";
      }
      return severity;
    }

    // Helper function: returns "No Distress" if the distress is null or empty
    String formatDistress(String? distress) {
      if (distress == null || distress.trim().isEmpty) {
        return "ND";
      }
      return distress;
    }

    return {
      'recID': recID,
      'parentID': parentID,
      'inspection_date': inspectionDate,
      'referenceNo': referenceNo,
      'packageId': packageID,
      'districtId': districtID,
      'roadId': roadID,
      'RoadName': roadName,
      'RiverName': riverName,
      'Chainage': chainageKilometre,
      'StructureCode': structureCode,
      'GPS_Easting': gpsEasting,
      'GPS_Northing': gpsNorting,
      'bt_superstructure': btSuperstructureID?.toString(),
      'bt_parapet': btParapetID?.toString(),
      'bt_bearing': btBearingID?.toString(),
      'bt_expansion': btExpansionID?.toString(),
      'bt_deck': btDeckID?.toString(),
      'bt_abutment': btAbutmentID?.toString(),
      'bt_pier': btPierID?.toString(),
      'bt_noOfExpansion': btNoOfExpansion,
      'st_laneWidth': stLaneWidth,
      'st_NoOfLane': stNoOfLane,
      'st_spanLength': stSpanLength,
      'st_NoOfSpan': stNoOfSpan,
      'st_BridgeLength': stBridgeLength,
      'st_median': stMedian,
      'st_bridgeWidth': stBridgeWidth,
      'st_walkway': stWalkway,
      'p1_material': p1Materials?.join(',') ?? "",
      'p1_material_other': p1MaterialOther,
      'p1_distress': formatDistress(p1Distress),
      'p1_other_distress': p1DistressOther,
      'p1_severity': formatSeverity(p1Severity),
      'p2_material': p2Materials?.join(',') ?? "",
      'p2_material_other': p2MaterialOther,
      'p2_distress': formatDistress(p2Distress),
      'p2_other_distress': p2DistressOther,
      'p2_severity': formatSeverity(p2Severity),
      'p3_material': p3Materials?.join(',') ?? "",
      'p3_material_other': p3MaterialOther,
      'p3_distress': formatDistress(p3Distress),
      'p3_other_distress': p3DistressOther,
      'p3_severity': formatSeverity(p3Severity),
      'p4_material': p4Materials?.join(',') ?? "",
      'p4_material_other': p4MaterialOther,
      'p4_distress': formatDistress(p4Distress),
      'p4_other_distress': p4DistressOther,
      'p4_severity': formatSeverity(p4Severity),
      'p5_material': p5Materials?.join(',') ?? "",
      'p5_material_other': p5MaterialOther,
      'p5_distress': formatDistress(p5Distress),
      'p5_other_distress': p5DistressOther,
      'p5_severity': formatSeverity(p5Severity),
      's1_material': s1Materials?.join(',') ?? "",
      's1_material_other': s1MaterialOther,
      's1_distress': formatDistress(s1Distress),
      's1_other_distress': s1DistressOther,
      's1_severity': formatSeverity(s1Severity),
      's2_material': s2Materials?.join(',') ?? "",
      's2_material_other': s2MaterialOther,
      's2_distress': formatDistress(s2Distress),
      's2_other_distress': s2DistressOther,
      's2_severity': formatSeverity(s2Severity),
      's3_material': s3Materials?.join(',') ?? "",
      's3_material_other': s3MaterialOther,
      's3_distress': formatDistress(s3Distress),
      's3_other_distress': s3DistressOther,
      's3_severity': formatSeverity(s3Severity),
      's4_material': s4Materials?.join(',') ?? "",
      's4_material_other': s4MaterialOther,
      's4_distress': formatDistress(s4Distress),
      's4_other_distress': s4DistressOther,
      's4_severity': formatSeverity(s4Severity),
      's5_material': s5Materials?.join(',') ?? "",
      's5_material_other': s5MaterialOther,
      's5_distress': formatDistress(s5Distress),
      's5_other_distress': s5DistressOther,
      's5_severity': formatSeverity(s5Severity),
      's6_material': s6Materials?.join(',') ?? "",
      's6_material_other': s6MaterialOther,
      's6_distress': formatDistress(s6Distress),
      's6_other_distress': s6DistressOther,
      's6_severity': formatSeverity(s6Severity),
      's7_material': s7Materials?.join(',') ?? "",
      's7_material_other': s7MaterialOther,
      's7_distress': formatDistress(s7Distress),
      's7_other_distress': s7DistressOther,
      's7_severity': formatSeverity(s7Severity),
    };
  }

  Map<String, dynamic> toApiSubmitJson() {
    // Helper function: returns "1" if the severity is null or empty
    String formatSeverity(String? severity) {
      if (severity == null || severity.trim().isEmpty) {
        return "1";
      }
      return severity;
    }

    // Helper function: returns "ND" if the distress is null or empty
    String formatDistress(String? distress) {
      if (distress == null || distress.trim().isEmpty) {
        return "ND";
      }
      return distress;
    }

    return {
      'parentID': parentID,
      'inspection_date': inspectionDate,
      'p1_material': p1Materials?.join(',') ?? "",
      'p1_material_other': p1MaterialOther,
      'p1_distress': formatDistress(p1Distress),
      'p1_other_distress': p1DistressOther,
      'p1_severity': formatSeverity(p1Severity),
      'p2_material': p2Materials?.join(',') ?? "",
      'p2_material_other': p2MaterialOther,
      'p2_distress': formatDistress(p2Distress),
      'p2_other_distress': p2DistressOther,
      'p2_severity': formatSeverity(p2Severity),
      'p3_material': p3Materials?.join(',') ?? "",
      'p3_material_other': p3MaterialOther,
      'p3_distress': formatDistress(p3Distress),
      'p3_other_distress': p3DistressOther,
      'p3_severity': formatSeverity(p3Severity),
      'p4_material': p4Materials?.join(',') ?? "",
      'p4_material_other': p4MaterialOther,
      'p4_distress': formatDistress(p4Distress),
      'p4_other_distress': p4DistressOther,
      'p4_severity': formatSeverity(p4Severity),
      'p5_material': p5Materials?.join(',') ?? "",
      'p5_material_other': p5MaterialOther,
      'p5_distress': formatDistress(p5Distress),
      'p5_other_distress': p5DistressOther,
      'p5_severity': formatSeverity(p5Severity),
      's1_material': s1Materials?.join(',') ?? "",
      's1_material_other': s1MaterialOther,
      's1_distress': formatDistress(s1Distress),
      's1_other_distress': s1DistressOther,
      's1_severity': formatSeverity(s1Severity),
      's2_material': s2Materials?.join(',') ?? "",
      's2_material_other': s2MaterialOther,
      's2_distress': formatDistress(s2Distress),
      's2_other_distress': s2DistressOther,
      's2_severity': formatSeverity(s2Severity),
      's3_material': s3Materials?.join(',') ?? "",
      's3_material_other': s3MaterialOther,
      's3_distress': formatDistress(s3Distress),
      's3_other_distress': s3DistressOther,
      's3_severity': formatSeverity(s3Severity),
      's4_material': s4Materials?.join(',') ?? "",
      's4_material_other': s4MaterialOther,
      's4_distress': formatDistress(s4Distress),
      's4_other_distress': s4DistressOther,
      's4_severity': formatSeverity(s4Severity),
      's5_material': s5Materials?.join(',') ?? "",
      's5_material_other': s5MaterialOther,
      's5_distress': formatDistress(s5Distress),
      's5_other_distress': s5DistressOther,
      's5_severity': formatSeverity(s5Severity),
      's6_material': s6Materials?.join(',') ?? "",
      's6_material_other': s6MaterialOther,
      's6_distress': formatDistress(s6Distress),
      's6_other_distress': s6DistressOther,
      's6_severity': formatSeverity(s6Severity),
      's7_material': s7Materials?.join(',') ?? "",
      's7_material_other': s7MaterialOther,
      's7_distress': formatDistress(s7Distress),
      's7_other_distress': s7DistressOther,
      's7_severity': formatSeverity(s7Severity),
    };
  }

  Map<String, dynamic> toDraftJson() {
    // Helper function: returns "1" if the severity is null or empty
    String formatSeverity(String? severity) {
      if (severity == null || severity.trim().isEmpty) {
        return "1";
      }
      return severity;
    }

    // Helper function: returns "ND" if the distress is null or empty
    String formatDistress(String? distress) {
      if (distress == null || distress.trim().isEmpty) {
        return "ND";
      }
      return distress;
    }

    return {
      'parentID': parentID,
      'inspection_date': inspectionDate,
      'referenceNo': referenceNo,
      'packageId': packageID,
      'districtId': districtID,
      'roadId': roadID,
      'bridgeName': bridgeName,
      'p1_material': p1Materials?.join(',') ?? "",
      'p1_material_other': p1MaterialOther,
      'p1_distress': formatDistress(p1Distress),
      'p1_other_distress': p1DistressOther,
      'p1_severity': formatSeverity(p1Severity),
      'p2_material': p2Materials?.join(',') ?? "",
      'p2_material_other': p2MaterialOther,
      'p2_distress': formatDistress(p2Distress),
      'p2_other_distress': p2DistressOther,
      'p2_severity': formatSeverity(p2Severity),
      'p3_material': p3Materials?.join(',') ?? "",
      'p3_material_other': p3MaterialOther,
      'p3_distress': formatDistress(p3Distress),
      'p3_other_distress': p3DistressOther,
      'p3_severity': formatSeverity(p3Severity),
      'p4_material': p4Materials?.join(',') ?? "",
      'p4_material_other': p4MaterialOther,
      'p4_distress': formatDistress(p4Distress),
      'p4_other_distress': p4DistressOther,
      'p4_severity': formatSeverity(p4Severity),
      'p5_material': p5Materials?.join(',') ?? "",
      'p5_material_other': p5MaterialOther,
      'p5_distress': formatDistress(p5Distress),
      'p5_other_distress': p5DistressOther,
      'p5_severity': formatSeverity(p5Severity),
      's1_material': s1Materials?.join(',') ?? "",
      's1_material_other': s1MaterialOther,
      's1_distress': formatDistress(s1Distress),
      's1_other_distress': s1DistressOther,
      's1_severity': formatSeverity(s1Severity),
      's2_material': s2Materials?.join(',') ?? "",
      's2_material_other': s2MaterialOther,
      's2_distress': formatDistress(s2Distress),
      's2_other_distress': s2DistressOther,
      's2_severity': formatSeverity(s2Severity),
      's3_material': s3Materials?.join(',') ?? "",
      's3_material_other': s3MaterialOther,
      's3_distress': formatDistress(s3Distress),
      's3_other_distress': s3DistressOther,
      's3_severity': formatSeverity(s3Severity),
      's4_material': s4Materials?.join(',') ?? "",
      's4_material_other': s4MaterialOther,
      's4_distress': formatDistress(s4Distress),
      's4_other_distress': s4DistressOther,
      's4_severity': formatSeverity(s4Severity),
      's5_material': s5Materials?.join(',') ?? "",
      's5_material_other': s5MaterialOther,
      's5_distress': formatDistress(s5Distress),
      's5_other_distress': s5DistressOther,
      's5_severity': formatSeverity(s5Severity),
      's6_material': s6Materials?.join(',') ?? "",
      's6_material_other': s6MaterialOther,
      's6_distress': formatDistress(s6Distress),
      's6_other_distress': s6DistressOther,
      's6_severity': formatSeverity(s6Severity),
      's7_material': s7Materials?.join(',') ?? "",
      's7_material_other': s7MaterialOther,
      's7_distress': formatDistress(s7Distress),
      's7_other_distress': s7DistressOther,
      's7_severity': formatSeverity(s7Severity),
    };
  }

  static final List<SeverityModel> severityModel = [
    SeverityModel(
      level: "1",
      description: const Text("Excellent Condition"),
    ),
    SeverityModel(
      level: "2",
      description: const Text("Good Condition"),
    ),
    SeverityModel(
      level: "3",
      description: const Text("Fair Condition"),
    ),
    SeverityModel(
      level: "4",
      description: const Text("Poor Condition"),
    ),
    SeverityModel(
      level: "5",
      description: const Text("Critical"),
    )
  ];

  @override
  List<InspectionGroup> getInspectionGroups() {
    return [
      // Group 1: Primary Members
      InspectionGroup(
        headerTitle: "PRIMARY MEMBERS (P1 - P5)",
        items: [
          InspectionSectionData.create('P1', 'Abutment Walls, Foundations',
              p1Materials, p1Distress, p1Severity),
          InspectionSectionData.create(
              'P2',
              'Piers, Connection of Primary Components',
              p2Materials,
              p2Distress,
              p2Severity),
          InspectionSectionData.create(
              'P3',
              'Bearing, Bearing Seats, Diaphragms',
              p3Materials,
              p3Distress,
              p3Severity),
          InspectionSectionData.create('P4', 'Beams, Girders, Trusses, Arches',
              p4Materials, p4Distress, p4Severity),
          InspectionSectionData.create(
              'P5', 'Deck Slab, Pavement', p5Materials, p5Distress, p5Severity),
        ],
      ),

      // Group 2: Secondary Members
      InspectionGroup(
        headerTitle: "SECONDARY MEMBERS (S1 - S8)",
        items: [
          InspectionSectionData.create('S1', 'Signboard, Utilities',
              s1Materials, s1Distress, s1Severity),
          InspectionSectionData.create(
              'S2', 'Waterway', s2Materials, s2Distress, s2Severity),
          InspectionSectionData.create('S3', 'Drain Water Down Pipe, Drainage',
              s3Materials, s3Distress, s3Severity),
          InspectionSectionData.create(
              'S4', 'Parapet, Railing', s4Materials, s4Distress, s4Severity),
          InspectionSectionData.create('S5', 'Kerb, Sidewalks, Approaches',
              s5Materials, s5Distress, s5Severity),
          InspectionSectionData.create(
              'S6', 'Expansion Joint', s6Materials, s6Distress, s6Severity),
          InspectionSectionData.create(
              'S7',
              'Slope Protection, Retaining Walls',
              s7Materials,
              s7Distress,
              s7Severity),
          InspectionSectionData.create(
              'S8', 'Others', [], s7Distress, s7Severity),
        ],
      ),
    ];
  }
}

class InspectionGroup {
  final String headerTitle;
  final List<dynamic> items;

  InspectionGroup({
    required this.headerTitle,
    required this.items,
  });
}

class InspectionSectionData {
  final String id;
  final String title;
  final List<String> materials;
  final String distress;
  final String severity;

  InspectionSectionData({
    required this.id,
    required this.title,
    required this.materials,
    required this.distress,
    required this.severity,
  });

  static InspectionSectionData create(
    String id,
    String title,
    List<String>? materials,
    String? distress,
    String? severity,
  ) {
    return InspectionSectionData(
      id: id,
      title: '$title ($id)', // Formats as "Abutment Walls (P1)"
      materials: materials ?? [],
      distress: (distress == null || distress.isEmpty) ? "-" : distress,
      severity: (severity == null || severity.isEmpty) ? "-" : severity,
    );
  }
}
