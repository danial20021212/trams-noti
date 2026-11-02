import 'package:get/get.dart';
import 'package:tram/controller/other/pai_controller.dart';
class PAIBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PAIController>(
      () => PAIController(),
    );
  }
}
