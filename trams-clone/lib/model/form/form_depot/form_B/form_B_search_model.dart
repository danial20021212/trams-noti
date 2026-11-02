import 'package:equatable/equatable.dart';

class FormBSearchDataModel extends Equatable {
  const FormBSearchDataModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<FormBSearchModel> data;

  FormBSearchDataModel copyWith({
    String? httpStatus,
    List<FormBSearchModel>? data,
  }) {
    return FormBSearchDataModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory FormBSearchDataModel.fromJson(Map<String, dynamic> json) {
    return FormBSearchDataModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<FormBSearchModel>.from(
          json["data"]!.map((x) => FormBSearchModel.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
    httpStatus,
    data,
  ];
}

class FormBSearchModel {
  FormBSearchModel({
    required this.package,
    required this.district,
    required this.roadName,
    required this.parentID,
    this.bridgeName,
  });

  final String package;
  final String district;
  final String roadName;
  final String parentID;
  String? bridgeName;

  FormBSearchModel copyWith({
    String? inspectionDate,
    String? package,
    String? district,
    String? roadName,
    String? referenceNo,
    String? recID,
    String? bridgeName,
  }) {
    return FormBSearchModel(
      package: package ?? this.package,
      district: district ?? this.district,
      roadName: roadName ?? this.roadName,
      parentID: referenceNo ?? this.parentID,
      bridgeName: bridgeName ?? this.bridgeName,
    );
  }

  factory FormBSearchModel.fromJson(Map<String, dynamic> json) {
    return FormBSearchModel(
      package: json["package"]?.toString() ?? "",
      district: json["district"]?.toString() ?? "",
      roadName: json["roadName"]?.toString() ?? "",
      parentID: json["parentID"]?.toString() ?? "",
      bridgeName: json['bridge_name']?.toString() ?? json['bridge_name']?.toString(),
    );
  }

  List<Object?> get props => [
    package,
    district,
    roadName,
    parentID,
    bridgeName
  ];
}
