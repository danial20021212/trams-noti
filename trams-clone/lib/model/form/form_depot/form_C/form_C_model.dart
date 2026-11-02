// ignore_for_file: file_names, camel_case_types
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tram/model/form/form_depot/common/severity_model.dart';
import 'package:tram/utils/parsers_utils.dart';

import '../main_listing/inspection_detail_model.dart';

class Form_C_InspectionDetailsModel extends Equatable {
  const Form_C_InspectionDetailsModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<FormCModel> data;

  Form_C_InspectionDetailsModel copyWith({
    String? httpStatus,
    List<FormCModel>? data,
  }) {
    return Form_C_InspectionDetailsModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory Form_C_InspectionDetailsModel.fromJson(Map<String, dynamic> json) {
    return Form_C_InspectionDetailsModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<FormCModel>.from(
          json["data"]!.map((x) => FormCModel.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
    httpStatus,
    data,
  ];
}

class FormCModel extends InspectionDetailModel {
  String? accessToken;
  String? username;
  String? recID;
  String? inspectionDate;
  String? referenceNo;
  String? packageId;
  String? districtId;
  String? roadId;
  String? chainage;
  String? structureCode;
  String? gpsEasting;
  String? gpsNorthing;
  String? parkingPosition;
  String? accessCondition;
  String? potentialHazard;
  String? finishedRoadLevel;
  String? catchmentArea;
  String? designFlow;
  String? precastInSitu;
  String? barrelNumberSize;
  String? inletLevel;
  String? outletLevel;
  String? culvertSkew;
  String? culvertLength;
  List<String>? culvertType;
  List<String>? culvertMaterial;
  List<String>? inletStructure;
  List<String>? outletStructure;

  String? culvertMarkerDistress;
  String? culvertMarkerSeverity;

  String? waterwayDistress;
  String? waterwayDistressOther;
  String? waterwaySeverity;

  String? embankmentDistress;
  String? embankmentDistressOther;
  String? embankmentSeverity;

  String? headwallInletDistress;
  String? headwallInletDistressOther;
  String? headwallInletSeverity;

  String? wingwallInletDistress;
  String? wingwallInletDistressOther;
  String? wingwallInletSeverity;

  String? apronInletDistress;
  String? apronInletDistressOther;
  String? apronInletSeverity;

  String? riprapInletDistress;
  String? riprapInletDistressOther;
  String? riprapInletSeverity;

  String? headwallOutletDistress;
  String? headwallOutletDistressOther;
  String? headwallOutletSeverity;

  String? wingwallOutletDistress;
  String? wingwallOutletDistressOther;
  String? wingwallOutletSeverity;

  String? apronOutletDistress;
  String? apronOutletDistressOther;
  String? apronOutletSeverity;

  String? riprapOutletDistress;
  String? riprapOutletDistressOther;
  String? riprapOutletSeverity;

  String? barrel1Distress;
  String? barrel1DistressOther;
  String? barrel1Severity;

  String? barrel2Distress;
  String? barrel2DistressOther;
  String? barrel2Severity;

  String? barrel3Distress;
  String? barrel3DistressOther;
  String? barrel3Severity;

  String? barrel4Distress;
  String? barrel4DistressOther;
  String? barrel4Severity;

  String? culvertApproachConditionDistress;
  String? culvertApproachConditionDistressOther;
  String? culvertApproachConditionSeverity;

  String? investigation;

  FormCModel({
    this.accessToken,
    this.username,
    this.recID,
    this.inspectionDate,
    this.referenceNo,
    this.packageId,
    this.districtId,
    this.roadId,
    this.chainage,
    this.structureCode,
    this.gpsEasting,
    this.gpsNorthing,
    this.parkingPosition,
    this.accessCondition,
    this.potentialHazard,
    this.finishedRoadLevel,
    this.catchmentArea,
    this.designFlow,
    this.precastInSitu,
    this.barrelNumberSize,
    this.inletLevel,
    this.outletLevel,
    this.culvertSkew,
    this.culvertLength,
    this.culvertType,
    this.culvertMaterial,
    this.inletStructure,
    this.outletStructure,
    this.culvertMarkerDistress,
    this.culvertMarkerSeverity,
    this.waterwayDistress,
    this.waterwayDistressOther,
    this.waterwaySeverity,
    this.embankmentDistress,
    this.embankmentDistressOther,
    this.embankmentSeverity,
    this.headwallInletDistress,
    this.headwallInletDistressOther,
    this.headwallInletSeverity,
    this.wingwallInletDistress,
    this.wingwallInletDistressOther,
    this.wingwallInletSeverity,
    this.apronInletDistress,
    this.apronInletDistressOther,
    this.apronInletSeverity,
    this.riprapInletDistress,
    this.riprapInletDistressOther,
    this.riprapInletSeverity,
    this.headwallOutletDistress,
    this.headwallOutletDistressOther,
    this.headwallOutletSeverity,
    this.wingwallOutletDistress,
    this.wingwallOutletDistressOther,
    this.wingwallOutletSeverity,
    this.apronOutletDistress,
    this.apronOutletDistressOther,
    this.apronOutletSeverity,
    this.riprapOutletDistress,
    this.riprapOutletDistressOther,
    this.riprapOutletSeverity,
    this.barrel1Distress,
    this.barrel1DistressOther,
    this.barrel1Severity,
    this.barrel2Distress,
    this.barrel2DistressOther,
    this.barrel2Severity,
    this.barrel3Distress,
    this.barrel3DistressOther,
    this.barrel3Severity,
    this.barrel4Distress,
    this.barrel4DistressOther,
    this.barrel4Severity,
      this.culvertApproachConditionDistress,
    this.culvertApproachConditionDistressOther,
    this.culvertApproachConditionSeverity,
    this.investigation,
  });

  factory FormCModel.fromJson(Map<String, dynamic> json) {
    //if got "57" then "YES" else if got "58" then "NO" else ""
    String conditionYesOrNo(String key) => key == "57"
        ? "YES"
        : key == "58"
        ? "NO"
        : "";

    return FormCModel(
      accessToken: ParsersUtils.parseToString(json['access_token']),
      username: ParsersUtils.parseToString(json['username']),
      recID: ParsersUtils.parseToString(json['recID']),
      inspectionDate: ParsersUtils.parseToString(json['inspection_date']),
      referenceNo: ParsersUtils.parseToString(json['referenceNo']),
      packageId:
      ParsersUtils.parseToString(json['packageId'] ?? json['packageID']),
      districtId:
      ParsersUtils.parseToString(json['districtId'] ?? json['districtID']),
      roadId: ParsersUtils.parseToString(json['roadId'] ?? json['roadID']),
      chainage: ParsersUtils.parseToString(json['Chainage']),
      structureCode: ParsersUtils.parseToString(json['StructureCode']),
      gpsEasting: ParsersUtils.parseToString(json['GPS_Easting']),
      gpsNorthing: ParsersUtils.parseToString(json['GPS_Northing']),
      culvertLength: ParsersUtils.parseToString(json['CulvertLength']),
      culvertType: ParsersUtils.parseToStringList(json['CulvertType']),
      culvertMaterial: ParsersUtils.parseToStringList(json['CulvertMaterial']),
      finishedRoadLevel: ParsersUtils.parseToString(json['FinishedRoadLevel']),
      catchmentArea: ParsersUtils.parseToString(json['CatchmentArea']),
      designFlow: ParsersUtils.parseToString(json['DesignFlow']),
      precastInSitu: ParsersUtils.parseToString(json['Precast_In_situ']),
      barrelNumberSize: ParsersUtils.parseToString(json['BarrelNumber_Size']),
      inletLevel: ParsersUtils.parseToString(json['InletLevel']),
      outletLevel: ParsersUtils.parseToString(json['OutletLevel']),
      culvertSkew: ParsersUtils.parseToString(json['CulvertSkew']),
      inletStructure: ParsersUtils.parseToStringList(json['InletStructure']),
      outletStructure: ParsersUtils.parseToStringList(json['OutletStructure']),
      parkingPosition: conditionYesOrNo(json['ParkingPosition'] ?? ""),
      accessCondition: conditionYesOrNo(json['Accessibility'] ?? ""),
      potentialHazard: conditionYesOrNo(json['PotentialHazard'] ?? ""),

      culvertMarkerDistress: ParsersUtils.parseToString(json['A1_Distress']),
      culvertMarkerSeverity: ParsersUtils.parseToString(json['A1_Severity']),

      waterwayDistress: ParsersUtils.parseToString(json['A2_Distress']),
      waterwayDistressOther: ParsersUtils.parseToString(json['A2_Distress_Other']),
      waterwaySeverity: ParsersUtils.parseToString(json['A2_Severity']),

      embankmentDistress: ParsersUtils.parseToString(json['B2_Distress']),
      embankmentDistressOther: ParsersUtils.parseToString(json['B2_Distress_Other']),
      embankmentSeverity: ParsersUtils.parseToString(json['B2_Severity']),

      headwallInletDistress: ParsersUtils.parseToString(json['A3_Distress']),
      headwallInletDistressOther: ParsersUtils.parseToString(json['A3_Distress_Other']),
      headwallInletSeverity: ParsersUtils.parseToString(json['A3_Severity']),

      wingwallInletDistress: ParsersUtils.parseToString(json['B3_Distress']),
      wingwallInletDistressOther: ParsersUtils.parseToString(json['B3_Distress_Other']),
      wingwallInletSeverity: ParsersUtils.parseToString(json['B3_Severity']),

      apronInletDistress: ParsersUtils.parseToString(json['C3_Distress']),
      apronInletDistressOther: ParsersUtils.parseToString(json['C3_Distress_Other']),
      apronInletSeverity: ParsersUtils.parseToString(json['C3_Severity']),

      riprapInletDistress: ParsersUtils.parseToString(json['D3_Distress']),
      riprapInletDistressOther: ParsersUtils.parseToString(json['D3_Distress_Other']),
      riprapInletSeverity: ParsersUtils.parseToString(json['D3_Severity']),

      headwallOutletDistress: ParsersUtils.parseToString(json['E3_Distress']),
      headwallOutletDistressOther: ParsersUtils.parseToString(json['E3_Distress_Other']),
      headwallOutletSeverity: ParsersUtils.parseToString(json['E3_Severity']),

      wingwallOutletDistress: ParsersUtils.parseToString(json['F3_Distress']),
      wingwallOutletDistressOther: ParsersUtils.parseToString(json['F3_Distress_Other']),
      wingwallOutletSeverity: ParsersUtils.parseToString(json['F3_Severity']),

      apronOutletDistress: ParsersUtils.parseToString(json['G3_Distress']),
      apronOutletDistressOther: ParsersUtils.parseToString(json['G3_Distress_Other']),
      apronOutletSeverity: ParsersUtils.parseToString(json['G3_Severity']),

      riprapOutletDistress: ParsersUtils.parseToString(json['H3_Distress']),
      riprapOutletDistressOther: ParsersUtils.parseToString(json['H3_Distress_Other']),
      riprapOutletSeverity: ParsersUtils.parseToString(json['H3_Severity']),

      barrel1Distress: ParsersUtils.parseToString(json['A4_Distress']),
      barrel1DistressOther: ParsersUtils.parseToString(json['A4_Distress_Other']),
      barrel1Severity: ParsersUtils.parseToString(json['A4_Severity']),

      barrel2Distress: ParsersUtils.parseToString(json['B4_Distress']),
      barrel2DistressOther: ParsersUtils.parseToString(json['B4_Distress_Other']),
      barrel2Severity: ParsersUtils.parseToString(json['B4_Severity']),

      barrel3Distress: ParsersUtils.parseToString(json['C4_Distress']),
      barrel3DistressOther: ParsersUtils.parseToString(json['C4_Distress_Other']),
      barrel3Severity: ParsersUtils.parseToString(json['C4_Severity']),

      barrel4Distress: ParsersUtils.parseToString(json['D4_Distress']),
      barrel4DistressOther: ParsersUtils.parseToString(json['D4_Distress_Other']),
      barrel4Severity: ParsersUtils.parseToString(json['D4_Severity']),

      culvertApproachConditionDistress: ParsersUtils.parseToString(json['A5_Distress']),
      culvertApproachConditionDistressOther: ParsersUtils.parseToString(json['A5_Distress_Other']),
      culvertApproachConditionSeverity: ParsersUtils.parseToString(json['A5_Severity']),

      investigation: ParsersUtils.parseToString(json['investigation']),
    );
  }

  //Only used for retrieve draft data from sqlite
  factory FormCModel.fromJsonDraft(Map<String, dynamic> json) {
    //if got "57" then "YES" else if got "58" then "NO" else ""
    String conditionYesOrNo(String key) => key == "57"
        ? "YES"
        : key == "58"
        ? "NO"
        : "";

    return FormCModel(
      accessToken: ParsersUtils.parseToString(json['access_token']),
      username: ParsersUtils.parseToString(json['username']),
      recID: ParsersUtils.parseToString(json['recID']),
      inspectionDate: ParsersUtils.parseToString(json['inspection_date']),
      referenceNo: ParsersUtils.parseToString(json['referenceNo']),
      packageId: ParsersUtils.parseToString(json['packageId']),
      districtId: ParsersUtils.parseToString(json['districtId']),
      roadId: ParsersUtils.parseToString(json['roadId']),
      culvertMarkerDistress: ParsersUtils.parseToString(json['1A_culvert_marker_distress']),
      culvertMarkerSeverity: ParsersUtils.parseToString(json['1A_culvert_marker_severity']),

      waterwayDistress: ParsersUtils.parseToString(json['2A_waterway_Distress']),
      waterwayDistressOther: ParsersUtils.parseToString(json['A2_Distress_Other']),
      waterwaySeverity: ParsersUtils.parseToString(json['2A_waterway_Severity']),

      embankmentDistress: ParsersUtils.parseToString(json['2B_embankment_Distress']),
      embankmentDistressOther: ParsersUtils.parseToString(json['B2_Distress_Other']),
      embankmentSeverity: ParsersUtils.parseToString(json['2B_embankment_Severity']),

      headwallInletDistress: ParsersUtils.parseToString(json['3A_headwall_inlet_Distress']),
      headwallInletDistressOther: ParsersUtils.parseToString(json['A3_Distress_Other']),
      headwallInletSeverity: ParsersUtils.parseToString(json['3A_headwall_inlet_Severity']),

      wingwallInletDistress: ParsersUtils.parseToString(json['3B_wingwall_inlet_Distress']),
      wingwallInletDistressOther: ParsersUtils.parseToString(json['B3_Distress_Other']),
      wingwallInletSeverity: ParsersUtils.parseToString(json['3B_wingwall_inlet_Severity']),

      apronInletDistress: ParsersUtils.parseToString(json['3C_apron_inlet_Distress']),
      apronInletDistressOther: ParsersUtils.parseToString(json['C3_Distress_Other']),
      apronInletSeverity: ParsersUtils.parseToString(json['3C_apron_inlet_Severity']),

      riprapInletDistress: ParsersUtils.parseToString(json['3D_riprap_inlet_Distress']),
      riprapInletDistressOther: ParsersUtils.parseToString(json['D3_Distress_Other']),
      riprapInletSeverity: ParsersUtils.parseToString(json['3D_riprap_inlet_Severity']),

      headwallOutletDistress: ParsersUtils.parseToString(json['3E_headwall_outlet_Distress']),
      headwallOutletDistressOther: ParsersUtils.parseToString(json['E3_Distress_Other']),
      headwallOutletSeverity: ParsersUtils.parseToString(json['3E_headwall_outlet_Severity']),

      wingwallOutletDistress: ParsersUtils.parseToString(json['3F_wingwall_outlet_Distress']),
      wingwallOutletDistressOther: ParsersUtils.parseToString(json['F3_Distress_Other']),
      wingwallOutletSeverity: ParsersUtils.parseToString(json['3F_wingwall_outlet_Severity']),

      apronOutletDistress: ParsersUtils.parseToString(json['3G_apron_outlet_Distress']),
      apronOutletDistressOther: ParsersUtils.parseToString(json['G3_Distress_Other']),
      apronOutletSeverity: ParsersUtils.parseToString(json['3G_apron_outlet_Severity']),

      riprapOutletDistress: ParsersUtils.parseToString(json['3H_riprap_outlet_Distress']),
      riprapOutletDistressOther: ParsersUtils.parseToString(json['H3_Distress_Other']),
      riprapOutletSeverity: ParsersUtils.parseToString(json['3H_riprap_outlet_Severity']),

      barrel1Distress: ParsersUtils.parseToString(json['4A_barrel1_Distress']),
      barrel1DistressOther: ParsersUtils.parseToString(json['A4_Distress_Other']),
      barrel1Severity: ParsersUtils.parseToString(json['4A_barrel1_Severity']),

      barrel2Distress: ParsersUtils.parseToString(json['4B_barrel2_Distress']),
      barrel2DistressOther: ParsersUtils.parseToString(json['B4_Distress_Other']),
      barrel2Severity: ParsersUtils.parseToString(json['4B_barrel2_Severity']),

      barrel3Distress: ParsersUtils.parseToString(json['4C_barrel3_Distress']),
      barrel3DistressOther: ParsersUtils.parseToString(json['C4_Distress_Other']),
      barrel3Severity: ParsersUtils.parseToString(json['4C_barrel3_Severity']),

      barrel4Distress: ParsersUtils.parseToString(json['4D_barrel4_Distress']),
      barrel4DistressOther: ParsersUtils.parseToString(json['D4_Distress_Other']),
      barrel4Severity: ParsersUtils.parseToString(json['4D_barrel4_Severity']),

      culvertApproachConditionDistress: ParsersUtils.parseToString(json['5A_culvert_approch_condition_Distress']),
      culvertApproachConditionDistressOther: ParsersUtils.parseToString(json['A5_Distress_Other']),
      culvertApproachConditionSeverity: ParsersUtils.parseToString(json['5A_culvert_approch_condition_Severity']),

      investigation: ParsersUtils.parseToString(json['investigation']),
    );
  }

  Map<String, dynamic> toJson() {
    // Convert "YES"/"NO" back to the "57"/"58" codes expected by the API
    String convertYesOrNo(String? value) {
      if (value == "YES") return "57";
      if (value == "NO") return "58";
      return "";
    }

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
      // Basic Info
      'inspection_date': inspectionDate,
      'referenceNo': referenceNo,
      'packageId': packageId,
      'districtId': districtId,
      'roadId': roadId,
      'Chainage': chainage,
      'StructureCode': structureCode,
      'GPS_Easting': gpsEasting,
      'GPS_Northing': gpsNorthing,

      // Environmental & Access
      'parkingPosition': convertYesOrNo(parkingPosition),
      'accessCondition': convertYesOrNo(accessCondition),
      'potentialHazard': convertYesOrNo(potentialHazard),

      // Engineering Details
      'FinishedRoadLevel': finishedRoadLevel,
      'CatchmentArea': catchmentArea,
      'DesignFlow': designFlow,
      'Precast_In_situ': precastInSitu,
      'BarrelNumber_Size': barrelNumberSize,
      'InletLevel': inletLevel,
      'OutletLevel': outletLevel,
      'CulvertSkew': culvertSkew,
      'CulvertLength': culvertLength,

      // Lists/Strings
      'CulvertType': culvertType?.join(',') ?? "",
      'CulvertMaterial': culvertMaterial?.join(',') ?? "",
      'InletStructure': inletStructure?.join(',') ?? "",
      'OutletStructure': outletStructure?.join(',') ?? "",

      // 1A - 2B Distress & Severity
      '1A_culvert_marker_distress': formatDistress(culvertMarkerDistress),
      '1A_culvert_marker_severity': formatSeverity(culvertMarkerSeverity),

      '2A_waterway_Distress': formatDistress(waterwayDistress),
      'A2_Distress_Other': waterwayDistressOther,
      '2A_waterway_Severity': formatSeverity(waterwaySeverity),

      '2B_embankment_Distress': formatDistress(embankmentDistress),
      'B2_Distress_Other': embankmentDistressOther,
      '2B_embankment_Severity': formatSeverity(embankmentSeverity),

      // 3A - 3D (Inlet)
      '3A_headwall_inlet_Distress': formatDistress(headwallInletDistress),
      'A3_Distress_Other': headwallInletDistressOther,
      '3A_headwall_inlet_Severity': formatSeverity(headwallInletSeverity),

      '3B_wingwall_inlet_Distress': formatDistress(wingwallInletDistress),
      'B3_Distress_Other': wingwallInletDistressOther,
      '3B_wingwall_inlet_Severity': formatSeverity(wingwallInletSeverity),

      '3C_apron_inlet_Distress': formatDistress(apronInletDistress),
      'C3_Distress_Other': apronInletDistressOther,
      '3C_apron_inlet_Severity': formatSeverity(apronInletSeverity),

      '3D_riprap_inlet_Distress': formatDistress(riprapInletDistress),
      'D3_Distress_Other': riprapInletDistressOther,
      '3D_riprap_inlet_Severity': formatSeverity(riprapInletSeverity),

      // 3E - 3H (Outlet)
      '3E_headwall_outlet_Distress': formatDistress(headwallOutletDistress),
      'E3_Distress_Other': headwallOutletDistressOther,
      '3E_headwall_outlet_Severity': formatSeverity(headwallOutletSeverity),

      '3F_wingwall_outlet_Distress': formatDistress(wingwallOutletDistress),
      'F3_Distress_Other': wingwallOutletDistressOther,
      '3F_wingwall_outlet_Severity': formatSeverity(wingwallOutletSeverity),

      '3G_apron_outlet_Distress': formatDistress(apronOutletDistress),
      'G3_Distress_Other': apronOutletDistressOther,
      '3G_apron_outlet_Severity': formatSeverity(apronOutletSeverity),

      '3H_riprap_outlet_Distress': formatDistress(riprapOutletDistress),
      'H3_Distress_Other': riprapOutletDistressOther,
      '3H_riprap_outlet_Severity': formatSeverity(riprapOutletSeverity),

      // 4A - 4D (Barrels)
      '4A_barrel1_Distress': formatDistress(barrel1Distress),
      'A4_Distress_Other': barrel1DistressOther,
      '4A_barrel1_Severity': formatSeverity(barrel1Severity),

      '4B_barrel2_Distress': formatDistress(barrel2Distress),
      'B4_Distress_Other': barrel2DistressOther,
      '4B_barrel2_Severity': formatSeverity(barrel2Severity),

      '4C_barrel3_Distress': formatDistress(barrel3Distress),
      'C4_Distress_Other': barrel3DistressOther,
      '4C_barrel3_Severity': formatSeverity(barrel3Severity),

      '4D_barrel4_Distress': formatDistress(barrel4Distress),
      'D4_Distress_Other': barrel4DistressOther,
      '4D_barrel4_Severity': formatSeverity(barrel4Severity),

      // 5A (Approach)
      '5A_culvert_approch_condition_Distress': formatDistress(culvertApproachConditionDistress),
      'A5_Distress_Other': culvertApproachConditionDistressOther,
      '5A_culvert_approch_condition_Severity': formatSeverity(culvertApproachConditionSeverity),
    };
  }

  Map<String, dynamic> toAPISubmitJson() {
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
      'recID': recID,
      'inspection_date': inspectionDate,

      // 1A - 2B Distress & Severity
      '1A_culvert_marker_distress': formatDistress(culvertMarkerDistress),
      '1A_culvert_marker_severity': formatSeverity(culvertMarkerSeverity),

      '2A_waterway_Distress': formatDistress(waterwayDistress),
      'A2_Distress_Other': waterwayDistressOther,
      '2A_waterway_Severity': formatSeverity(waterwaySeverity),

      '2B_embankment_Distress': formatDistress(embankmentDistress),
      'B2_Distress_Other': embankmentDistressOther,
      '2B_embankment_Severity': formatSeverity(embankmentSeverity),

      // 3A - 3D (Inlet)
      '3A_headwall_inlet_Distress': formatDistress(headwallInletDistress),
      'A3_Distress_Other': headwallInletDistressOther,
      '3A_headwall_inlet_Severity': formatSeverity(headwallInletSeverity),

      '3B_wingwall_inlet_Distress': formatDistress(wingwallInletDistress),
      'B3_Distress_Other': wingwallInletDistressOther,
      '3B_wingwall_inlet_Severity': formatSeverity(wingwallInletSeverity),

      '3C_apron_inlet_Distress': formatDistress(apronInletDistress),
      'C3_Distress_Other': apronInletDistressOther,
      '3C_apron_inlet_Severity': formatSeverity(apronInletSeverity),

      '3D_riprap_inlet_Distress': formatDistress(riprapInletDistress),
      'D3_Distress_Other': riprapInletDistressOther,
      '3D_riprap_inlet_Severity': formatSeverity(riprapInletSeverity),

      // 3E - 3H (Outlet)
      '3E_headwall_outlet_Distress': formatDistress(headwallOutletDistress),
      'E3_Distress_Other': headwallOutletDistressOther,
      '3E_headwall_outlet_Severity': formatSeverity(headwallOutletSeverity),

      '3F_wingwall_outlet_Distress': formatDistress(wingwallOutletDistress),
      'F3_Distress_Other': wingwallOutletDistressOther,
      '3F_wingwall_outlet_Severity': formatSeverity(wingwallOutletSeverity),

      '3G_apron_outlet_Distress': formatDistress(apronOutletDistress),
      'G3_Distress_Other': apronOutletDistressOther,
      '3G_apron_outlet_Severity': formatSeverity(apronOutletSeverity),

      '3H_riprap_outlet_Distress': formatDistress(riprapOutletDistress),
      'H3_Distress_Other': riprapOutletDistressOther,
      '3H_riprap_outlet_Severity': formatSeverity(riprapOutletSeverity),

      // 4A - 4D (Barrels)
      '4A_barrel1_Distress': formatDistress(barrel1Distress),
      'A4_Distress_Other': barrel1DistressOther,
      '4A_barrel1_Severity': formatSeverity(barrel1Severity),

      '4B_barrel2_Distress': formatDistress(barrel2Distress),
      'B4_Distress_Other': barrel2DistressOther,
      '4B_barrel2_Severity': formatSeverity(barrel2Severity),

      '4C_barrel3_Distress': formatDistress(barrel3Distress),
      'C4_Distress_Other': barrel3DistressOther,
      '4C_barrel3_Severity': formatSeverity(barrel3Severity),

      '4D_barrel4_Distress': formatDistress(barrel4Distress),
      'D4_Distress_Other': barrel4DistressOther,
      '4D_barrel4_Severity': formatSeverity(barrel4Severity),

      // 5A (Approach)
      '5A_culvert_approch_condition_Distress': formatDistress(culvertApproachConditionDistress),
      'A5_Distress_Other': culvertApproachConditionDistressOther,
      '5A_culvert_approch_condition_Severity': formatSeverity(culvertApproachConditionSeverity),

      // Investigation
      'investigation': investigation ?? "",
    };
  }

  Map<String, dynamic> toDraftJson() {
    // Convert "YES"/"NO" back to the "57"/"58" codes expected by the API
    String convertYesOrNo(String? value) {
      if (value == "YES") return "57";
      if (value == "NO") return "58";
      return "";
    }

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
      // Basic Info
      'inspection_date': inspectionDate,
      'referenceNo': referenceNo,
      'packageId': packageId,
      'districtId': districtId,
      'roadId': roadId,
      'recID': recID,

      // 1A - 2B Distress & Severity
      '1A_culvert_marker_distress': formatDistress(culvertMarkerDistress),
      '1A_culvert_marker_severity': formatSeverity(culvertMarkerSeverity),

      '2A_waterway_Distress': formatDistress(waterwayDistress),
      'A2_Distress_Other': waterwayDistressOther,
      '2A_waterway_Severity': formatSeverity(waterwaySeverity),

      '2B_embankment_Distress': formatDistress(embankmentDistress),
      'B2_Distress_Other': embankmentDistressOther,
      '2B_embankment_Severity': formatSeverity(embankmentSeverity),

      // 3A - 3D (Inlet)
      '3A_headwall_inlet_Distress': formatDistress(headwallInletDistress),
      'A3_Distress_Other': headwallInletDistressOther,
      '3A_headwall_inlet_Severity': formatSeverity(headwallInletSeverity),

      '3B_wingwall_inlet_Distress': formatDistress(wingwallInletDistress),
      'B3_Distress_Other': wingwallInletDistressOther,
      '3B_wingwall_inlet_Severity': formatSeverity(wingwallInletSeverity),

      '3C_apron_inlet_Distress': formatDistress(apronInletDistress),
      'C3_Distress_Other': apronInletDistressOther,
      '3C_apron_inlet_Severity': formatSeverity(apronInletSeverity),

      '3D_riprap_inlet_Distress': formatDistress(riprapInletDistress),
      'D3_Distress_Other': riprapInletDistressOther,
      '3D_riprap_inlet_Severity': formatSeverity(riprapInletSeverity),

      // 3E - 3H (Outlet)
      '3E_headwall_outlet_Distress': formatDistress(headwallOutletDistress),
      'E3_Distress_Other': headwallOutletDistressOther,
      '3E_headwall_outlet_Severity': formatSeverity(headwallOutletSeverity),

      '3F_wingwall_outlet_Distress': formatDistress(wingwallOutletDistress),
      'F3_Distress_Other': wingwallOutletDistressOther,
      '3F_wingwall_outlet_Severity': formatSeverity(wingwallOutletSeverity),

      '3G_apron_outlet_Distress': formatDistress(apronOutletDistress),
      'G3_Distress_Other': apronOutletDistressOther,
      '3G_apron_outlet_Severity': formatSeverity(apronOutletSeverity),

      '3H_riprap_outlet_Distress': formatDistress(riprapOutletDistress),
      'H3_Distress_Other': riprapOutletDistressOther,
      '3H_riprap_outlet_Severity': formatSeverity(riprapOutletSeverity),

      // 4A - 4D (Barrels)
      '4A_barrel1_Distress': formatDistress(barrel1Distress),
      'A4_Distress_Other': barrel1DistressOther,
      '4A_barrel1_Severity': formatSeverity(barrel1Severity),

      '4B_barrel2_Distress': formatDistress(barrel2Distress),
      'B4_Distress_Other': barrel2DistressOther,
      '4B_barrel2_Severity': formatSeverity(barrel2Severity),

      '4C_barrel3_Distress': formatDistress(barrel3Distress),
      'C4_Distress_Other': barrel3DistressOther,
      '4C_barrel3_Severity': formatSeverity(barrel3Severity),

      '4D_barrel4_Distress': formatDistress(barrel4Distress),
      'D4_Distress_Other': barrel4DistressOther,
      '4D_barrel4_Severity': formatSeverity(barrel4Severity),

      // 5A (Approach)
      '5A_culvert_approch_condition_Distress': formatDistress(culvertApproachConditionDistress),
      'A5_Distress_Other': culvertApproachConditionDistressOther,
      '5A_culvert_approch_condition_Severity': formatSeverity(culvertApproachConditionSeverity),
    };
  }

