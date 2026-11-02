import 'package:get/get.dart';
import 'package:tram/controller/form_depot/main_listing/inspection_details_controller.dart';

class InpectionDetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InspectionDetailsController>(
          () => InspectionDetailsController(),
    );
  }
}