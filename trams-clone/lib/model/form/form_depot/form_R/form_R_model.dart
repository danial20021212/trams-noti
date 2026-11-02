// ignore_for_file: file_names, camel_case_types

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:tram/model/form/form_depot/common/distress_model.dart';
import 'package:tram/model/form/form_depot/common/severity_model.dart';
import 'package:tram/utils/parsers_utils.dart';

import '../main_listing/inspection_detail_model.dart';

class Form_R_InspectionDetailsModel extends Equatable {
  const Form_R_InspectionDetailsModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<FormRModel> data;

  Form_R_InspectionDetailsModel copyWith({
    String? httpStatus,
    List<FormRModel>? data,
  }) {
    return Form_R_InspectionDetailsModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory Form_R_InspectionDetailsModel.fromJson(Map<String, dynamic> json) {
    return Form_R_InspectionDetailsModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<FormRModel>.from(
              json["data"]!.map((x) => FormRModel.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class FormRModel extends InspectionDetailModel {
  String? recID;
  String? inspectionDate;
  String? referenceNo;
  String? packageID;
  String? districtID;
  String? roadID;
  String? chainageKilometre;
  String? structureCode;
  String? gpsEasting;
  String? gpsNorting;
  List<String>? wallFunction;
  String? wallFunctionOther;
  String? wallMember1;
  String? wallMember2;
  String? wallMember3;
  String? wallMemberOther;
  String? facingType1;
  String? facingType2;
  String? facingType3;
  String? facingTypeOther;
  List<String>? distress;
  String? severity;

  FormRModel({
    this.recID,
    this.inspectionDate,
    this.packageID,
    this.districtID,
    this.roadID,
    this.referenceNo,
    this.chainageKilometre,
    this.structureCode,
    this.gpsEasting,
    this.gpsNorting,
    this.wallFunction,
    this.wallFunctionOther,
    this.wallMember1,
    this.wallMember2,
    this.wallMember3,
    this.wallMemberOther,
    this.facingType1,
    this.facingType2,
    this.facingType3,
    this.facingTypeOther,
    this.distress,
    this.severity,
  });

  factory FormRModel.fromJson(Map<String, dynamic> json) {
    return FormRModel(
      recID: ParsersUtils.parseToString(json['recID']),
      inspectionDate: ParsersUtils.parseToString(json['inspection_date']),
      referenceNo: ParsersUtils.parseToString(json['referenceNo']),
      packageID:
          ParsersUtils.parseToString(json['packageId'] ?? json['packageID']),
      districtID:
          ParsersUtils.parseToString(json['districtId'] ?? json['districtID']),
      roadID: ParsersUtils.parseToString(json['roadId'] ?? json['roadID']),
      chainageKilometre: ParsersUtils.parseToString(json['Chainage']),
      structureCode: ParsersUtils.parseToString(json['StructureCode']),
      gpsEasting: ParsersUtils.parseToString(json['GPS_Easting']),
      gpsNorting: ParsersUtils.parseToString(json['GPS_Northing']),
      wallFunction: ParsersUtils.parseToStringList(json['wallFunction']),
      wallFunctionOther: ParsersUtils.parseToString(json['wallFunction_other']),
      wallMember1: ParsersUtils.parseToString(json['wallMember1']),
      wallMember2: ParsersUtils.parseToString(json['wallMember2']),
      wallMember3: ParsersUtils.parseToString(json['wallMember3']),
      wallMemberOther: ParsersUtils.parseToString(json['wallMember_other']),
      facingType1: ParsersUtils.parseToString(json['facingType1']),
      facingType2: ParsersUtils.parseToString(json['facingType2']),
      facingType3: ParsersUtils.parseToString(json['facingType3']),
      facingTypeOther: ParsersUtils.parseToString(json['facingType_other']),
      distress: ParsersUtils.parseToStringList(json['distress']),
      severity: ParsersUtils.parseToString(json['severity']),
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

    return {
      // --- LOCATION & HEADER DATA ---
      'recID': recID,
      'inspection_date': inspectionDate,
      'referenceNo': referenceNo,
      'packageId': packageID,
      'districtId': districtID,
      'roadId': roadID,
      'Chainage': chainageKilometre,
      'StructureCode': structureCode,
      'GPS_Easting': gpsEasting,
      'GPS_Northing': gpsNorting,

      // --- WALL SPECIFIC DATA ---
      // Arrays/Lists joined as comma-separated strings for SQLite
      'wallFunction': wallFunction?.join(',') ?? "",
      'wallFunction_other': wallFunctionOther,
      'wallMember1': wallMember1,
      'wallMember2': wallMember2,
      'wallMember3': wallMember3,
      'wallMember_other': wallMemberOther,
      'facingType1': facingType1,
      'facingType2': facingType2,
      'facingType3': facingType3,
      'facingType_other': facingTypeOther,
      'distress': distress?.join(',') ?? "",
      'severity': formatSeverity(severity),
    };
  }

  static const Map<String, String> wallFunctionData = {
    "F1": "Fill Wall",
    "F2": "Bridge Wall",
    "F3": "Cut Wall",
    "F4": "Switchback Wall",
    "F5": "Head Wall",
    "F6": "Slope Protection",
    "F7": "Flood Wall",
    "F8": "Others",
  };

  static const Map<String, String> wallMemberData = {
    "M1": "Anchor, Tieback H-Pile",
    "M2": "Anchor, Micropile",
    "M3": "Anchor, Tieback Sheet Pile",
    "M4": "Bin, Concrete",
    "M5": "Bin, Metal",
    "M6": "Cantilever, Concrete",
    "M7": "Cantilever, Soldier Pile",
    "M8": "Cantilever, Sheet Pile",
    "M9": "Crib, Concrete",
    "M10": "Crib, Metal",
    "M11": "Crib, Timber",
    "M12": "Gravity, Concrete Block/Brick",
    "M13": "Gravity, Mass Concrete",
    "M14": "Gravity, Dry Stone",
    "M15": "Gravity, Gabion",
    "M16": "Gravity, Mortared Stone",
    "M17": "Geosynthetic Wrapped Face",
    "M18": "Precast Panel",
    "M19": "Segmental Block",
    "M20": "Welded Wire Face",
    "M21": "Soil Nail",
    "M22": "Tangent/Secant Pile",
    "M23": "To be confirmed",
    "M24": "Others",
  };

  static const Map<String, String> facingTypeData = {
    "T1": "Brick Veneer",
    "T2": "Cemetitous Overlay",
    "T3": "Fractured Fin Concrete",
    "T4": "Formlined Concrete",
    "T5": "Plain Concrete",
    "T6": "Planted Face",
    "T7": "Sculpted Shotcrete",
    "T8": "Shotcrete (nozzle finish)",
    "T9": "Steel/Metal",
    "T10": "Stone",
    "T11": "Simulated Stone",
    "T12": "Stone Veneer",
    "T13": "Timber",
    "T14": "To be confirmed",
    "T15": "Others",
  };

  static const List<Distress> distressModel = [
    Distress(distressCode: "ND", distressName: "No Distress Observed"),
    Distress(distressCode: "R01", distressName: "Buckling under Compression"),
    Distress(distressCode: "R02", distressName: "Bursting or Bulging"),
    Distress(distressCode: "R03", distressName: "Cracks / Spalling"),
    Distress(distressCode: "R04", distressName: "Crest symptoms"),
    Distress(distressCode: "R05", distressName: "Crushing of Material"),
    Distress(distressCode: "R06", distressName: "Erosion"),
    Distress(distressCode: "R07", distressName: "Heaving at Base"),
    Distress(
        distressCode: "R08", distressName: "Irregularities at Coping Level"),
    Distress(
        distressCode: "R09",
        distressName: "Missing / Inadequate Drainage System"),
    Distress(distressCode: "R10", distressName: "Movement"),
    Distress(
        distressCode: "R11",
        distressName: "Progressive Outward or Tilting Movement"),
    Distress(distressCode: "R12", distressName: "Seepage"),
    Distress(distressCode: "R13", distressName: "Settlement on Top"),
    Distress(
        distressCode: "R14", distressName: "Shear Displacement along the Bed"),
    Distress(distressCode: "R15", distressName: "Sinkholes"),
    Distress(distressCode: "R16", distressName: "Sliding"),
    Distress(
        distressCode: "R17", distressName: "Stone Fragments at Base of Wall"),
    Distress(distressCode: "R18", distressName: "Wall Dropping"),
    Distress(distressCode: "R19", distressName: "Water Leakage from utilities"),
    Distress(distressCode: "R20", distressName: "Weak Materials"),
    Distress(distressCode: "R21", distressName: "Weathered Materials"),
    Distress(distressCode: "R22", distressName: "Unidentify Distress"),
    Distress(distressCode: "R23", distressName: "Others:"),
  ];

  static final List<SeverityModel> severityModel = [
    SeverityModel(
      level: "1",
      description: const Text.rich(
        TextSpan(children: [
          TextSpan(
            text: 'The item is in excellent condition and',
            style: TextStyle(fontSize: 16),
          ),
          TextSpan(
            text: ' no deficiencies.',
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
            text: 'The item is in Good condition but requires some',
            style: TextStyle(fontSize: 16),
          ),
          TextSpan(
            text: ' clearing',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: ' of',
            style: TextStyle(fontSize: 16),
          ),
          TextSpan(
            text: ' ebris/vegetation',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: ' works to be carried out.',
            style: TextStyle(fontSize: 16),
          ),
        ]),
      ),
    ),
    SeverityModel(
      level: "3",
      description: const Text.rich(
        TextSpan(children: [
          TextSpan(
            text:
                'The item is in fair condition but requires attention in the next inspection.',
            style: TextStyle(fontSize: 16),
          ),
        ]),
      ),
    ),
    SeverityModel(
      level: "4",
      description: const Text.rich(
        TextSpan(children: [
          TextSpan(
            text: 'The item is in fair condition and',
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
            text: ' the next inspection due to distresses observed.',
            style: TextStyle(fontSize: 16),
          ),
        ]),
      ),
    ),
    SeverityModel(
      level: "5",
      description: const Text.rich(
        TextSpan(children: [
          TextSpan(
            text: 'The item is in critical & imminent failure condition and',
            style: TextStyle(fontSize: 16),
          ),
          TextSpan(
            text: ' requires IMMEDIATE intervention',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
          TextSpan(
            text: ' by Specialist.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ]),
      ),
    )
  ];

  @override
  List getInspectionGroups() {
    // Helper function to map code -> "code : label"
    String mapCodeToLabel(String? code, Map<String, String> map) {
      if (code == null || code.isEmpty) return "-";
      final label = map[code] ?? "Unknown";
      return "$code : $label";
    }

    // Helper function for list of codes
    String mapCodesListToLabel(List<String>? codes, Map<String, String> map) {
      if (codes == null || codes.isEmpty) return "-";
      return codes.map((c) => mapCodeToLabel(c, map)).join(", ");
    }

    // Helper for distress list
    String mapDistressListToLabel(List<String>? codes) {
      if (codes == null || codes.isEmpty) return "-";
      return codes.map((c) {
        final d = FormRModel.distressModel.firstWhere(
          (e) => e.distressCode == c,
          orElse: () => Distress(distressCode: c, distressName: "Unknown"),
        );
        return "${d.distressCode} : ${d.distressName}";
      }).join(", ");
    }

    return [
      // InspectionGroup(
      //   headerTitle: "Wall Function",
      //   items: [
      //     InspectionItem(
      //       label: "Function",
      //       value:
      //           mapCodesListToLabel(wallFunction, FormRModel.wallFunctionData),
      //     ),
      //     InspectionItem(
      //       label: "Other Function",
      //       value: wallFunctionOther == "" || wallFunctionOther == null ? "-" : wallFunctionOther!,
      //     ),
      //   ],
      // ),
      // InspectionGroup(
      //   headerTitle: "Wall Member",
      //   items: [
      //     InspectionItem(
      //       label: "Member 1",
      //       value: mapCodeToLabel(wallMember1, FormRModel.wallMemberData),
      //     ),
      //     InspectionItem(
      //       label: "Member 2",
      //       value: mapCodeToLabel(wallMember2, FormRModel.wallMemberData),
      //     ),
      //     InspectionItem(
      //       label: "Member 3",
      //       value: mapCodeToLabel(wallMember3, FormRModel.wallMemberData),
      //     ),
      //     InspectionItem(
      //       label: "Other Member",
      //       value: wallMemberOther == "" || wallMemberOther == null ? "-" : wallMemberOther!,
      //     ),
      //   ],
      // ),
      // InspectionGroup(
      //   headerTitle: "Facing Type",
      //   items: [
      //     InspectionItem(
      //       label: "Type 1",
      //       value: mapCodeToLabel(facingType1, FormRModel.facingTypeData),
      //     ),
      //     InspectionItem(
      //       label: "Type 2",
      //       value: mapCodeToLabel(facingType2, FormRModel.facingTypeData),
      //     ),
      //     InspectionItem(
      //       label: "Type 3",
      //       value: mapCodeToLabel(facingType3, FormRModel.facingTypeData),
      //     ),
      //     InspectionItem(
      //       label: "Other Type",
      //       value: facingTypeOther == "" || facingTypeOther == null ? "-" : facingTypeOther!,
      //     ),
      //   ],
      // ),
      InspectionGroup(
        headerTitle: "Observation",
        items: [
          InspectionItem(
            label: "Distress",
            value: mapDistressListToLabel(distress),
          ),
          InspectionItem(
            label: "Severity",
            value: severity == "" || severity == null ? "-" : severity!,
          ),
        ],
      ),
    ];
  }
}

class InspectionGroup {
  final String headerTitle;
  final List<InspectionItem> items;

  InspectionGroup({required this.headerTitle, required this.items});
}

class InspectionItem {
  final String label;
  final String value;

  InspectionItem({
    required this.label,
    required this.value,
  });
}
