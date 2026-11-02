import 'package:equatable/equatable.dart';

class FormMainListingDataModel extends Equatable {
  const FormMainListingDataModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<FormMainListingModel> data;

  FormMainListingDataModel copyWith({
    String? httpStatus,
    List<FormMainListingModel>? data,
  }) {
    return FormMainListingDataModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory FormMainListingDataModel.fromJson(Map<String, dynamic> json) {
    return FormMainListingDataModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<FormMainListingModel>.from(
              json["data"]!.map((x) => FormMainListingModel.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class FormMainListingModel {
  FormMainListingModel({
    required this.inspectionDate,
    required this.package,
    required this.district,
    required this.roadName,
    required this.referenceNo,
    required this.recID,
    this.insRecID,
    this.status = '',
  });

  final String inspectionDate;
  final String package;
  final String district;
  final String referenceNo;
  final String roadName;
  final String recID;
  String? insRecID;
  final String status;

  FormMainListingModel copyWith({
    String? inspectionDate,
    String? package,
    String? district,
    String? roadName,
    String? referenceNo,
    String? recID,
    String? bridgeName,
    String? insRecID,
    String? status,
  }) {
    return FormMainListingModel(
      inspectionDate: inspectionDate ?? this.inspectionDate,
      package: package ?? this.package,
      district: district ?? this.district,
      roadName: roadName ?? this.roadName,
      referenceNo: referenceNo ?? this.referenceNo,
      recID: recID ?? this.recID,
      insRecID: insRecID ?? this.insRecID,
      status: status ?? this.status,
    );
  }

  factory FormMainListingModel.fromJson(Map<String, dynamic> json) {
    return FormMainListingModel(
      inspectionDate: json['inspection_date']?.toString() ?? "",
      package: json["package"]?.toString() ?? "",
      district: json["district"]?.toString() ?? "",
      roadName: json["roadName"]?.toString() ?? "",
      referenceNo: json["reference_no"]?.toString() ?? "",
      recID: json["recID"]?.toString() ?? "",
      insRecID: json["insRecID"]?.toString() ?? "",
      status: (json["status"] ?? json["Status"])?.toString() ?? "",
    );
  }

  List<Object?> get props => [
        inspectionDate,
        package,
        district,
        roadName,
        referenceNo,
        recID,
        insRecID,
        status,
      ];
}
