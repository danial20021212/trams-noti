import 'package:equatable/equatable.dart';

class RoadAssetStatisticModel extends Equatable {
  const RoadAssetStatisticModel({
    required this.httpStatus,
    required this.dataReader,
    required this.error,
  });

  final String httpStatus;
  final List<RoadAssetStatisticDetailModel> dataReader;
  final String error;

  RoadAssetStatisticModel copyWith({
    String? httpStatus,
    List<RoadAssetStatisticDetailModel>? dataReader,
    String? error,
  }) {
    return RoadAssetStatisticModel(
      httpStatus: httpStatus ?? this.httpStatus,
      dataReader: dataReader ?? this.dataReader,
      error: error ?? this.error,
    );
  }

  factory RoadAssetStatisticModel.fromJson(Map<String, dynamic> json) {
    final type = json["dataReader"].runtimeType;

    return RoadAssetStatisticModel(
      httpStatus: json["http_status"] ?? "",
      dataReader: (json["dataReader"] == null || type != List)
          ? []
          : List<RoadAssetStatisticDetailModel>.from(json["dataReader"]!
              .map((x) => RoadAssetStatisticDetailModel.fromJson(x))),
      error: type == String ? json["dataReader"] : "",
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        dataReader,
        error,
      ];
}

class RoadAssetStatisticDetailModel extends Equatable {
  const RoadAssetStatisticDetailModel({
    required this.packageId,
    required this.districtId,
    required this.roadId,
    required this.conditionId,
    required this.surveyYr,
    required this.roadNo,
    required this.roadName,
    required this.roadLength,
  });

  final int packageId;
  final int districtId;
  final int roadId;
  final int conditionId;
  final int surveyYr;
  final String roadNo;
  final String roadName;
  final double roadLength;

  RoadAssetStatisticDetailModel copyWith({
    int? packageId,
    int? districtId,
    int? roadId,
    int? conditionId,
    int? surveyYr,
    String? roadNo,
    String? roadName,
    double? roadLength,
  }) {
    return RoadAssetStatisticDetailModel(
      packageId: packageId ?? this.packageId,
      districtId: districtId ?? this.districtId,
      roadId: roadId ?? this.roadId,
      conditionId: conditionId ?? this.conditionId,
      surveyYr: surveyYr ?? this.surveyYr,
      roadNo: roadNo ?? this.roadNo,
      roadName: roadName ?? this.roadName,
      roadLength: roadLength ?? this.roadLength,
    );
  }

  factory RoadAssetStatisticDetailModel.fromJson(Map<String, dynamic> json) {
    return RoadAssetStatisticDetailModel(
      packageId: json["Package_id"] ?? 0,
      districtId: json["District_id"] ?? 0,
      roadId: json["Road_id"] ?? 0,
      conditionId: json["Condition_id"] ?? 0,
      surveyYr: json["Survey_Yr"] ?? 0,
      roadNo: json["Road No"] ?? "",
      roadName: json["RoadName"] ?? "",
      roadLength: double.tryParse('${json["RoadLength"]}') ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        packageId,
        districtId,
        roadId,
        conditionId,
        surveyYr,
        roadNo,
        roadName,
        roadLength,
      ];
}
