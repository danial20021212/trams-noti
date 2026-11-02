import 'package:equatable/equatable.dart';

class RmiDivisionModel extends Equatable {
  const RmiDivisionModel({
    required this.httpStatus,
    required this.dataReader,
    required this.error,
  });

  final String httpStatus;
  final List<RmiDivisionReaderModel> dataReader;
  final String error;

  RmiDivisionModel copyWith({
    String? httpStatus,
    List<RmiDivisionReaderModel>? dataReader,
    String? error,
  }) {
    return RmiDivisionModel(
      httpStatus: httpStatus ?? this.httpStatus,
      dataReader: dataReader ?? this.dataReader,
      error: error ?? this.error,
    );
  }

  factory RmiDivisionModel.fromJson(Map<String, dynamic> json) {
    final type = json["dataReader"].runtimeType;
    return RmiDivisionModel(
      httpStatus: json["http_status"] ?? "",
      dataReader: (json["dataReader"] == null || type != List)
          ? []
          : List<RmiDivisionReaderModel>.from(
              json["dataReader"]!.map(
                (x) => RmiDivisionReaderModel.fromJson(x),
              ),
            ),
      error: type == String ? json["dataReader"] : "",
    );
  }

  @override
  List<Object?> get props => [
        error,
        httpStatus,
        dataReader,
      ];
}

class RmiDivisionReaderModel extends Equatable {
  const RmiDivisionReaderModel({
    required this.pdpm,
    required this.resultPercent,
    required this.achievementStatus,
    required this.allowableRange,
    required this.description,
    required this.pdpmName,
  });

  final String pdpm;
  final String resultPercent;
  final String achievementStatus;
  final int allowableRange;
  final String description;
  final String pdpmName;

  RmiDivisionReaderModel copyWith({
    String? pdpm,
    String? resultPercent,
    String? achievementStatus,
    int? allowableRange,
    String? description,
    String? pdpmName,
  }) {
    return RmiDivisionReaderModel(
      pdpm: pdpm ?? this.pdpm,
      resultPercent: resultPercent ?? this.resultPercent,
      achievementStatus: achievementStatus ?? this.achievementStatus,
      allowableRange: allowableRange ?? this.allowableRange,
      description: description ?? this.description,
      pdpmName: pdpmName ?? this.pdpmName,
    );
  }

  factory RmiDivisionReaderModel.fromJson(Map<String, dynamic> json) {
    return RmiDivisionReaderModel(
      pdpm: json["PDPM"] ?? "",
      resultPercent: json["ResultPercent"] ?? "",
      achievementStatus: json["AchievementStatus"] ?? "",
      allowableRange: json["AllowableRange"] ?? 0,
      description: json["Description"] ?? "",
      pdpmName: json["PDPMName"] ?? "",
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
      ];
}
