import 'package:equatable/equatable.dart';

class RoadLengthStatewideModel extends Equatable {
  const RoadLengthStatewideModel({
    required this.httpStatus,
    required this.totalLengthStatewidePavedUnpaved,
    required this.totalLengthPaved,
    required this.totalLengthUnpaved,
  });

  final String httpStatus;
  final double totalLengthStatewidePavedUnpaved;
  final double totalLengthPaved;
  final double totalLengthUnpaved;

  factory RoadLengthStatewideModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> data = json["data"];
    return RoadLengthStatewideModel(
      httpStatus: json["http_status"] ?? "",
      totalLengthStatewidePavedUnpaved:
          data[0]["totalLengthStatewidePavedUnpaved"] ?? 0,
      totalLengthPaved: data[0]["totalLengthPaved"] ?? 0,
      totalLengthUnpaved: data[0]["totalLengthUnpaved"] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        totalLengthStatewidePavedUnpaved,
        totalLengthPaved,
        totalLengthUnpaved,
      ];
}
