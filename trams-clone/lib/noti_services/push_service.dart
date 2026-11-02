import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:tram/constant/fcm_config.dart';

class PushService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: fcmServerUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  // TEST STAND-IN. Matches requireUser() in the server's auth.js.
  // Production: send the real access token here, e.g. {'Authorization': 'Bearer $accessToken'}.
  static Map<String, String> _authHeaders(String username) =>
      {'X-Test-User': username};

  /// Link this phone's FCM token to the logged-in user.
  static Future<void> registerDevice(String username,
    {String? userType, String? userPackage}) async {
    if (kIsWeb) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await _dio.post(
        '/devices',
        data: {
          'token': token,
          'platform': 'android',
          'userType': userType,
          'userPackage': userPackage,
        },
        options: Options(headers: _authHeaders(username)),
      );
      debugPrint('Push: device registered for $username');
    } catch (e) {
      debugPrint('Push: register failed: $e');
    }
  }

  /// Remove the link between this phone and the user (call before logging out).
  static Future<void> unregisterDevice(String username) async {
    if (kIsWeb) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      await _dio.delete(
        '/devices',
        data: {'token': token},
        options: Options(headers: _authHeaders(username)),
      );
      debugPrint('Push: device unregistered for $username');
    } catch (e) {
      debugPrint('Push: unregister failed: $e');
    }
  }


  /// Ask the server to send a notification to another user.
  /// Returns a short message to show on screen.
  static Future<String> sendNotification({
    required String fromUsername,
    required String toUsername,
    required String title,
    required String body,
  }) async {
    try {
      final r = await _dio.post(
        '/notifications',
        data: {'toUsername': toUsername, 'title': title, 'body': body},
        options: Options(headers: _authHeaders(fromUsername)),
      );
      final devices = r.data['devices'];
      return devices == 0
          ? 'Saved, but $toUsername has no phone logged in right now'
          : 'Sent to $toUsername';
    } on DioException catch (e) {
      final serverError = e.response?.data is Map ? e.response?.data['error'] : null;
      return 'Failed: ${serverError ?? e.message}';
    }
  }
  

    /// Ask the server to send a notification to every user of a given type
  /// (e.g. "Consultant"). Returns a short message to show on screen.
  static Future<String> sendNotificationToType({
    required String fromUsername,
    required String toUserType,
    required String toUserPackage,
    required String title,
    required String body,
  }) async {
    try {
      final r = await _dio.post(
        '/notifications/by-type',
        data: {
          'toUserType': toUserType,
          'toUserPackage': toUserPackage,
          'title': title,
          'body': body,
        },
        options: Options(headers: _authHeaders(fromUsername)),
      );
      final devices = r.data['devices'];
      return devices == 0
          ? 'No $toUserType in package $toUserPackage has a phone logged in right now'
          : 'Sent to ${r.data['users']} $toUserType user(s)';
    } on DioException catch (e) {
      final serverError = e.response?.data is Map ? e.response?.data['error'] : null;
      return 'Failed: ${serverError ?? e.message}';
    }
  }


  /// If Firebase rotates this phone's token, register the new one.
  /// getUsername returns the logged-in username, or null when logged out.
  static void listenTokenRefresh(
    String? Function() getUsername,
    String? Function() getUserType,
    String? Function() getUserPackage,
  ) {
    if (kIsWeb) return;
    FirebaseMessaging.instance.onTokenRefresh.listen((_) {
      final username = getUsername();
      if (username != null) {
        registerDevice(
          username,
          userType: getUserType(),
          userPackage: getUserPackage(),
        );
      }
    });
  }
}