import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tram/model/basic/auth_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tram/noti_services/push_service.dart';

class AuthController extends GetxController {
  final box = GetStorage("Auth");
  bool isLogin() => _readToken() != null;

  String? accessName() => box.read("name");

  String? accessToken() => _readToken();

  String? getUserGroup() => box.read("user_group");

  String? getUserPackage() => box.read("user_package");

  String? getUserType() => box.read("user_type");

  String? _readToken() {
    return box.read("access_token");
  }

  String? getUserDesignation() => box.read("user_designation");

  Future<void> login(AuthModel data) async {
    // await box.write("token_type", data.tokenType);
    // await box.write("access_token", data.accessToken);
    await box.write("access_token", data.tokenData!.accessToken);
    await box.write("name", data.userProfileData!.mUsername);
    await box.write("user_group", data.userProfileData!.mUserGroup);
    await box.write("user_package", data.userProfileData!.mUserPackage);
    await box.write("user_designation", data.userProfileData!.mUserDesignation);
    await box.write("user_type", data.userProfileData!.mUserType);
    await box.save();

    if (!kIsWeb) {
      try {
        await FirebaseMessaging.instance.subscribeToTopic('all_users');
      } catch (e) {
        debugPrint('FCM subscribe failed: $e');
      }
      await PushService.registerDevice(
        data.userProfileData!.mUsername,
        userType: data.userProfileData!.mUserType,
        userPackage: data.userProfileData!.mUserPackage,
      );
    }

    debugPrint('Login - userType: "${data.userProfileData!.mUserType}"');
  }

  Future<void> logout() async {
    SmartDialog.showLoading(
      clickMaskDismiss: false,
    );

    if (!kIsWeb) {
      try {
        await FirebaseMessaging.instance.unsubscribeFromTopic('all_users');
      } catch (e) {
        debugPrint('FCM unsubscribe failed: $e');
      }
      final username = accessName(); // NEW
      if (username != null) {        // NEW
        await PushService.unregisterDevice(username); // NEW
      }                              // NEW
    }
    await box.erase();
    await box.erase();
    await box.save();
    Get.offAllNamed("/login");
    SmartDialog.dismiss();
  }
}
