import 'package:get/get.dart';
import 'package:tram/model/basic/road/road_condition_rating_cost_model.dart';
import 'package:tram/model/basic/road/road_condition_rating_model.dart';
import 'package:tram/model/basic/road/road_length_model.dart';
import 'package:tram/model/basic/road/road_length_statewide_model.dart';
import 'package:tram/model/basic/road/road_maintenance_packge.dart';
import 'package:tram/model/basic/road/road_maintenance_state_model.dart';
import 'package:tram/model/basic/road/road_roughness_index_packge.dart';
import 'package:tram/model/basic/road/road_roughness_index_state_model.dart';
import '../constant/url.dart';
import '../provider/api_provider.dart';

class RoadRepository {
  final ApiProvider provider = Get.find<ApiProvider>();

  Future<RoadLengthModel> showRoadLength() async {
    Map<String, String> mapForm = {};

    final res = await provider.store(
      UrlStorage.roadLength,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return RoadLengthModel.fromJson(res.data);
  }

  Future<RoadLengthStatewideModel> showRoadLengthStatewide() async {
    Map<String, String> mapForm = {};

    final res = await provider.store(
      UrlStorage.roadLengthStatewide,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return RoadLengthStatewideModel.fromJson(res.data);
  }

  Future<RoadMaintenanceStateModel> showRoadMaintenanceState() async {
    Map<String, String> mapForm = {};

    final res = await provider.store(
      UrlStorage.roadMaintenanceState,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return RoadMaintenanceStateModel.fromJson(res.data);
  }

  Future<RoadMaintenancePackgeModel> showRoadMaintenancePackge() async {
    Map<String, String> mapForm = {};
    final res = await provider.store(
      UrlStorage.roadMaintenancePackge,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return RoadMaintenancePackgeModel.fromJson(res.data);
  }

  Future<RoadRoughnessStateModel> showRoughnessIndexState() async {
    Map<String, String> mapForm = {};

    final res = await provider.store(
      UrlStorage.roadRoughnessIndexState,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return RoadRoughnessStateModel.fromJson(res.data);
  }

  Future<RoadRoughnessIndexPackgeModel> showRoughnessIndexPackge() async {
    Map<String, String> mapForm = {};
    final res = await provider.store(
      UrlStorage.roadRouhghnessIndexPackge,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    return RoadRoughnessIndexPackgeModel.fromJson(res.data);
  }

  Future<RoadConditionRatingModel> showRoadConditionRating() async {
    Map<String, String> mapForm = {};
    final res = await provider.store(
      UrlStorage.roadConditionRating,
      data: mapForm,
    );
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    final before = RoadConditionRatingBeforeProceedModel.fromJson(res.data);
    final model = RoadConditionRatingModel(
      httpStatus: before.httpStatus,
      paved: before.paved(),
      unpaved: before.unpaved(),
    );
    return model;
  }

  Future<RoadConditionRatingCostModel> showRoadConditionRatingCost() async {
    final res = await provider.store(UrlStorage.roadConditionRatingCost);
    if (res.statusCode != 200 && res.data["http_status"] != "Success.") {
      throw res;
    }
    final before = RoadConditionRatingCostBeforeProceedModel.fromJson(res.data);
    final model = RoadConditionRatingCostModel(
      httpStatus: before.httpStatus,
      paved: before.paved(),
      unpaved: before.unpaved(),
    );
    return model;
  }
}
