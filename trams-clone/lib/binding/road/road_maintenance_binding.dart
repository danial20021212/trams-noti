import 'package:get/get.dart';
import 'package:tram/controller/road/road_maintenance_controller.dart';

class RoadMaintenanceBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoadMaintenanceController>(
      () => RoadMaintenanceController(),
    );
  }
}
