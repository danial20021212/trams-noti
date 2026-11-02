import 'package:equatable/equatable.dart';

class WorkHistoryDataModel extends Equatable {
  const WorkHistoryDataModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<WorkHistoryModel> data;

  WorkHistoryDataModel copyWith({
    String? httpStatus,
    List<WorkHistoryModel>? data,
  }) {
    return WorkHistoryDataModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory WorkHistoryDataModel.fromJson(Map<String, dynamic> json) {
    return WorkHistoryDataModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? [] 
          : List<WorkHistoryModel>.from(
              json["data"]!.map((x) => WorkHistoryModel.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class WorkHistoryModel extends Equatable {
  const WorkHistoryModel({
    required this.surveyYear,
    required this.routeNo,
    required this.direction,
    required this.lane,
    required this.startKm,
    required this.endKm,
    required this.totalLength,
    required this.maintenanceType,
    required this.planStartDate,
    required this.planEndDate,
    required this.actualStartDate,
    required this.actualEndDate,
    required this.completion,
    required this.beforeImage,
    required this.afterImage,
  });

  final String surveyYear;
  final String routeNo;
  final String direction;
  final String lane;
  final String startKm;
  final String endKm;
  final int totalLength;
  final String maintenanceType;
  final String planStartDate;
  final String planEndDate;
  final String actualStartDate;
  final String actualEndDate;
  final String completion;
  final String beforeImage;
  final String afterImage;

  WorkHistoryModel copyWith({
    String? surveyYear,
    String? routeNo,
    String? direction,
    String? lane,
    String? startKm,
    String? endKm,
    int? totalLength,
    String? maintenanceType,
    String? planStartDate,
    String? planEndDate,
    String? actualStartDate,
    String? actualEndDate,
    String? completion,
    String? beforeImage,
    String? afterImage,
  }) {
    return WorkHistoryModel(
      surveyYear: surveyYear ?? this.surveyYear,
      routeNo: routeNo ?? this.routeNo,
      direction: direction ?? this.direction,
      lane: lane ?? this.lane,
      startKm: startKm ?? this.startKm,
      endKm: endKm ?? this.endKm,
      totalLength: totalLength ?? this.totalLength,
      maintenanceType: maintenanceType ?? this.maintenanceType,
      planStartDate: planStartDate ?? this.planStartDate,
      planEndDate: planEndDate ?? this.planEndDate,
      actualStartDate: actualStartDate ?? this.actualStartDate,
      actualEndDate: actualEndDate ?? this.actualEndDate,
      completion: completion ?? this.completion,
      beforeImage: beforeImage ?? this.beforeImage,
      afterImage: afterImage ?? this.afterImage,
    );
  }

  factory WorkHistoryModel.fromJson(Map<String, dynamic> json) {
    return WorkHistoryModel(
      surveyYear: json["survey_year"] ?? "",
      routeNo: json["route_no"] ?? "",
      direction: json["direction"] ?? "",
      lane: json["lane"] ?? "",
      startKm: json["start_km"] ?? "",
      endKm: json["end_km"] ?? "",
      totalLength: json["total_length"] ?? 0,
      maintenanceType: json["maintenance_type"] ?? "",
      planStartDate: json["plan_start_date"] ?? "",
      planEndDate: json["plan_end_date"] ?? "",
      actualStartDate: json["actual_start_date"] ?? "",
      actualEndDate: json["actual_end_date"] ?? "",
      completion: json["completion"] ?? "",
      beforeImage: json["before_image"] ?? "",
      afterImage: json["after_image"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        surveyYear,
        routeNo,
        direction,
        lane,
        startKm,
        endKm,
        totalLength,
        maintenanceType,
        planStartDate,
        planEndDate,
        actualStartDate,
        actualEndDate,
        completion,
        beforeImage,
        afterImage,
      ];
}
