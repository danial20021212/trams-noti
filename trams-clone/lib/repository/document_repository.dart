import 'package:get/get.dart';
import 'package:tram/model/basic/document/document_list_model.dart';

import '../constant/url.dart';
import '../model/basic/gis/filter_package_model.dart';
import '../provider/api_provider.dart';

class DocumentRepository {
  final ApiProvider provider = Get.find<ApiProvider>();

  Future<FilterPackageModel> showFilterPackage() async {
    Map<String, String> mapForm = {};
    final res = await provider.store(
      UrlStorage.filterPackage,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterPackageModel.fromJson(res.data);
  }

  Future<DocumentListModel> indexDocument({
    required String package,
    required String docName,
  }) async {
    Map<String, String> mapForm = {
      "packageNo": package,
      "documentName": docName,
    };
    final res = await provider.store(UrlStorage.document, data: mapForm);
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return DocumentListModel.fromJson(res.data);
  }
}
