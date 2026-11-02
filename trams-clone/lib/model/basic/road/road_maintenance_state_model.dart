import 'package:equatable/equatable.dart';

class RoadMaintenanceStateModel extends Equatable {
  const RoadMaintenanceStateModel({
    required this.httpStatus,
    required this.dataSurveyYr,
    required this.dataAvgRmi,
  });

  final String httpStatus;
  final String dataSurveyYr;
  final int dataAvgRmi;

  RoadMaintenanceStateModel copyWith({
    String? httpStatus,
    String? dataSurveyYr,
    int? dataAvgRmi,
  }) {
    return RoadMaintenanceStateModel(
      httpStatus: httpStatus ?? this.httpStatus,
      dataSurveyYr: dataSurveyYr ?? this.dataSurveyYr,
      dataAvgRmi: dataAvgRmi ?? this.dataAvgRmi,
    );
  }

  factory RoadMaintenanceStateModel.fromJson(Map<String, dynamic> json) {
    return RoadMaintenanceStateModel(
      httpStatus: json["http_status"] ?? "",
      dataSurveyYr: json["dataSurveyYr"] ?? "",
      dataAvgRmi: json["dataAvgRMI"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        dataSurveyYr,
        dataAvgRmi,
      ];
}
