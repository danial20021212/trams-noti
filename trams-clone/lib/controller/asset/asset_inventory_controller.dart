import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tram/components/bar_chart_1.dart';
import 'package:tram/model/basic/asset/asset_inventory_model.dart'; 
import 'package:tram/model/chart/bar_chart_data_model.dart';
import 'package:tram/repository/asset_repository.dart';

import '../../model/shared/loader_state_model.dart';

class AssetInventoryController extends GetxController {
  final repository = AssetRepository();
  Rx<LoaderState> state1 = LoaderState.initial.obs;
  Rx<AssetInventoryModel?> inventory = Rxn();
  final List<List<BarChartData>> chartdata = [];
  RxList<Widget> sliders = RxList();
  int activeIndex = 0;
  final tooltipBehavior = TooltipBehavior(
    enable: true,
    canShowMarker: false,
    decimalPlaces: 2,
    activationMode: ActivationMode.singleTap,
    builder: (data, point, series, pointIndex, seriesIndex) {
      return Container(
        padding: const EdgeInsets.all(5),
        child: Text(
          "${point.y}",
          style: const TextStyle(color: Colors.white),
        ),
      );
    },
  );

  @override
  void onInit() {
    load();
    super.onInit();
  }

  extractSlider(List<List<BarChartData>> data) {
    List<String> title = [
      "Road Length",
      "Paved Road",
      "Road Quantity",
      "Culvert Quantity",
      "Bridge Quantity",
      "Signage Quantity",
      "Numbers of traffic light",
      "Street lighting",
      "Solar street lighting ",
      "Guardrail",
    ];
    List<String> xTitle = [
      "Road Length(KM)",
      "% Paved",
      "Quantity (No.)",
      "Quantity (No.)",
      "Quantity (No.)",
      "Quantity (No.)",
      "Quantity (No)",
      "Quantity (No)",
      "Quantity (No)",
      "Quantity (M)",
    ];

    List<double?> xMaximun = [
      null,
      100,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
    ];

    List<ChartAxisLabel Function(AxisLabelRenderDetails)?> xFormatter = [
      kFormatter,
      null,
      null,
      kFormatter,
      null,
      kFormatter,
      null,
      null,
      null,
      null,
    ];

    for (int i = 0; i < data.length; i++) {
      final v = data[i];

      sliders.add(
        SizedBox(
          height: 400,
          child: Neumorphic(
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Expanded(
                  child: BarChart1(
                    v,
                    tooltipBehavior: tooltipBehavior,
                    title: title[i],
                    xTitle: xTitle[i],
                    xMaximun: xMaximun[i],
                    xFormatter: xFormatter[i],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  load() async {
    try {
      state1.value = LoaderState.loading;
      inventory.value = await repository.showAssetinventory();
      extractChartdata();
      extractSlider(chartdata);
      state1.value = LoaderState.loaded;
    } catch (err) {
      print(err);
      state1.value = LoaderState.failure;
    }
  }

  extractChartdata() {
    List pre = [
      inventory.value!.roadLength,
      inventory.value!.pavedRoad,
      inventory.value!.roadQuantity,
      inventory.value!.culvertQuantity,
      inventory.value!.bridgeQuantity,
      inventory.value!.signageQuantity,
      inventory.value!.trafficLightQuantity,
      inventory.value!.streetLightingQuantity,
      inventory.value!.solarStreetLightingQuantity,
      inventory.value!.guardrailQuantity,
    ];
    for (var element in pre) {
      List<BarChartData> temp = [];
      for (var v in element) {
        temp.add(BarChartData(v.serviceProvider, v.value()));
      }
      chartdata.add(temp);
    }
  }

  ChartAxisLabel kFormatter(AxisLabelRenderDetails details) {
    var kUnit = details.text;
    if (int.parse(details.text) >= 1000) {
      kUnit = "${(int.parse(details.text) / 1000).toStringAsFixed(0)}k";
    }
    return ChartAxisLabel(kUnit, details.textStyle);
  }
}
