import 'package:get/get.dart';
import 'package:tram/controller/detail/achievement_kppi_controller.dart';


class AchievementKPPIBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AchievementKPPIController>(
      () => AchievementKPPIController(),
    );
  }
}
