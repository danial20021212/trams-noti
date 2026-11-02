import 'package:equatable/equatable.dart';

class FormBMainListingDataModel extends Equatable {
  const FormBMainListingDataModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<FormBMainListingModel> data;

  FormBMainListingDataModel copyWith({
    String? httpStatus,
    List<FormBMainListingModel>? data,
  }) {
    return FormBMainListingDataModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory FormBMainListingDataModel.fromJson(Map<String, dynamic> json) {
    return FormBMainListingDataModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<FormBMainListingModel>.from(
          json["data"]!.map((x) => FormBMainListingModel.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
    httpStatus,
    data,
  ];
}

class FormBMainListingModel {
  FormBMainListingModel({
    required this.inspectionDate,
    required this.package,
    required this.district,
    required this.roadName,
    required this.referenceNo,
    required this.recID,
    required this.parentID,
    required this.bridgeName,
  });

  final String inspectionDate;
  final String package;
  final String district;
  final String referenceNo;
  final String roadName;
  final String recID;
  final String parentID;
  final String bridgeName;

  FormBMainListingModel copyWith({
    String? inspectionDate,
    String? package,
    String? district,
    String? roadName,
    String? referenceNo,
    String? recID,
    String? parentID,
    String? bridgeName,
  }) {
    return FormBMainListingModel(
      inspectionDate: inspectionDate ?? this.inspectionDate,
      package: package ?? this.package,
      district: district ?? this.district,
      roadName: roadName ?? this.roadName,
      referenceNo: referenceNo ?? this.referenceNo,
      recID: recID ?? this.recID,
      parentID: parentID ?? this.parentID,
      bridgeName: bridgeName ?? this.bridgeName,
    );
  }

  factory FormBMainListingModel.fromJson(Map<String, dynamic> json) {
    return FormBMainListingModel(
      inspectionDate: json['inspection_date']?.toString() ?? "-",
      package: json["package"]?.toString() ?? "-",
      district: json["district"]?.toString() ?? "-",
      roadName: json["roadName"]?.toString() ?? "-",
      referenceNo: json["reference_no"]?.toString() ?? "-",
      recID: json["recID"]?.toString() ?? "-",
      parentID: json["parentID"]?.toString() ?? "-",
      bridgeName: json['bridge_name']?.toString() ?? "-",
    );
  }

  List<Object?> get props => [
    inspectionDate,
    package,
    district,
    roadName,
    referenceNo,
    recID,
    parentID,
    bridgeName
  ];
}
