import 'package:get/get.dart';
import 'package:tram/controller/other/spi_controller.dart';

class SPIBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SPIController>(
      () => SPIController(),
    );
  }
}
