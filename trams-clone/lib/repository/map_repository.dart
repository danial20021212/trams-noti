import 'package:get/get.dart';
import 'package:tram/model/basic/map/company_detail_model.dart';
import 'package:tram/model/basic/map/package_detail_model.dart';
import 'package:tram/model/basic/map/rmi_division_model.dart';
import 'package:tram/model/basic/map/road_asset_statistic_model.dart';

import '../constant/url.dart';
import '../provider/api_provider.dart';

class MapRepository {
  final ApiProvider provider = Get.find<ApiProvider>();

  Future<CompanyDetailModel> showCompanyDetail(String pkg) async {
    Map<String, String> mapForm = {};
    final res = await provider.store(
      UrlStorage.mapCompany(pkg),
      data: mapForm,
    );

    if (res.statusCode != 200 && res.data["http_code"] != 200) throw res;
    return CompanyDetailModel.fromJson(res.data);
  }

  Future<PackageDetailModel> showPackageDetail(String pkg) async {
    Map<String, String> mapForm = {
      "package": pkg,
    };
    final res = await provider.store(
      UrlStorage.packageDetail,
      data: mapForm,
    );
    if (res.data["http_status"] != "Success.") throw res;
    return PackageDetailModel.fromJson(res.data);
  }

  Future<RmiDivisionModel> showDistrictRMI(String pkg, String district) async {
    Map<String, String> mapForm = {
      "district": district,
      "package": pkg,
    };
    final res = await provider.store(
      UrlStorage.districtRMI,
      data: mapForm,
    );
    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;
    return RmiDivisionModel.fromJson(res.data);
  }

  Future<RmiDivisionModel> showDivisionRMI(String pkg, String division) async {
    Map<String, String> mapForm = {
      "division": division,
      "package": pkg,
    };
    final res = await provider.store(
      UrlStorage.divisionRMI,
      data: mapForm,
    );
    print(res);
    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;
    return RmiDivisionModel.fromJson(res.data);
  }

  Future<RmiDivisionModel> showpackageRMI(String pkg) async {
    Map<String, String> mapForm = {
      "package": pkg,
    };
    final res = await provider.store(
      UrlStorage.packageRMI,
      data: mapForm,
    );
    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;
    return RmiDivisionModel.fromJson(res.data);
  }

  Future<RoadAssetStatisticModel> showPackageRoadAsset(String pkg) async {
    Map<String, String> mapForm = {
      "package": pkg,
    };
    final res = await provider.store(
      UrlStorage.packageRoadAsset,
      data: mapForm,
    );
    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;
    return RoadAssetStatisticModel.fromJson(res.data);
  }

  Future<RoadAssetStatisticModel> showDivisionRoadAsset(
      String pkg, String division) async {
    Map<String, String> mapForm = {
      "division": division,
      "package": pkg,
    };
    final res = await provider.store(
      UrlStorage.divisionRoadAsset,
      data: mapForm,
    );
    if (res.statusCode != 200) throw res;

    if (res.data["http_status"] != "Success.") throw res;
    return RoadAssetStatisticModel.fromJson(res.data);
  }

  Future<RoadAssetStatisticModel> showDistrictRoadAsset(
      String pkg, String district) async {
    Map<String, String> mapForm = {
      "district": district,
      "package": pkg,
    };
    final res = await provider.store(
      UrlStorage.districtRoadAsset,
      data: mapForm,
    );
    if (res.statusCode != 200) throw res;
    if (res.data["http_status"] != "Success.") throw res;
    return RoadAssetStatisticModel.fromJson(res.data);
  }
}
