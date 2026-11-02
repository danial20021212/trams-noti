import 'package:get/get.dart';
import 'package:tram/controller/road/road_roughness_index_controller.dart';


class RoadRoughnessIndexBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoadRoughnessIndexController>(
      () => RoadRoughnessIndexController(),
    );
  }
}
