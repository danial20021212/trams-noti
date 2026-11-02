import 'package:get/get.dart';
import 'package:tram/controller/road/road_length_controller.dart';

import '../../controller/home/root_home_controller.dart';

class RoadLengthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoadlengthController>(
      () => RoadlengthController(),
    );
  }
}
