
import 'package:get/get.dart';
import 'package:tram/model/basic/asset/asset_inventory_model.dart';

import '../constant/url.dart';
import '../provider/api_provider.dart';

class AssetRepository {
  final ApiProvider provider = Get.find<ApiProvider>();

  Future<AssetInventoryModel> showAssetinventory() async {
    Map<String, String> mapForm = {};
    final res = await provider.store(
      UrlStorage.asetInventory,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return AssetInventoryModel.fromJson(res.data);
  }
}
