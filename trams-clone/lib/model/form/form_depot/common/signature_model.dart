import 'package:equatable/equatable.dart';

class SignatureModel extends Equatable {
  const SignatureModel({
    required this.httpStatus,
    required this.data,
  });

  final String httpStatus;
  final List<Signature> data;

  SignatureModel copyWith({
    String? httpStatus,
    List<Signature>? data,
  }) {
    return SignatureModel(
      httpStatus: httpStatus ?? this.httpStatus,
      data: data ?? this.data,
    );
  }

  factory SignatureModel.fromJson(Map<String, dynamic> json) {
    return SignatureModel(
      httpStatus: json["http_status"] ?? "",
      data: json["data"] == null
          ? []
          : List<Signature>.from(
              json["data"]!.map((x) => Signature.fromJson(x))),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        data,
      ];
}

class Signature extends Equatable {
  const Signature({required this.userSignature});

  final String userSignature;

  Signature copyWith({
    String? userSignature,
  }) {
    return Signature(userSignature: userSignature ?? this.userSignature);
  }

  factory Signature.fromJson(Map<String, dynamic> json) {
    return Signature(userSignature: json["user_signature"] ?? "");
  }

  @override
  List<Object?> get props => [userSignature];
}
