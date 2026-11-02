import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tram/constant/path.dart';

import '../controller/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = Get.find<SplashController>();

  @override
  void initState() {
    super.initState();
    // Timer(
    //   const Duration(seconds: 1),
    //   () => Get.toNamed('/login'),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AssetStorage.logo,
          height: Get.height * 0.4,
          width: Get.width * 0.4,
        ),
      ),
    );
  }
}
