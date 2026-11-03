import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tram/provider/no_auth_provider.dart';

import 'constant/routes.dart';
import 'controller/auth/auth_controller.dart';
import 'provider/api_provider.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';

import 'package:tram/noti_services/push_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // configured Firebase for Android, so skip it on Chrome/web.
  if (!kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  await GetStorage.init();
  await GetStorage.init("Auth");
  PushService.listenTokenRefresh(
    () => GetStorage("Auth").read("name"),
    () => GetStorage("Auth").read("user_type"),
    () => GetStorage("Auth").read("user_package"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      themeMode: ThemeMode.light,
      theme: const NeumorphicThemeData(
        lightSource: LightSource.topLeft,
        accentColor: NeumorphicColors.accent,
        appBarTheme: NeumorphicAppBarThemeData(
          buttonStyle: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
          textStyle: TextStyle(color: Colors.black54),
          iconTheme: IconThemeData(color: Colors.black54, size: 30),
        ),
        depth: 4,
        intensity: 0.9,
      ),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        onInit: onInit,
        onReady: onReady,
        onDispose: onDispose,
        navigatorKey: _navigatorKey,
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        title: 'PRIMS',
        theme: ThemeData(
          useMaterial3: false,
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        getPages: routes,
      ),
    );
  }

  void onInit() {
    Get.put(NoAuthProvider(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(ApiProvider(), permanent: true);
  }

  void onReady() {}

  void onDispose() {
    Get.delete<NoAuthProvider>();
    Get.delete<ApiProvider>();
    Get.delete<AuthController>();
  }
}
