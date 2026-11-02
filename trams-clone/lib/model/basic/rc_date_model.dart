import 'package:equatable/equatable.dart';

class RcDateModel extends Equatable {
  const RcDateModel({
    required this.httpStatus,
    required this.rcdate,
  });

  final String httpStatus;

  final DateTime? rcdate;

  RcDateModel copyWith({
    String? httpStatus,
    DateTime? rcdate,
  }) {
    return RcDateModel(
      httpStatus: httpStatus ?? this.httpStatus,
      rcdate: rcdate ?? this.rcdate,
    );
  }

  factory RcDateModel.fromJson(Map<String, dynamic> json) {
    return RcDateModel(
      httpStatus: json["http_status"] ?? "",
      rcdate: json["rcdate"] == null ? null : DateTime.parse(json["rcdate"]),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        rcdate,
      ];
}
