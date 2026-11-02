
import 'package:get/get.dart';
import 'package:tram/model/basic/rc_date_model.dart';

import '../constant/url.dart';
import '../provider/api_provider.dart';

class DateRepository {
  final ApiProvider provider = Get.find<ApiProvider>();

  Future<RcDateModel> showRcDate() async {
    Map<String, String> mapForm = {};
    final res = await provider.store(
      UrlStorage.dashUpdateDate,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return RcDateModel.fromJson(res.data);
  }
}
