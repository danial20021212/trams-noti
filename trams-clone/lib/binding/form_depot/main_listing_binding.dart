import 'package:get/get.dart';
import 'package:tram/controller/form_depot/main_listing/main_listing_controller.dart';

import '../../controller/form_depot/main_listing/main_listing_details_controller.dart';
import '../../controller/form_depot/main_listing/main_listing_filter_controller.dart';

class MainListingBinding extends Bindings {
  @override
  void dependencies() {
    final String formType = Get.arguments['formType'] ?? '';
    final bool isDetailsRoute = Get.arguments['isMainListing'] == true;

    Get.lazyPut<MainListingController>(
      () => MainListingController(),
    );
    Get.lazyPut<MainListingFilterController>(
        () => MainListingFilterController());

    // Form C details must belong to the details route, otherwise its first
    // road/culvert context survives while the parent listing route is active.
    if (formType.toLowerCase() != 'c' || isDetailsRoute) {
      Get.lazyPut<MainListingDetailsController>(
        () => MainListingDetailsController(),
      );
    }
  }
}
