import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tram/components/rect_painter.dart';
import 'package:tram/components/speed_chart_1.dart';
import 'package:tram/model/basic/map/rmi_division_model.dart';
import 'package:tram/repository/map_repository.dart';

import '../../model/shared/loader_state_model.dart';

class AchievementKPPIController extends GetxController {
  final repository = MapRepository();

  String pkg = Get.arguments["pkg"];
  String place = Get.arguments["place"];
  String type = Get.arguments["type"];

  Rx<LoaderState> state = LoaderState.initial.obs;
  Rx<RmiDivisionModel?> roadState = Rxn();
  List<List<GaugeRange>> rmiList = [];
  RxList<Widget> sliders = RxList();
  int activeIndex = 0;
  RmiDivisionModel? packge;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  load() async {
    try {
      state.value = LoaderState.loading;
      switch (type) {
        case "district":
          packge = await repository.showDistrictRMI(pkg, place);
          break;
        case "division":
          packge = await repository.showDivisionRMI(pkg, place);
          break;
        case "package":
          packge = await repository.showpackageRMI(pkg);
          break;
      }
  
      if (packge!.dataReader.isEmpty) {
        return state.value = LoaderState.failure;
      }
      rmiList = packge!.dataReader
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
      extractSlider(packge!);
      state.value = LoaderState.loaded;
    } catch (err) {
      print(err);
      state.value = LoaderState.failure;
    }
  }

  extractSlider(RmiDivisionModel rmi) {
    for (int i = 0; i < rmi.dataReader.length; i++) {
      final v = rmi.dataReader[i];
      sliders.add(
        SizedBox(
          height: 450,
          child: Neumorphic(
            margin: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                FittedBox(
                  child: title(
                    v.pdpmName,
                    (100 - v.allowableRange).toString(),
                    v.resultPercent.split("%")[0],
                    v.achievementStatus,
                    v.achievementStatus == "Achieved" ? true : false,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
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
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SpeedChart1(
                      double.parse(
                        v.resultPercent.split("%")[0],
                      ),
                      rmiList[i]),
                ),
                Text(
                  v.description,
                  style: TextStyle(
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
        t1,
        style: TextStyle(
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