  static final List<SeverityModel> severityModel = [
    SeverityModel(
      level: "1",
      description: const Text.rich(
        TextSpan(children: [
          TextSpan(
            text: 'The item is in excellent condition.',
            style: TextStyle(fontSize: 16),
          ),
          TextSpan(
            text: ' No deficiencies.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    ),
    SeverityModel(
      level: "2",
      description: const Text.rich(
        TextSpan(children: [
          TextSpan(
            text:
            'The item is in good condition. No noteworthy deficiencies that affect the condition of the Secondary Members. Insignificant damage and defects only with the Secondary members.',
            style: TextStyle(fontSize: 16),
          ),
          TextSpan(
            text: ' No work required.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    ),
    SeverityModel(
      level: "3",
      additionalNote: "(Pr.2)",
      description: const Text.rich(
        TextSpan(children: [
          TextSpan(
            text: 'The item is in fair condition but',
            style: TextStyle(fontSize: 16),
          ),
          TextSpan(
            text: ' requires attention',
            style:
            TextStyle(fontSize: 16, decoration: TextDecoration.underline),
          ),
          TextSpan(
            text:
            ' in the next inspection. All primary structural components are functional and fit for purpose but may have minor section loss, cracking, spalling or scour. Moderate deterioration or blockage or disintegration and minor settlement or misalignment at Secondary Members.',
            style: TextStyle(fontSize: 16),
          ),
        ]),
      ),
    ),
    SeverityModel(
      level: "4",
      additionalNote: "(Pr.1)",
      description: const Text.rich(
        TextSpan(children: [
          TextSpan(
            text: 'The item is in poor condition but',
            style: TextStyle(fontSize: 16),
          ),
          TextSpan(
            text: ' requires attention',
            style:
            TextStyle(fontSize: 16, decoration: TextDecoration.underline),
          ),
          TextSpan(
            text: ' BEFORE',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
            ' the next inspection. Without repairs there is potential for failure leading to a critical situation. Advanced section loss, deterioration, damaged, significant spalling or scour have affected primary structural components. Considerable settlement or misalignment.',
            style: TextStyle(fontSize: 16),
          ),
        ]),
      ),
    ),
    SeverityModel(
      level: "5",
      additionalNote: "CIL",
      description: const Text.rich(
        TextSpan(children: [
          TextSpan(
            text: 'The item is in critical, imminent failure condition and',
            style: TextStyle(fontSize: 16),
          ),
          TextSpan(
            text: ' requires immediate attention.',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
          TextSpan(
            text:
            ' Major deterioration or section loss present in primary structural components affecting structural stability.',
            style: TextStyle(fontSize: 16),
          ),
        ]),
      ),
    )
  ];

  @override
  List<InspectionGroup> getInspectionGroups() {
    return [
      //Group 1: Culvert Marker
      InspectionGroup(
        headerTitle: "Culvert Marker (1A)",
        items: [
          InspectionSectionData.create(
              '1A', '', culvertMarkerDistress, culvertMarkerSeverity),
        ],
      ),
      //Group 2: Waterways
      InspectionGroup(
        headerTitle: "Waterways (2A - 2B)",
        items: [
          InspectionSectionData.create(
              '2A', 'Waterway', waterwayDistress, waterwaySeverity),
          InspectionSectionData.create('2B', 'Embankment (Revetment)',
              embankmentDistress, embankmentSeverity),
        ],
      ),
      //Group 3: Walls and Aprons
      InspectionGroup(
        headerTitle: "Walls and Aprons (3A - 3H)",
        items: [
          InspectionSectionData.create('3A', 'Headwall (Inlet)',
              headwallInletDistress, headwallInletSeverity),
          InspectionSectionData.create('3B', 'Wingwall (Inlet)',
              wingwallInletDistress, wingwallInletSeverity),
          InspectionSectionData.create(
              '3C', 'Apron (Inlet)', apronInletDistress, apronInletSeverity),
          InspectionSectionData.create(
              '3D', 'Riprap (Inlet)', riprapInletDistress, riprapInletSeverity),
          InspectionSectionData.create('3E', 'Headwall (Outlet)',
              headwallOutletDistress, headwallOutletSeverity),
          InspectionSectionData.create('3F', 'Wingwall (Outlet)',
              wingwallOutletDistress, wingwallOutletSeverity),
          InspectionSectionData.create(
              '3G', 'Apron (Outlet)', apronOutletDistress, apronOutletSeverity),
          InspectionSectionData.create('3H', 'Riprap (Outlet)',
              riprapOutletDistress, riprapOutletSeverity),
        ],
      ),
      //Group 4: Culvert Units
      InspectionGroup(
        headerTitle: "Culvert Units (4A - 4D)",
        items: [
          InspectionSectionData.create(
              '4A', 'Barrel #1', barrel1Distress, barrel1Severity),
          InspectionSectionData.create(
              '4B', 'Barrel #2', barrel2Distress, barrel2Severity),
          InspectionSectionData.create(
              '4C', 'Barrel #3', barrel3Distress, barrel3Severity),
          InspectionSectionData.create(
              '4D', 'Barrel #4', barrel4Distress, barrel4Severity),
        ],
      ),
      //Group 5: Culvert Approach Condition
      InspectionGroup(
        headerTitle: "Culvert Approach Condition (5A)",
        items: [
          InspectionSectionData.create(
              '5A',
              '',
              culvertApproachConditionDistress,
              culvertApproachConditionSeverity)
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
  final String distress;
  final String severity;

  InspectionSectionData({
    required this.id,
    required this.title,
    required this.distress,
    required this.severity,
  });

  static InspectionSectionData create(
      String id,
      String title,
      String? distress,
      String? severity,
      ) {
    return InspectionSectionData(
      id: id,
      title: '$title ($id)', // Formats as "Abutment Walls (P1)"
      distress: (distress == null || distress.isEmpty) ? "-" : distress,
      severity: (severity == null || severity.isEmpty) ? "-" : severity,
    );
  }
}