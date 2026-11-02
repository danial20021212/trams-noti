import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tram/components/speed_chart_1.dart';
import 'package:tram/model/basic/road/road_maintenance_packge.dart';
import 'package:tram/model/basic/road/road_maintenance_state_model.dart';
import 'package:tram/model/chart/stacked_bar_chart_data_model.dart';
import 'package:tram/repository/road_repository.dart';

import '../../components/rect_painter.dart';
import '../../model/shared/loader_state_model.dart';

class RoadMaintenanceController extends GetxController {
  final repository = RoadRepository();
  Rx<LoaderState> state1 = LoaderState.initial.obs;
  Rx<LoaderState> state2 = LoaderState.initial.obs;
  Rx<RoadMaintenanceStateModel?> roadState = Rxn();
  List<List<GaugeRange>> packgeList = [];
  RxList<Widget> sliders = RxList();
  int activeIndex = 0;

  @override
  void onInit() {
    load();
    loadPackge();
    super.onInit();
  }

  loadPackge() async {
    try {
      state2.value = LoaderState.loading;
      final packge = await repository.showRoadMaintenancePackge();
      packgeList = packge.dataReaderRmi
          .map((e) => [
                gauge(
                  Colors.red,
                  0,
                  (100 - e.allowableRange).toDouble(),
                ),
                gauge(
                  Colors.green,
                  (100 - e.allowableRange).toDouble(),
                  (100).toDouble(),
                ),
              ])
          .toList();
      extractSlider(packge);
      state2.value = LoaderState.loaded;
    } catch (err) {
      print(err);
      state2.value = LoaderState.failure;
    }
  }

  extractSlider(RoadMaintenancePackgeModel packge) {
    for (int i = 0; i < packge.dataReaderRmi.length; i++) {
      final v = packge.dataReaderRmi[i];
      sliders.add(
        SizedBox(
          height: 450,
          child: Neumorphic(
            margin: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                FittedBox(
                  child: title(
                    v.package,
                    (100 - v.allowableRange).toString(),
                    v.resultPercent.toString(),
                    v.achievementStatus,
                    v.achievementStatus == "Achieved" ? true : false,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  children: [
                    CustomPaint(
                      painter: RectPainter(
                        width: 12,
                        height: 12,
                        color: Colors.green,
                      ),
                      child: SizedBox(
                        height: 12,
                        width: 24,
                      ),
                    ),
                    Text(
                      "Acceptable Zone",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    CustomPaint(
                      painter: RectPainter(
                        width: 12,
                        height: 12,
                        color: Colors.red,
                      ),
                      child: SizedBox(
                        height: 12,
                        width: 24,
                      ),
                    ),
                    Text(
                      "Unacceptable Zone",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SpeedChart1(
                      packge.dataReaderRmi[i].resultPercent.toDouble(),
                      packgeList[i]),
                ),
                Text(
                  v.description,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 17,
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
      roadState.value = await repository.showRoadMaintenanceState();

      state1.value = LoaderState.loaded;
    } catch (err) {
      state1.value = LoaderState.failure;
    }
  }

  GaugeRange gauge(Color color, double start, double value) {
    return GaugeRange(
      startValue: start,
      endValue: value,
      color: color,
      startWidth: 10,
      endWidth: 10,
    );
  }
}

Widget title(String t1, String t2, String t3, String t4, bool achieved) {
  return Column(
    children: [
      Text(
        "Package: $t1",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      Text(
        "Target: $t2%",
        style: TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      Text(
        "Result: $t3% ($t4)",
        style: TextStyle(
          color: achieved ? Colors.green : Colors.red,
          fontSize: 17,
        ),
      ),
    ],
  );
}
