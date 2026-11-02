import 'package:get/get.dart';
import 'package:tram/constant/url.dart';
import 'package:tram/model/form/form_depot/form_B/filter_bridge_type_model.dart';
import 'package:tram/provider/api_provider.dart';

class BridgeTypeRepository {
  final ApiProvider provider = Get.find<ApiProvider>();

  Future<FilterBridgeTypeModel> showFilterBtSuperstructure() async {
    final res = await provider.store(
      UrlStorage.filterBtSuperstructure,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterBridgeTypeModel.fromJson(res.data);
  }

  Future<FilterBridgeTypeModel> showFilterBtParapet() async {
    final res = await provider.store(
      UrlStorage.filterBtParapet,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterBridgeTypeModel.fromJson(res.data);
  }

  Future<FilterBridgeTypeModel> showFilterBtBearing() async {
    final res = await provider.store(
      UrlStorage.filterBtBearing,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterBridgeTypeModel.fromJson(res.data);
  }

  Future<FilterBridgeTypeModel> showFilterBtExpansion() async {
    final res = await provider.store(
      UrlStorage.filterBtExpansion,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterBridgeTypeModel.fromJson(res.data);
  }

  Future<FilterBridgeTypeModel> showFilterBtDeck() async {
    final res = await provider.store(
      UrlStorage.filterBtDeck,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterBridgeTypeModel.fromJson(res.data);
  }

  Future<FilterBridgeTypeModel> showFilterBtAbutment() async {
    final res = await provider.store(
      UrlStorage.filterBtAbutment,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterBridgeTypeModel.fromJson(res.data);
  }

  Future<FilterBridgeTypeModel> showFilterBtPier() async {
    final res = await provider.store(
      UrlStorage.filterBtPier,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterBridgeTypeModel.fromJson(res.data);
  }
}
