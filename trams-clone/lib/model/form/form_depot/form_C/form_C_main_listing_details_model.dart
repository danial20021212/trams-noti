// ignore_for_file: camel_case_types

import 'package:equatable/equatable.dart';
import 'package:tram/model/form/form_depot/main_listing/form_main_listing_details_model.dart';
import 'package:tram/utils/parsers_utils.dart';

class Form_C_MainListingDetailsModel extends Equatable {
  const Form_C_MainListingDetailsModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<Form_C_MainListingDetailsDataModel> data;

  Form_C_MainListingDetailsModel copyWith({
    String? httpStatus,
    List<Form_C_MainListingDetailsDataModel>? data,
  }) {
    return Form_C_MainListingDetailsModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory Form_C_MainListingDetailsModel.fromJson(Map<String, dynamic> json) {
    return Form_C_MainListingDetailsModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<Form_C_MainListingDetailsDataModel>.from(json["data"]!
              .map((x) => Form_C_MainListingDetailsDataModel.fromJson(x))),
    );
  }

  List<Form_C_MainListingDetailsDataModel> recordsForSelection({
    required String parentRecID,
    required String referenceNo,
  }) {
    final normalizedParentID = parentRecID.trim().toLowerCase();
    final normalizedReferenceNo = referenceNo.trim().toLowerCase();
    final hasParentID =
        normalizedParentID.isNotEmpty && normalizedParentID != '-';
    final hasReferenceNo =
        normalizedReferenceNo.isNotEmpty && normalizedReferenceNo != '-';

    final exactMatches = data.where((record) {
      final matchesParent = !hasParentID ||
          record.recID?.trim().toLowerCase() == normalizedParentID;
      final matchesReference = !hasReferenceNo ||
          record.referenceNo?.trim().toLowerCase() == normalizedReferenceNo;
      return matchesParent && matchesReference;
    }).toList();
    if (exactMatches.isNotEmpty) return exactMatches;

    if (hasParentID) {
      final parentMatches = data
          .where((record) =>
              record.recID?.trim().toLowerCase() == normalizedParentID)
          .toList();
      if (parentMatches.isNotEmpty) return parentMatches;
    }

    if (hasReferenceNo) {
      final referenceMatches = data
          .where((record) =>
              record.referenceNo?.trim().toLowerCase() == normalizedReferenceNo)
          .toList();
      if (referenceMatches.isNotEmpty) return referenceMatches;
    }

    // Nothing in this response actually identifies as this road/structure.
    // Returning every record here (as this used to) would show a mix of
    // *other* roads' inspection data as if it belonged to this one - worse
    // than showing none. An empty list correctly renders as "no records
    // found" instead.
    return const <Form_C_MainListingDetailsDataModel>[];
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class Form_C_MainListingDetailsDataModel extends FormMainListingDetails {
  Form_C_MainListingDetailsDataModel({
    required this.recID,
    required this.insRecID,
    required this.projectName,
    required this.package,
    required this.district,
    required this.roadName,
    required this.inspectionDate,
    required this.referenceNo,
    required this.locationChainage,
    required this.structureCode,
    required this.finishedRoadLevel,
    required this.catchmentArea,
    required this.designFlow,
    required this.precastInSitu,
    required this.barrelNumberSize,
    required this.inletLevel,
    required this.outletLevel,
    required this.culvertSkew,
    required this.culvertLength,
    required this.gpsEasting,
    required this.gpsNorthing,
    required this.culvertType,
    required this.culvertMaterial,
    required this.inletStructure,
    required this.outletStructure,
    required this.status,
  });

  String? recID;
  String? insRecID;
  String? projectName;
  String? package;
  String? district;
  String? roadName;
  String? inspectionDate;
  String? referenceNo;
  String? locationChainage;
  String? structureCode;
  String? finishedRoadLevel;
  String? catchmentArea;
  String? designFlow;
  String? precastInSitu;
  String? barrelNumberSize;
  String? inletLevel;
  String? outletLevel;
  String? culvertSkew;
  String? culvertLength;
  String? gpsEasting;
  String? gpsNorthing;
  String? culvertType;
  String? culvertMaterial;
  String? inletStructure;
  String? outletStructure;
  String? status;

  factory Form_C_MainListingDetailsDataModel.fromJson(
      Map<String, dynamic> json) {
    return Form_C_MainListingDetailsDataModel(
      recID: ParsersUtils.parseToString(json["recID"]),
      insRecID: ParsersUtils.parseToString(
        json["insRecID"] ?? json["subID"] ?? json["inspectionID"],
      ),
      projectName: ParsersUtils.parseToString(json["ProjectName"]),
      package: ParsersUtils.parseToString(json["package"]),
      district: ParsersUtils.parseToString(json["district"]),
      roadName: ParsersUtils.parseToString(json["roadName"]),
      inspectionDate: ParsersUtils.parseToString(json['inspection_date']),
      referenceNo: ParsersUtils.parseToString(json["reference_no"]),
      locationChainage: ParsersUtils.parseToString(json["LocationChainage"]),
      structureCode: ParsersUtils.parseToString(json["StructureCode"]),
      finishedRoadLevel: ParsersUtils.parseToString(json["FinishedRoadLevel"]),
      catchmentArea: ParsersUtils.parseToString(json["CatchmentArea"]),
      designFlow: ParsersUtils.parseToString(json["DesignFlow"]),
      precastInSitu: ParsersUtils.parseToString(json["Precast_In_situ"]),
      barrelNumberSize: ParsersUtils.parseToString(json["BarrelNumber_Size"]),
      inletLevel: ParsersUtils.parseToString(json["InletLevel"]),
      outletLevel: ParsersUtils.parseToString(json["OutletLevel"]),
      culvertSkew: ParsersUtils.parseToString(json["CulvertSkew"]),
      culvertLength: ParsersUtils.parseToString(json["CulvertLength"]),
      gpsEasting: ParsersUtils.parseToString(json["GPS_Easting"]),
      gpsNorthing: ParsersUtils.parseToString(json["GPS_Northing"]),
      culvertType: ParsersUtils.parseToString(json["CulvertType"]),
      culvertMaterial: ParsersUtils.parseToString(json["CulvertMaterial"]),
      inletStructure: ParsersUtils.parseToString(json["InletStructure"]),
      outletStructure: ParsersUtils.parseToString(json["OutletStructure"]),
      status: ParsersUtils.parseToString(json["status"] ?? json["Status"]),
    );
  }

  List<Object?> get props => [
        recID,
        insRecID,
        projectName,
        package,
        district,
        roadName,
        inspectionDate,
        referenceNo,
        locationChainage,
        structureCode,
        finishedRoadLevel,
        catchmentArea,
        designFlow,
        precastInSitu,
        barrelNumberSize,
        inletLevel,
        outletLevel,
        culvertSkew,
        culvertLength,
        gpsEasting,
        gpsNorthing,
        culvertType,
        culvertMaterial,
        inletStructure,
        outletStructure,
        status,
      ];

  @override
  List<Map<String, String>> getKeyValuePairsInGeneral() {
    return [
      {"Project Name": projectName?.isNotEmpty == true ? projectName! : "-"},
      {"District": district?.isNotEmpty == true ? district! : "-"},
      {"Road": roadName?.isNotEmpty == true ? roadName! : "-"},
      {"Reference No": referenceNo?.isNotEmpty == true ? referenceNo! : "-"},
      {
        "Location Chainage":
            locationChainage?.isNotEmpty == true ? locationChainage! : "-"
      },
      {
        "Structure Code":
            structureCode?.isNotEmpty == true ? structureCode! : "-"
      },
      {
        "Finished Road Level":
            finishedRoadLevel?.isNotEmpty == true ? finishedRoadLevel! : "-"
      },
      {
        "Catchment Area":
            catchmentArea?.isNotEmpty == true ? catchmentArea! : "-"
      },
      {"Design Flow": designFlow?.isNotEmpty == true ? designFlow! : "-"},
      {
        "Precast / In-Situ":
            precastInSitu?.isNotEmpty == true ? precastInSitu! : "-"
      },
      {
        "Barrel Number & Size":
            barrelNumberSize?.isNotEmpty == true ? barrelNumberSize! : "-"
      },
      {"Inlet Level": inletLevel?.isNotEmpty == true ? inletLevel! : "-"},
      {"Outlet Level": outletLevel?.isNotEmpty == true ? outletLevel! : "-"},
      {"Culvert Skew": culvertSkew?.isNotEmpty == true ? culvertSkew! : "-"},
      {
        "Culvert Length":
            culvertLength?.isNotEmpty == true ? culvertLength! : "-"
      },
      {"GPS Easting": gpsEasting?.isNotEmpty == true ? gpsEasting! : "-"},
      {"GPS Northing": gpsNorthing?.isNotEmpty == true ? gpsNorthing! : "-"},
      {"Culvert Type": culvertType?.isNotEmpty == true ? culvertType! : "-"},
      {
        "Culvert Material":
            culvertMaterial?.isNotEmpty == true ? culvertMaterial! : "-"
      },
      {
        "Inlet Structure":
            inletStructure?.isNotEmpty == true ? inletStructure! : "-"
      },
      {
        "Outlet Structure":
            outletStructure?.isNotEmpty == true ? outletStructure! : "-"
      },
    ];
  }

  @override
  List<Map<String, String>> getKeyValuePairs() {
    return [
      {
        "Inspection Date":
            inspectionDate?.isNotEmpty == true ? inspectionDate! : "-"
      },
      {"Project Name": projectName?.isNotEmpty == true ? projectName! : "-"},
      {"Package": package?.isNotEmpty == true ? package! : "-"},
      {"District": district?.isNotEmpty == true ? district! : "-"},
      {"Road": roadName?.isNotEmpty == true ? roadName! : "-"},
      {"Reference No": referenceNo?.isNotEmpty == true ? referenceNo! : "-"},
      {
        "Location Chainage":
            locationChainage?.isNotEmpty == true ? locationChainage! : "-"
      },
      {
        "Structure Code":
            structureCode?.isNotEmpty == true ? structureCode! : "-"
      },
      {
        "Finished Road Level":
            finishedRoadLevel?.isNotEmpty == true ? finishedRoadLevel! : "-"
      },
      {
        "Catchment Area":
            catchmentArea?.isNotEmpty == true ? catchmentArea! : "-"
      },
      {"Design Flow": designFlow?.isNotEmpty == true ? designFlow! : "-"},
      {
        "Precast / In-Situ":
            precastInSitu?.isNotEmpty == true ? precastInSitu! : "-"
      },
      {
        "Barrel Number & Size":
            barrelNumberSize?.isNotEmpty == true ? barrelNumberSize! : "-"
      },
      {"Inlet Level": inletLevel?.isNotEmpty == true ? inletLevel! : "-"},
      {"Outlet Level": outletLevel?.isNotEmpty == true ? outletLevel! : "-"},
      {"Culvert Skew": culvertSkew?.isNotEmpty == true ? culvertSkew! : "-"},
      {
        "Culvert Length":
            culvertLength?.isNotEmpty == true ? culvertLength! : "-"
      },
      {"GPS Easting": gpsEasting?.isNotEmpty == true ? gpsEasting! : "-"},
      {"GPS Northing": gpsNorthing?.isNotEmpty == true ? gpsNorthing! : "-"},
      {"Culvert Type": culvertType?.isNotEmpty == true ? culvertType! : "-"},
      {
        "Culvert Material":
            culvertMaterial?.isNotEmpty == true ? culvertMaterial! : "-"
      },
      {
        "Inlet Structure":
            inletStructure?.isNotEmpty == true ? inletStructure! : "-"
      },
      {
        "Outlet Structure":
            outletStructure?.isNotEmpty == true ? outletStructure! : "-"
      },
      {"Status": status?.isNotEmpty == true ? status! : "-"},
    ];
  }
}
