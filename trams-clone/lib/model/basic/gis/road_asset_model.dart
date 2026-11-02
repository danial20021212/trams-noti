import 'package:equatable/equatable.dart';

class RoadAssetModel extends Equatable {
  const RoadAssetModel({
    required this.httpStatus,
    required this.fileName,
    required this.extraMessage,
  });

  final String httpStatus;

  final String fileName;
  final String extraMessage;

  RoadAssetModel copyWith({
    String? httpStatus,
    String? fileName,
    String? extraMessage,
  }) {
    return RoadAssetModel(
      httpStatus: httpStatus ?? this.httpStatus,
      fileName: fileName ?? this.fileName,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }

  factory RoadAssetModel.fromJson(Map<String, dynamic> json) {
    return RoadAssetModel(
      httpStatus: json["http_status"] ?? "",
      fileName: json["file_name"] ?? "",
      extraMessage: json["extra_message"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        fileName,
        extraMessage,
      ];
}
