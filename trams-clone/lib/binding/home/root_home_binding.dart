import 'package:get/get.dart';

import 'package:tram/controller/gis/maintenance_work_controller.dart';
import 'package:tram/controller/gis/maintenance_work_filter_controller.dart';
import 'package:tram/controller/gis/road_asset_controller.dart';
import 'package:tram/controller/gis/road_asset_filter_controller.dart';
import 'package:tram/controller/home/dashboard_controller.dart';
import 'package:tram/controller/home/document_controller.dart';
import 'package:tram/controller/work_history/work_history_controller.dart';
import 'package:tram/controller/work_history/work_history_filter_controller.dart';

import '../../controller/form_depot/form_draft_controller.dart';
import '../../controller/form_depot/sync_controller.dart';
import '../../controller/gis/all_gis_map_controller.dart';
import '../../controller/gis/pavement_map_controller.dart';
import '../../controller/gis/pavement_map_filter_controller.dart';
import '../../controller/home/document_filter_controller.dart';
import '../../controller/home/root_home_controller.dart';

class RootHomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootHomeController>(
      () => RootHomeController(),
    );
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
    Get.lazyPut<AllGisMapController>(
      () => AllGisMapController(),
    );
    Get.put<PavementMapController>(
      PavementMapController(),
    );
    Get.put<PavementMapFilterController>(
      PavementMapFilterController(),
    );
    Get.lazyPut<DocumentController>(
      () => DocumentController(),
    );
    Get.put<DocumentFilterController>(
      DocumentFilterController(),
    );
    Get.put<RoadAssetController>(
      RoadAssetController(),
    );
    Get.put<RoadAssetFilterController>(
      RoadAssetFilterController(),
    );
    Get.put<MaintenanceWorkController>(
      MaintenanceWorkController(),
    );
    Get.put<MaintenanceWorkFilterController>(
      MaintenanceWorkFilterController(),
    );
    Get.put<WorkHistoryController>(
      WorkHistoryController(),
    );
    Get.put<WorkHistoryFilterController>(
      WorkHistoryFilterController(),
    );
    Get.put<FormDraftController>(
      FormDraftController(),
    );
    // Get.put<SyncController>(
    //   SyncController(),
    // );
  }
}
