
import 'package:get/get.dart';
import 'package:tram/model/basic/work_history/work_history_model.dart';
import '../constant/url.dart';
import '../provider/api_provider.dart';

class WorkHistoryRepository {
  final ApiProvider provider = Get.find<ApiProvider>();

  Future<WorkHistoryDataModel> showWorkHistory({
    required String package,
    required String district,
    required String route,
    required String year,
  }) async {
    Map<String, String> mapForm = {
      "package": package,
      "district": district,
      "route_id": route,
      "survey_year": year,
    };

    final res = await provider.store(
      UrlStorage.workHistory,
      data: mapForm,
    );

    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return WorkHistoryDataModel.fromJson(res.data);
  }
}
