import 'package:equatable/equatable.dart';

class FormCMainListingDataModel extends Equatable {
  const FormCMainListingDataModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<FormCMainListingModel> data;

  FormCMainListingDataModel copyWith({
    String? httpStatus,
    List<FormCMainListingModel>? data,
  }) {
    return FormCMainListingDataModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory FormCMainListingDataModel.fromJson(Map<String, dynamic> json) {
    return FormCMainListingDataModel(
      httpStatus: json["http_status"]?.toString() ?? "",
      data: json["data"] == null
          ? []
          : List<FormCMainListingModel>.from(
        json["data"].map(
              (x) => FormCMainListingModel.fromJson(x),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [httpStatus, data];
}

class FormCMainListingModel extends Equatable {
  const FormCMainListingModel({
    required this.projectName,
    required this.package,
    required this.district,
    required this.roadName,
    required this.referenceNo,
    required this.recID,
  });

  final String projectName;
  final String package;
  final String district;
  final String roadName;
  final String referenceNo;
  final String recID;

  FormCMainListingModel copyWith({
    String? projectName,
    String? package,
    String? district,
    String? roadName,
    String? referenceNo,
    String? recID,
  }) {
    return FormCMainListingModel(
      projectName: projectName ?? this.projectName,
      package: package ?? this.package,
      district: district ?? this.district,
      roadName: roadName ?? this.roadName,
      referenceNo: referenceNo ?? this.referenceNo,
      recID: recID ?? this.recID,
    );
  }

  factory FormCMainListingModel.fromJson(Map<String, dynamic> json) {
    return FormCMainListingModel(
      projectName: json["ProjectName"]?.toString() ?? "-",
      package: json["package"]?.toString() ?? "-",
      district: json["district"]?.toString() ?? "-",
      roadName: json["roadName"]?.toString() ?? "-",
      referenceNo: json["reference_no"]?.toString() ?? "-",
      recID: json["recID"]?.toString() ?? "-",
    );
  }

  @override
  List<Object?> get props => [
    projectName,
    package,
    district,
    roadName,
    referenceNo,
    recID,
  ];
}