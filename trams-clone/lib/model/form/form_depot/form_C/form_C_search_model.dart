import 'package:equatable/equatable.dart';

class FormCSearchDataModel extends Equatable {
  const FormCSearchDataModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<FormCSearchModel> data;

  FormCSearchDataModel copyWith({
    String? httpStatus,
    List<FormCSearchModel>? data,
  }) {
    return FormCSearchDataModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory FormCSearchDataModel.fromJson(Map<String, dynamic> json) {
    return FormCSearchDataModel(
      httpStatus: json["http_status"]?.toString() ?? "",
      data: json["data"] == null
          ? []
          : List<FormCSearchModel>.from(
        json["data"].map((x) => FormCSearchModel.fromJson(x)),
      ),
    );
  }

  @override
  List<Object?> get props => [httpStatus, data];
}

class FormCSearchModel extends Equatable {
  const FormCSearchModel({
    required this.inspectionDate,
    required this.package,
    required this.district,
    required this.roadName,
    required this.referenceNo,
    required this.recID,
  });

  final String inspectionDate;
  final String package;
  final String district;
  final String roadName;
  final String referenceNo;
  final String recID;

  FormCSearchModel copyWith({
    String? inspectionDate,
    String? package,
    String? district,
    String? roadName,
    String? referenceNo,
    String? recID,
  }) {
    return FormCSearchModel(
      inspectionDate: inspectionDate ?? this.inspectionDate,
      package: package ?? this.package,
      district: district ?? this.district,
      roadName: roadName ?? this.roadName,
      referenceNo: referenceNo ?? this.referenceNo,
      recID: recID ?? this.recID,
    );
  }

  factory FormCSearchModel.fromJson(Map<String, dynamic> json) {
    return FormCSearchModel(
      inspectionDate: json["inspection_date"]?.toString() ?? "",
      package: json["package"]?.toString() ?? "",
      district: json["district"]?.toString() ?? "",
      roadName: json["roadName"]?.toString() ?? "",
      referenceNo: json["reference_no"]?.toString() ?? "",
      recID: json["recID"]?.toString() ?? "",
    );
  }

  @override
  List<Object?> get props => [
    inspectionDate,
    package,
    district,
    roadName,
    referenceNo,
    recID,
  ];
}