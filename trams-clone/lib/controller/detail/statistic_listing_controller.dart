import 'package:flutter/material.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tram/controller/gis/all_gis_map_controller.dart';
import 'package:tram/controller/gis/pavement_map_filter_controller.dart';
import 'package:tram/controller/home/root_home_controller.dart';
import 'package:tram/model/basic/map/road_asset_statistic_model.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/repository/map_repository.dart';

class StatisticListingController extends GetxController {
  final repository = MapRepository();
  Rx<LoaderState> state = LoaderState.initial.obs;
  final type = Get.arguments["type"];
  final pkg = Get.arguments["pkg"];

  Rx<RoadDataSource> roadDataSource = RoadDataSource(roads: []).obs;

  RoadAssetStatisticModel? roadAsset;
  @override
  void onInit() {
    load();
    super.onInit();
  }

  load() async {
    try {
      state.value = LoaderState.loading;
      switch (type) {
        case "package":
          {
            roadAsset = await repository.showPackageRoadAsset(pkg);
            break;
          }
        case "district":
          {
            roadAsset = await repository.showDistrictRoadAsset(
                pkg, Get.arguments["district"]);
            break;
          }
        case "division":
          {
            roadAsset = await repository.showDivisionRoadAsset(
                pkg, Get.arguments["division"]);
            break;
          }
        default:
          throw "Type Not Found";
      }
      if (roadAsset!.dataReader.isEmpty) {
        return state.value = LoaderState.failure;
      }
      roadDataSource.value = RoadDataSource(roads: roadAsset!.dataReader);

      state.value = LoaderState.loaded;
    } catch (err) {
      print(err);
      state.value = LoaderState.failure;
    }
  }

  navigate(RoadAssetStatisticDetailModel selected) async {
    Map<String, dynamic> data = {
      "pkg": selected.packageId,
      "district": selected.districtId,
      "route": selected.roadId,
      "condition": selected.conditionId,
      "year": selected.surveyYr,
    };
    final homeController = Get.find<RootHomeController>();
    final mapcontroller = Get.find<PavementMapFilterController>();

    SmartDialog.dismiss(tag: "dlg");
    homeController.to(3);
    final allController = Get.find<AllGisMapController>();
    allController.to(0);
    Get.until(
      (route) => route.settings.name == "/home",
    );

    mapcontroller.manualArguments(data);
  }
}

class RoadDataSource extends DataGridSource {
  RoadDataSource({required List<RoadAssetStatisticDetailModel> roads}) {
    dataGridRows = roads
        .map<DataGridRow>(
          (dataGridRow) => DataGridRow(
            cells: [
              DataGridCell<String>(columnName: 'id', value: dataGridRow.roadNo),
              DataGridCell<String>(
                columnName: 'name',
                value: dataGridRow.roadName,
              ),
              DataGridCell<String>(
                  columnName: 'distance', value: "${dataGridRow.roadLength}"),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>(
        (dataGridCell) {
          if (dataGridCell.columnName == "id") {
            return Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  dataGridCell.value.toString(),
                  style: TextStyle(
                    shadows: const [
                      Shadow(
                        color: Colors.blue,
                        offset: Offset(0, -5),
                      ),
                    ],
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    decorationThickness: 3,
                    color: Colors.transparent,
                    decorationColor: Colors.blue,
                  ),
                ));
          }
          return Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              dataGridCell.value.toString(),
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
