// ignore_for_file: file_names, camel_case_types

import 'package:equatable/equatable.dart';
import 'package:tram/utils/parsers_utils.dart';

import '../main_listing/inspection_detail_model.dart';

class Form_G_InspectionDetailsModel extends Equatable {
  const Form_G_InspectionDetailsModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<FormGModel> data;

  Form_G_InspectionDetailsModel copyWith({
    String? httpStatus,
    List<FormGModel>? data,
  }) {
    return Form_G_InspectionDetailsModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory Form_G_InspectionDetailsModel.fromJson(Map<String, dynamic> json) {
    return Form_G_InspectionDetailsModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<FormGModel>.from(
              json["data"]!.map((x) => FormGModel.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class FormGModel extends InspectionDetailModel {
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
  String? barrierDistress;
  String? barrierCritical;
  String? barrierClosed;
  String? gantryBeamDistress;
  String? gantryBeamCritical;
  String? gantryBeamClosed;
  String? gantryColumnDistress;
  String? gantryColumnCritical;
  String? gantryColumnClosed;
  String? footingsDistress;
  String? footingsCritical;
  String? footingsClosed;
  String? anchorMortarDistress;
  String? anchorMortarCritical;
  String? anchorMortarClosed;
  String? maintenanceAccessDistress;
  String? maintenanceAccessCritical;
  String? maintenanceAccessClosed;
  String? staticSignsDistress;
  String? staticSignsCritical;
  String? staticSignsClosed;
  String? vmsDistress;
  String? vmsCritical;
  String? vmsClosed;

  FormGModel({
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
    this.barrierDistress,
    this.barrierCritical,
    this.barrierClosed,
    this.gantryBeamDistress,
    this.gantryBeamCritical,
    this.gantryBeamClosed,
    this.gantryColumnDistress,
    this.gantryColumnCritical,
    this.gantryColumnClosed,
    this.footingsDistress,
    this.footingsCritical,
    this.footingsClosed,
    this.anchorMortarDistress,
    this.anchorMortarCritical,
    this.anchorMortarClosed,
    this.maintenanceAccessDistress,
    this.maintenanceAccessCritical,
    this.maintenanceAccessClosed,
    this.staticSignsDistress,
    this.staticSignsCritical,
    this.staticSignsClosed,
    this.vmsDistress,
    this.vmsCritical,
    this.vmsClosed,
  });

  factory FormGModel.fromJson(Map<String, dynamic> json) {
    return FormGModel(
      recID: ParsersUtils.parseToString(json['recID']),
      inspectionDate: ParsersUtils.parseToString(json['inspection_date']),
      referenceNo: ParsersUtils.parseToString(json['referenceNo']),
      packageId:
          ParsersUtils.parseToString(json['packageId'] ?? json['packageID']),
      districtId:
          ParsersUtils.parseToString(json['districtId'] ?? json['districtID']),
      roadId: ParsersUtils.parseToString(json['roadId'] ?? json['roadID']),
      chainage:
          ParsersUtils.parseToString(json['Chainage'] ?? json['chainage']),
      structureCode: ParsersUtils.parseToString(
          json['StructureCode'] ?? json['structureCode']),
      gpsEasting:
          ParsersUtils.parseToString(json['GPS_Easting'] ?? json['gpsEasting']),
      gpsNorthing: ParsersUtils.parseToString(
          json['GPS_Northing'] ?? json['gpsNorthing']),
      parkingPosition: ParsersUtils.parseToString(json['parkingPosition']),
      accessCondition: ParsersUtils.parseToString(json['accessCondition']),
      potentialHazard: ParsersUtils.parseToString(json['potentialHazard']),
      barrierDistress: ParsersUtils.parseToString(json['barrierDistress']),
      barrierCritical: ParsersUtils.parseToString(json['barrierCritical']),
      barrierClosed: ParsersUtils.parseToString(json['barrierClosed']),
      gantryBeamDistress:
          ParsersUtils.parseToString(json['gantryBeamDistress']),
      gantryBeamCritical:
          ParsersUtils.parseToString(json['gantryBeamCritical']),
      gantryBeamClosed: ParsersUtils.parseToString(json['gantryBeamClosed']),
      gantryColumnDistress:
          ParsersUtils.parseToString(json['gantryColumnDistress']),
      gantryColumnCritical:
          ParsersUtils.parseToString(json['gantryColumnCritical']),
      gantryColumnClosed:
          ParsersUtils.parseToString(json['gantryColumnClosed']),
      footingsDistress: ParsersUtils.parseToString(json['footingsDistress']),
      footingsCritical: ParsersUtils.parseToString(json['footingsCritical']),
      footingsClosed: ParsersUtils.parseToString(json['footingsClosed']),
      anchorMortarDistress:
          ParsersUtils.parseToString(json['anchorMortarDistress']),
      anchorMortarCritical:
          ParsersUtils.parseToString(json['anchorMortarCritical']),
      anchorMortarClosed:
          ParsersUtils.parseToString(json['anchorMortarClosed']),
      maintenanceAccessDistress:
          ParsersUtils.parseToString(json['maintenanceAccessDistress']),
      maintenanceAccessCritical:
          ParsersUtils.parseToString(json['maintenanceAccessCritical']),
      maintenanceAccessClosed:
          ParsersUtils.parseToString(json['maintenanceAccessClosed']),
      staticSignsDistress:
          ParsersUtils.parseToString(json['staticSignsDistress']),
      staticSignsCritical:
          ParsersUtils.parseToString(json['staticSignsCritical']),
      staticSignsClosed: ParsersUtils.parseToString(json['staticSignsClosed']),
      vmsDistress: ParsersUtils.parseToString(json['vmsDistress']),
      vmsCritical: ParsersUtils.parseToString(json['vmsCritical']),
      vmsClosed: ParsersUtils.parseToString(json['vmsClosed']),
    );
  }

  Map<String, dynamic> toJson() {

    // Helper function: returns "0" if the checkbox value is null or empty
    String formatCheckbox(String? value) {
      if (value == null || value.trim().isEmpty) {
        return "0";
      }
      return value;
    }

    return {
      // --- LOCATION & HEADER DATA ---
      'recID': recID,
      'inspection_date': inspectionDate,
      'referenceNo': referenceNo,
      'packageId': packageId,
      'districtId': districtId,
      'roadId': roadId,
      'Chainage': chainage,
      'StructureCode': structureCode,
      'GPS_Easting': gpsEasting,
      'GPS_Northing': gpsNorthing,

      // --- SITE CONDITION & INSPECTION ITEMS ---
      'parkingPosition': parkingPosition,
      'accessCondition': accessCondition,
      'potentialHazard': potentialHazard,

      'barrierDistress': barrierDistress,
      'barrierCritical': formatCheckbox(barrierCritical),
      'barrierClosed': formatCheckbox(barrierClosed),

      'gantryBeamDistress': gantryBeamDistress,
      'gantryBeamCritical': formatCheckbox(gantryBeamCritical),
      'gantryBeamClosed': formatCheckbox(gantryBeamClosed),

      'gantryColumnDistress': gantryColumnDistress,
      'gantryColumnCritical': formatCheckbox(gantryColumnCritical),
      'gantryColumnClosed': formatCheckbox(gantryColumnClosed),

      'footingsDistress': footingsDistress,
      'footingsCritical': formatCheckbox(footingsCritical),
      'footingsClosed': formatCheckbox(footingsClosed),

      'anchorMortarDistress': anchorMortarDistress,
      'anchorMortarCritical': formatCheckbox(anchorMortarCritical),
      'anchorMortarClosed': formatCheckbox(anchorMortarClosed),

      'maintenanceAccessDistress': maintenanceAccessDistress,
      'maintenanceAccessCritical': formatCheckbox(maintenanceAccessCritical),
      'maintenanceAccessClosed': formatCheckbox(maintenanceAccessClosed),

      'staticSignsDistress': staticSignsDistress,
      'staticSignsCritical': formatCheckbox(staticSignsCritical),
      'staticSignsClosed': formatCheckbox(staticSignsClosed),

      'vmsDistress': vmsDistress,
      'vmsCritical': formatCheckbox(vmsCritical),
      'vmsClosed': formatCheckbox(vmsClosed),
    };
  }

  @override
  List<dynamic> getInspectionGroups() {
    return [
      InspectionGroup(
        headerTitle: "Site Condition",
        items: [
          //Site condition
          SectionData.create('Site Condition', "", parkingPosition,
              accessCondition, potentialHazard),
        ],
      ),
      InspectionGroup(
        headerTitle: "Inspection Items",
        items: [
          //1. Barriers
          SectionData.create(
              '1. Barriers',
              "Protection to gantry columns: are they accident damage? Connections/Alignment/material defects observed?",
              barrierDistress,
              barrierCritical,
              barrierClosed),
          //2. Gantry Beams
          SectionData.create(
              '2. Gantry Beams',
              'Connections to the columns: material defects? impact damage? large deflections? Corrosion? flexible sealant? coatings/paint deterioration observed?',
              gantryBeamDistress,
              gantryBeamCritical,
              gantryBeamClosed),
          //3. Gantry Columns
          SectionData.create(
              '3. Gantry Columns',
              'Columns supporting the beam Base Plates/Gussets: material defects? impact damage? Buckling? Corrosion? cracked welds? coatings/paint deterioration observed?',
              gantryColumnDistress,
              gantryColumnCritical,
              gantryColumnClosed),
          //4. Footings
          SectionData.create(
              '4. Footings',
              'Gantry column foundations below ground? Concrete: material defects, cracking, spalling, movement or settlement?',
              footingsDistress,
              footingsCritical,
              footingsClosed),
          //5. Anchor Bolts/Mortar
          SectionData.create(
              '5. Anchor Bolts and Mortar Grout Pads',
              'Gantry column anchor bolts below ground? Bolts, Nuts, Washers: material defects, missing, corrosion, projection of thread Grout Fill: material defects, cracking or spalling observed?',
              anchorMortarDistress,
              anchorMortarCritical,
              anchorMortarClosed),
          //6. Maintenance Access
          SectionData.create(
              '6. Maintenance Access',
              'walkway balustrades: material defects, corrosion, missing seals, coatings/paint, locks deteoration observed?',
              maintenanceAccessDistress,
              maintenanceAccessCritical,
              maintenanceAccessClosed),
          //7. Static Signs
          SectionData.create(
              '7. Static Signs',
              'Static signs, sign lights: material defects, corrosion, mounting brackets (welded, bolted, clipped, etc.), support angles, reflective paint, graffiti, generally no readable?',
              staticSignsDistress,
              staticSignsCritical,
              staticSignsClosed),
          //8. VMS
          SectionData.create(
              '8. Variable Message Signs (VMSs)',
              'Variable Message Signs: material defects, corrosion, mounting brackets (welded, bolted, clipped, etc.), support angles, exposed wires, graffiti, generally no readable?',
              vmsDistress,
              vmsCritical,
              vmsClosed),
        ],
      ),
    ];
  }
}

class InspectionGroup {
  final String headerTitle;
  final List<SectionData> items;

  InspectionGroup({
    required this.headerTitle,
    required this.items,
  });
}

class SectionData {
  final String title;
  final String? titleDistress;
  final String? value1;
  final String? value2;
  final String? value3;

  SectionData({
    required this.title,
    required this.titleDistress,
    required this.value1,
    required this.value2,
    required this.value3,
  });

  static SectionData create(String title, String titleDistress, String? value1,
      String? value2, String? value3) {
    return SectionData(
      title: title,
      titleDistress: titleDistress,
      value1: value1 == null || value1 == ""
          ? "N/A"
          : (value1 == "1" ? "YES" : "NO"),
      value2:
          value2 == null || value2 == "" ? "N/A" : (value2 == "1" ? "✓" : "-"),
      value3:
          value3 == null || value3 == "" ? "N/A" : (value3 == "1" ? "✓" : "-"),
    );
  }
}
