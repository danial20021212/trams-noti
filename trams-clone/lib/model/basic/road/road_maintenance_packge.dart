import 'package:equatable/equatable.dart';

class RoadMaintenancePackgeModel extends Equatable {
  const RoadMaintenancePackgeModel({
    required this.httpStatus,
    required this.dataReaderRmi,
  });

  final String httpStatus;
  final List<RMIChartData> dataReaderRmi;

  RoadMaintenancePackgeModel copyWith({
    String? httpStatus,
    List<RMIChartData>? dataReaderRmi,
  }) {
    return RoadMaintenancePackgeModel(
      httpStatus: httpStatus ?? this.httpStatus,
      dataReaderRmi: dataReaderRmi ?? this.dataReaderRmi,
    );
  }

  factory RoadMaintenancePackgeModel.fromJson(Map<String, dynamic> json) {
    return RoadMaintenancePackgeModel(
      httpStatus: json["http_status"] ?? "",
      dataReaderRmi: json["dataReaderRMI"] == null
          ? []
          : List<RMIChartData>.from(
              json["dataReaderRMI"]!.map((x) => RMIChartData.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        dataReaderRmi,
      ];
}

class RMIChartData extends Equatable {
  const RMIChartData({
    required this.package,
    required this.pdpm,
    required this.resultPercent,
    required this.achievementStatus,
    required this.allowableRange,
    required this.description,
    required this.pdpmName,
    required this.pdpmid,
  });

  final String package;
  final String pdpm;
  final int resultPercent;
  final String achievementStatus;
  final int allowableRange;
  final String description;
  final String pdpmName;
  final int pdpmid;

  RMIChartData copyWith({
    String? package,
    String? pdpm,
    int? resultPercent,
    String? achievementStatus,
    int? allowableRange,
    String? description,
    String? pdpmName,
    int? pdpmid,
  }) {
    return RMIChartData(
      package: package ?? this.package,
      pdpm: pdpm ?? this.pdpm,
      resultPercent: resultPercent ?? this.resultPercent,
      achievementStatus: achievementStatus ?? this.achievementStatus,
      allowableRange: allowableRange ?? this.allowableRange,
      description: description ?? this.description,
      pdpmName: pdpmName ?? this.pdpmName,
      pdpmid: pdpmid ?? this.pdpmid,
    );
  }

  factory RMIChartData.fromJson(Map<String, dynamic> json) {
    return RMIChartData(
      package: json["Package"] ?? "",
      pdpm: json["PDPM"] ?? "",
      resultPercent: json["ResultPercent"] ?? 0,
      achievementStatus: json["AchievementStatus"] ?? "",
      allowableRange: json["AllowableRange"] ?? 0,
      description: json["Description"] ?? "",
      pdpmName: json["PDPMName"] ?? "",
      pdpmid: json["PDPMID"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        package,
        pdpm,
        resultPercent,
        achievementStatus,
        allowableRange,
        description,
        pdpmName,
        pdpmid,
      ];
}
