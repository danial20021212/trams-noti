import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:tram/constant/fcm_config.dart';

/// One row of the notifications list.
/// formType is "B", "C", "G" or "R" (null for notifications saved before tabs existed).
class AppNotification {
  final int id;
  final String fromUsername;
  final String title;
  final String body;
  final String? formType;
  final bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.fromUsername,
    required this.title,
    required this.body,
    required this.formType,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> j) => AppNotification(
        id: j['id'] as int,
        fromUsername: (j['fromUsername'] ?? '') as String,
        title: (j['title'] ?? '') as String,
        body: (j['body'] ?? '') as String,
        formType: j['formType'] as String?,
        isRead: (j['isRead'] ?? false) as bool,
        createdAt: DateTime.parse(j['createdAt'] as String).toLocal(),
      );
}

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


  /// On iOS the FCM token only works once Apple's token is ready.
  static Future<String?> _getFcmToken() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      String? apns;
      for (var i = 0; i < 10 && apns == null; i++) {
        apns = await FirebaseMessaging.instance.getAPNSToken();
        if (apns == null) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
      if (apns == null) return null;
    }
    return FirebaseMessaging.instance.getToken();
  }

  /// Link this phone's FCM token to the logged-in user.
  static Future<void> registerDevice(String username,
    {String? userType, String? userPackage}) async {
    if (kIsWeb) return;
    try {
      final token = await _getFcmToken();
      if (token == null) return;
      await _dio.post(
        '/devices',
        data: {
          'token': token,
          'platform': defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android',
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
      final token = await _getFcmToken();
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
        '/notifications/formB/submit',
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


  /// Load this user's notifications, newest first.
  /// Throws an Exception with a short message if the server cannot be reached.
  static Future<List<AppNotification>> fetchNotifications(String username) async {
    try {
      final r = await _dio.get(
        '/notifications',
        options: Options(headers: _authHeaders(username)),
      );
      final list = (r.data['notifications'] as List?) ?? const [];
      return list
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final serverError = e.response?.data is Map ? e.response?.data['error'] : null;
      throw Exception(serverError ?? e.message ?? 'Cannot reach server');
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