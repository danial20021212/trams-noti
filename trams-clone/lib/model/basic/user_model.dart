import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel(
      {required this.mUsername,
      required this.mFullName,
      required this.mServiceProvider,
      required this.mUserGroup,
      required this.mUserPackage,
      required this.mUserPhone,
      required this.mUserEmail,
      required this.mUserDesignation,
      required this.mUserType});

  final String mUsername;
  final String mFullName;
  final String mServiceProvider;
  final String mUserGroup;
  final String mUserPackage;
  final String mUserPhone;
  final String mUserEmail;
  final String mUserDesignation;
  final String mUserType;

  UserModel copyWith({
    String? mUsername,
    String? mFullName,
    String? mServiceProvider,
    String? mUserGroup,
    String? mUserPackage,
    String? mUserPhone,
    String? mUserEmail,
    String? mUserDesignation,
    String? mUserType,
  }) {
    return UserModel(
        mUsername: mUsername ?? this.mUsername,
        mFullName: mFullName ?? this.mFullName,
        mServiceProvider: mServiceProvider ?? this.mServiceProvider,
        mUserGroup: mUserGroup ?? this.mUserGroup,
        mUserPackage: mUserPackage ?? this.mUserPackage,
        mUserPhone: mUserPhone ?? this.mUserPhone,
        mUserEmail: mUserEmail ?? this.mUserEmail,
        mUserDesignation: mUserDesignation ?? this.mUserDesignation,
        mUserType: mUserType ?? this.mUserType);
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        mUsername: json["m_username"] ?? "",
        mFullName: json["m_fullName"] ?? "",
        mServiceProvider: json["m_serviceProvider"] ?? "",
        mUserGroup: json["m_userGroup"] ?? "",
        mUserPackage: json["m_userPackage"] ?? "",
        mUserPhone: json["m_userPhone"] ?? "",
        mUserEmail: json["m_userEmail"] ?? "",
        mUserDesignation: json["m_userDesignation"] ?? "",
        mUserType: json["m_userType"] ?? "");
  }

  @override
  List<Object?> get props => [
        mUsername,
        mFullName,
        mServiceProvider,
        mUserGroup,
        mUserPackage,
        mUserPhone,
        mUserEmail,
        mUserDesignation,
        mUserType
      ];
}
