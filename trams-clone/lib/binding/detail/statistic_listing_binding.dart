import 'package:get/get.dart';
import 'package:tram/controller/detail/statistic_listing_controller.dart';


class StatisticListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatisticListingController>(
      () => StatisticListingController(),
    );
  }
}
