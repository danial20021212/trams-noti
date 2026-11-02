import 'package:equatable/equatable.dart';

class RoadRoughnessStateModel extends Equatable {
  const RoadRoughnessStateModel({
    required this.httpStatus,
    required this.dataSurveyYr,
    required this.dataAvgIRI,
  });

  final String httpStatus;
  final String dataSurveyYr;
  final int dataAvgIRI;

  RoadRoughnessStateModel copyWith({
    String? httpStatus,
    String? dataSurveyYr,
    int? dataAvgIRI,
  }) {
    return RoadRoughnessStateModel(
      httpStatus: httpStatus ?? this.httpStatus,
      dataSurveyYr: dataSurveyYr ?? this.dataSurveyYr,
      dataAvgIRI: dataAvgIRI ?? this.dataAvgIRI,
    );
  }

  factory RoadRoughnessStateModel.fromJson(Map<String, dynamic> json) {
    return RoadRoughnessStateModel(
      httpStatus: json["http_status"] ?? "",
      dataSurveyYr: json["dataSurveyYr"] ?? "",
      dataAvgIRI: json["dataAvgIRI"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        dataSurveyYr,
        dataAvgIRI,
      ];
}
