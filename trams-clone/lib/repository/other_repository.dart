import 'package:get/get.dart';
import 'package:tram/model/basic/other/pai_model.dart';
import 'package:tram/model/basic/other/spi_model.dart';

import '../constant/url.dart';
import '../provider/api_provider.dart';
class OtherRepository {
  final ApiProvider provider = Get.find<ApiProvider>();

  Future<PaiModel> showPAI() async {
    Map<String, String> mapForm = {};
    final res = await provider.store(
      UrlStorage.pai,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return PaiModel.fromJson(res.data);
  }

  Future<SpiModel> showSPI() async {
    Map<String, String> mapForm = {};

    final res = await provider.store(
      UrlStorage.spi,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return SpiModel.fromJson(res.data);
  }
}
