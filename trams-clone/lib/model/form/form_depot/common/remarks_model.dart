// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class RemarksModel extends Equatable {
  RemarksModel({
    this.httpStatus,
    this.data,
  });

  String? httpStatus;
  List<Remarks>? data;

  RemarksModel copyWith({
    String? httpStatus,
    List<Remarks>? data,
  }) {
    return RemarksModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory RemarksModel.fromJson(Map<String, dynamic> json) {
    return RemarksModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<Remarks>.from(json["data"]!.map((x) => Remarks.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class Remarks extends Equatable {
  Remarks({
    required this.recID,
    required this.spRemarksPartB,
    required this.consRemarksPartB,
    required this.spRemarksPartC,
    required this.consRemarksPartC,
    required this.spRemarksPartD,
    required this.consRemarksPartD,
  });

  String recID;
  String spRemarksPartB;
  String consRemarksPartB;
  String spRemarksPartC;
  String consRemarksPartC;
  String spRemarksPartD;
  String consRemarksPartD;

  Remarks copyWith({
    String? recID,
    String? spRemarksPartB,
    String? consRemarksPartB,
    String? spRemarksPartC,
    String? consRemarksPartC,
    String? spRemarksPartD,
    String? consRemarksPartD,
  }) {
    return Remarks(
      recID: recID ?? this.recID,
      spRemarksPartB: spRemarksPartB ?? this.spRemarksPartB,
      consRemarksPartB: consRemarksPartB ?? this.consRemarksPartB,
      spRemarksPartC: spRemarksPartC ?? this.spRemarksPartC,
      consRemarksPartC: consRemarksPartC ?? this.consRemarksPartC,
      spRemarksPartD: spRemarksPartD ?? this.spRemarksPartD,
      consRemarksPartD: consRemarksPartD ?? this.consRemarksPartD,
    );
  }

  factory Remarks.fromJson(Map<String, dynamic> json) {
    return Remarks(
      recID: json["recID"] ?? "",
      spRemarksPartB: json["PartB_DistressObserved_SP"] ?? json["sp_remarks_partB"] ?? "",
      consRemarksPartB: json["PartB_DistressObserved_EC"] ?? json["cons_remarks_partB"] ?? "",
      spRemarksPartC: json["PartC_GeneralComment_SP"] ?? json["sp_remarks_partC"] ?? "",
      consRemarksPartC: json["PartC_GeneralComment_EC"] ?? json["cons_remarks_partC"] ?? "",
      spRemarksPartD: json["PartD_Feedback_SP"] ?? json["sp_remarks_partD"] ?? "",
      consRemarksPartD: json["PartD_Feedback_EC"] ?? json["cons_remarks_partD"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "recID": recID,
      "sp_remarks_partB": spRemarksPartB,
      "cons_remarks_partB": consRemarksPartB,
      "sp_remarks_partC": spRemarksPartC,
      "cons_remarks_partC": consRemarksPartC,
      "sp_remarks_partD": spRemarksPartD,
      "cons_remarks_partD": consRemarksPartD,
    };
  }

  @override
  List<Object?> get props => [
        recID,
        spRemarksPartB,
        consRemarksPartB,
        spRemarksPartC,
        consRemarksPartC,
        spRemarksPartD,
        consRemarksPartD,
      ];
}
