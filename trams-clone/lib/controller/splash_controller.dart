import 'package:get/get.dart';

import 'auth/auth_controller.dart';

class SplashController extends GetxController {
  final auth = Get.find<AuthController>();
  @override
  void onReady() {
    super.onReady();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        // Get.offAllNamed('/login');
        if (auth.isLogin()) {
          Get.offAllNamed("/home");
        } else {
          Get.offAllNamed('/login');
        }
      },
    );
  }
}
