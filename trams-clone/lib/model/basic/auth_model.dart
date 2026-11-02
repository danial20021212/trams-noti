import 'package:equatable/equatable.dart';
import 'package:tram/model/basic/user_model.dart';

class AuthModel extends Equatable {
  const AuthModel({
    required this.httpStatus, 
    required this.userProfileData,
    required this.tokenData,
  });

  final String httpStatus;
  final UserModel? userProfileData;
  final AuthTokenModel? tokenData;

  AuthModel copyWith({
    String? httpStatus,
    UserModel? userProfileData,
    AuthTokenModel? tokenData,
  }) {
    return AuthModel(
      httpStatus: httpStatus ?? this.httpStatus,
      userProfileData: userProfileData ?? this.userProfileData,
      tokenData: tokenData ?? this.tokenData,
    );
  }

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      httpStatus: json["http_status"] ?? "",
      userProfileData: json["user_profile_data"] == null
          ? null
          : UserModel.fromJson(json["user_profile_data"]),
      tokenData: json["token_data"] == null
          ? null
          : AuthTokenModel.fromJson(json["token_data"]),
    );
  }

  @override
  List<Object?> get props => [
        httpStatus,
        userProfileData,
        tokenData,
      ];
}

class AuthTokenModel extends Equatable {
  const AuthTokenModel({
    required this.accessToken, 
    required this.expiresIn,
    required this.tokenType,
    required this.scope,
    required this.refreshToken,
  });

  final String accessToken;
  final int expiresIn;
  final String tokenType;
  final dynamic scope;
  final String refreshToken;

  AuthTokenModel copyWith({
    String? accessToken,
    int? expiresIn,
    String? tokenType,
    dynamic? scope,
    String? refreshToken,
  }) {
    return AuthTokenModel(
      accessToken: accessToken ?? this.accessToken,
      expiresIn: expiresIn ?? this.expiresIn,
      tokenType: tokenType ?? this.tokenType,
      scope: scope ?? this.scope,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
      accessToken: json["access_token"] ?? "",
      expiresIn: json["expires_in"] ?? 0,
      tokenType: json["token_type"] ?? "",
      scope: json["scope"],
      refreshToken: json["refresh_token"] ?? "",
    );
  }

  @override
  List<Object?> get props => [
        accessToken,
        expiresIn,
        tokenType,
        scope,
        refreshToken,
      ];
}
