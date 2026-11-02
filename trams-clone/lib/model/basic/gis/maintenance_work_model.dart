import 'package:equatable/equatable.dart';

class MaintenanceWorkModel extends Equatable {
  const MaintenanceWorkModel({
    required this.httpStatus,
    required this.fileName,
    required this.extraMessage,
  });

  final String httpStatus;

  final String fileName;
  final String extraMessage;

  MaintenanceWorkModel copyWith({
    String? httpStatus,
    String? fileName,
    String? extraMessage,
  }) {
    return MaintenanceWorkModel(
      httpStatus: httpStatus ?? this.httpStatus,
      fileName: fileName ?? this.fileName,
      extraMessage: extraMessage ?? this.extraMessage,
    );
  }

  factory MaintenanceWorkModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceWorkModel(
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
