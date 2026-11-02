import 'package:get/get.dart';
import 'package:tram/controller/road/road_condition_rating_controller.dart';

class RoadConditionRatingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoadConditionRatingController>(
      () => RoadConditionRatingController(),
    );
  }
}
