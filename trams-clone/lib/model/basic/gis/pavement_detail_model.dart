import 'package:equatable/equatable.dart';

class PavementDetailModel extends Equatable {
  const PavementDetailModel({
    required this.httpStatus,
    required this.fileName,
    required this.videoFilePath,
    required this.extraMessage,
  });

  final String httpStatus;

  final String fileName;
  final String videoFilePath;
  final String extraMessage;

  PavementDetailModel copyWith({
    String? httpStatus,
    String? fileName,
    String? videoFilePath,
    String? extraMessage,
  }) {
    return PavementDetailModel(
      httpStatus: httpStatus ?? this.httpStatus,
      fileName: fileName ?? this.fileName,
      videoFilePath: videoFilePath ?? this.videoFilePath,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }

  factory PavementDetailModel.fromJson(Map<String, dynamic> json) {
    return PavementDetailModel(
      httpStatus: json["http_status"] ?? "",
      fileName: json["file_name"] ?? "",
      videoFilePath: json["video_file_path"] ?? "",
      extraMessage: json["extra_message"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        fileName,
        videoFilePath,
        extraMessage,
      ];
}
