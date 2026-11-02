import 'package:get/get.dart';
import 'package:tram/controller/asset/asset_inventory_controller.dart';

class AssetInventoryBinding implements Bindings {

  @override 
  void dependencies() {
    Get.lazyPut<AssetInventoryController>(
      () => AssetInventoryController(),
    );
  }
}
