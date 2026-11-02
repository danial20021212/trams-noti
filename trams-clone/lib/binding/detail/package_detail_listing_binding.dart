import 'package:get/get.dart';
import 'package:tram/controller/detail/package_detail_listing_controller.dart';


class PackagedetailListingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PackageDetailListingController>(
      () => PackageDetailListingController(),
    );
  }
}
