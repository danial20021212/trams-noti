
import 'package:get/get.dart';
import 'package:tram/model/basic/gis/filter_bridge_type_model.dart';
import 'package:tram/model/basic/gis/filter_condition_model.dart';
import 'package:tram/model/basic/gis/filter_district_model.dart';
import 'package:tram/model/basic/gis/filter_division_model.dart';
import 'package:tram/model/basic/gis/filter_inventory_model.dart';
import 'package:tram/model/basic/gis/filter_package_model.dart';
import 'package:tram/model/basic/gis/filter_route_model.dart';
import 'package:tram/model/basic/gis/filter_work_program_model.dart';
import 'package:tram/model/basic/gis/maintenance_work_model.dart';
import 'package:tram/model/basic/gis/pavement_detail_model.dart';
import 'package:tram/model/basic/gis/road_asset_model.dart';

import '../constant/url.dart';
import '../model/basic/gis/filter_bridge_category_model.dart';
import '../provider/api_provider.dart';

class PavementRepository {
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

  Future<FilterDistrictModel> showFilterDistrict(String pkg) async {
    Map<String, String> mapForm = {
      "package": pkg,
    };

    final res = await provider.store(
      UrlStorage.filterDistrict,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterDistrictModel.fromJson(res.data);
  }


  Future<FilterDivisionModel> showFilterDivision(String pkgID) async {
    Map<String, String> mapForm = {
      "package": pkgID,
    };

    final res = await provider.store(
      UrlStorage.filterDivision,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterDivisionModel.fromJson(res.data);
  }

  //if filter division, use this API
  Future<FilterRouteModel> showFilterRoute2(String pkg, String division) async {
    Map<String, String> mapForm = {
      "package": pkg,
      "division": division,
    };
    final res = await provider.store(
      UrlStorage.filterRoute2,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterRouteModel.fromJson(res.data);
  }

  Future<FilterRouteModel> showFilterRoute(String pkg, String district) async {
    Map<String, String> mapForm = {
      "package": pkg,
      "district": district,
    };
    final res = await provider.store(
      UrlStorage.filterRoute,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterRouteModel.fromJson(res.data);
  }

  Future<FilterConditionModel> showFilterCondition() async {
    Map<String, String> mapForm = {};

    final res = await provider.store(
      UrlStorage.filterCondition,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterConditionModel.fromJson(res.data);
  }

  Future<PavementDetailModel> showPavement({
    required String package,
    required String district,
    required String route,
    required String condition,
    required String year,
  }) async {
    Map<String, String> mapForm = {
      "package": package,
      "district": district,
      "route_id": route,
      "condition_name": condition,
      "survey_year": year,
    };
    final res = await provider.store(
      UrlStorage.filterPavement,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return PavementDetailModel.fromJson(res.data);
  }

  Future<FilterInventoryModel> showFilterInventory() async {
    Map<String, String> mapForm = {};

    final res = await provider.store(
      UrlStorage.filterInventory,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterInventoryModel.fromJson(res.data);
  }

  Future<FilterBridgeCategoryModel> showFilterBridgeCategory() async {
    Map<String, String> mapForm = {};

    final res = await provider.store(
      UrlStorage.filterBridgeCategory,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterBridgeCategoryModel.fromJson(res.data);
  }

  Future<FilterBridgeTypeModel> showFilterBridgeType([String? category]) async {
    Map<String, String> mapForm = {
      if (category != null) "bridgeCategory": category,
    };

    final res = await provider.store(
      UrlStorage.filterBridgeType,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterBridgeTypeModel.fromJson(res.data);
  }

  Future<RoadAssetModel> showRoadAsset({
    required String package,
    required String district,
    String? route,
    required String inventory,
    String? category,
    String? type,
  }) async {
    Map<String, String> mapForm = {
      "package": package,
      "district": district,
      if (route != null) "route_id": route,
      "inventoryItem": inventory,
      if (category != null) "bridgeCategory": category,
      if (type != null) "bridgeType": type,
    };
    final res = await provider.store(
      UrlStorage.filterRoadAsset,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return RoadAssetModel.fromJson(res.data);
  }

  Future<FilterWorkProgramModel> showFilterWorkProgram() async {
    Map<String, String> mapForm = {};
    final res = await provider.store(
      UrlStorage.filterWorkProgram,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return FilterWorkProgramModel.fromJson(res.data);
  }

  Future<MaintenanceWorkModel> showMaintenanceWork({
    required String package,
    required String district,
    required String route,
    required String year,
    required String program,
  }) async {
    Map<String, String> mapForm = {
      "package": package,
      "district": district,
      "roadNo": route,
      "survey_year": year,
      "workProgramBy": program,
    };

    final res = await provider.store(
      UrlStorage.filterMaintenanceWork,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return MaintenanceWorkModel.fromJson(res.data);
  }
}
