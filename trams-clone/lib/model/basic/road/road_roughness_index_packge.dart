import 'package:equatable/equatable.dart';

class RoadRoughnessIndexPackgeModel extends Equatable {
  const RoadRoughnessIndexPackgeModel({
    required this.httpStatus,
    required this.dataReaderIri,
  });

  final String httpStatus;
  final List<IRIChartData> dataReaderIri;

  RoadRoughnessIndexPackgeModel copyWith({
    String? httpStatus,
    List<IRIChartData>? dataReaderIri,
  }) {
    return RoadRoughnessIndexPackgeModel(
      httpStatus: httpStatus ?? this.httpStatus,
      dataReaderIri: dataReaderIri ?? this.dataReaderIri,
    );
  }

  factory RoadRoughnessIndexPackgeModel.fromJson(Map<String, dynamic> json) {
    return RoadRoughnessIndexPackgeModel(
      httpStatus: json["http_status"] ?? "",
      dataReaderIri: json["dataReaderIRI"] == null
          ? []
          : List<IRIChartData>.from(
              json["dataReaderIRI"]!.map((x) => IRIChartData.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        dataReaderIri,
      ];
}

class IRIChartData extends Equatable {
  const IRIChartData({
    required this.pdpm,
    required this.resultPercent,
    required this.achievementStatus,
    required this.allowableRange,
    required this.description,
    required this.pdpmName,
    required this.pdpmid,
    required this.package,
  });

  final String pdpm;
  final int resultPercent;
  final String achievementStatus;
  final int allowableRange;
  final String description;
  final String pdpmName;
  final int pdpmid;
  final int package;

  IRIChartData copyWith({
    String? pdpm,
    int? resultPercent,
    String? achievementStatus,
    int? allowableRange,
    String? description,
    String? pdpmName,
    int? pdpmid,
    int? package,
  }) {
    return IRIChartData(
      pdpm: pdpm ?? this.pdpm,
      resultPercent: resultPercent ?? this.resultPercent,
      achievementStatus: achievementStatus ?? this.achievementStatus,
      allowableRange: allowableRange ?? this.allowableRange,
      description: description ?? this.description,
      pdpmName: pdpmName ?? this.pdpmName,
      pdpmid: pdpmid ?? this.pdpmid,
      package: package ?? this.package,
    );
  }

  factory IRIChartData.fromJson(Map<String, dynamic> json) {
    return IRIChartData(
      pdpm: json["PDPM"] ?? "",
      resultPercent: json["ResultPercent"] ?? 0,
      achievementStatus: json["AchievementStatus"] ?? "",
      allowableRange: json["AllowableRange"] ?? 0,
      description: json["Description"] ?? "",
      pdpmName: json["PDPMName"] ?? "",
      pdpmid: json["PDPMID"] ?? 0,
      package: json["Package"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        pdpm,
        resultPercent,
        achievementStatus,
        allowableRange,
        description,
        pdpmName,
        pdpmid,
        package,
      ];
}
