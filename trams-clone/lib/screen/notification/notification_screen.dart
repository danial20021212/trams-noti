import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../components/Neumorphic/navbar.dart';

import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/noti_services/push_service.dart';

/// Notifications page.
/// For now it has test buttons to ask permission and show this phone's FCM token.
/// The real list of notifications will go in the body later.
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _status = 'Permission: not asked yet';
  String? _token;

  String _sendResult = '';
  bool _sending = false;

  /// "submit form b": notify every Consultant in the same package as the submitter.
  Future<void> _submitFormB() async {
    final auth = Get.find<AuthController>();
    final from = auth.accessName();
    final package = auth.getUserPackage();
    if (from == null || package == null || package.isEmpty) {
      setState(() => _sendResult = 'Your account has no package, cannot send');
      return;
    }

    setState(() {
      _sending = true;
      _sendResult = '';
    });
    final result = await PushService.sendNotificationToType(
      fromUsername: from,
      toUserType: 'Consultant',
      toUserPackage: package,
      title: 'Form B submitted',
      body: '$from submitted Form B (Package $package)',
    );
    if (!mounted) return;
    setState(() {
      _sending = false;
      _sendResult = result;
    });
  }

  Future<void> _requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission();
    setState(() {
      _status = 'Permission: ${settings.authorizationStatus.name}';
    });
  }

  Future<void> _getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    setState(() => _token = token);
  }

  Future<void> _copyToken() async {
    if (_token == null) return;
    await Clipboard.setData(ClipboardData(text: _token!));
    Get.snackbar(
      'Copied',
      'FCM token copied to clipboard',
      colorText: Colors.black,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NeumorphicNavBar(
        title: 'Notifications',
        showDrawer: false, // shows a back arrow instead of the menu icon
        color: Color(0xfff3f8fe),
      ),
      backgroundColor: const Color(0xfff3f8fe),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('No notifications yet'),
            const SizedBox(height: 30),
            if (kIsWeb)
              const Text('FCM test buttons only work on the Android app.')
            else ...[
              // Notify the Consultants in the same package
              NeumorphicButton(
                onPressed: _sending ? null : _submitFormB,
                child: Text(_sending ? 'Sending...' : 'submit form b'),
              ),
              const SizedBox(height: 8),
              Text(_sendResult),
              const SizedBox(height: 30),

              // Existing test buttons
              Text(_status),
              const SizedBox(height: 12),
              NeumorphicButton(
                onPressed: _requestPermission,
                child: const Text('1. Allow notifications'),
              ),
              const SizedBox(height: 20),
              NeumorphicButton(
                onPressed: _getToken,
                child: const Text('2. Get FCM token'),
              ),
              const SizedBox(height: 12),
              if (_token != null) ...[
                SelectableText(
                  _token!,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 12),
                NeumorphicButton(
                  onPressed: _copyToken,
                  child: const Text('Copy token'),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}