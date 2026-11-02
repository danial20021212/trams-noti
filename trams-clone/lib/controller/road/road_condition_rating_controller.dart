import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tram/components/halft_doughnut_chart1.dart';
import 'package:tram/model/basic/road/road_condition_rating_cost_model.dart';
import 'package:tram/model/basic/road/road_condition_rating_model.dart';
import 'package:tram/model/chart/bar_chart_data_model.dart';
import 'package:tram/repository/road_repository.dart';

import '../../model/shared/loader_state_model.dart';

class RoadConditionRatingController extends GetxController {
  final repository = RoadRepository();
  Rx<LoaderState> state1 = LoaderState.initial.obs;
  RoadConditionRatingModel? rating;
  RoadConditionRatingCostModel? ratingCost;
  RxList<Widget> paved = RxList();
  RxList<Widget> unpaved = RxList();
  int activeIndex1 = 0;
  int activeIndex2 = 0;

  List<Color> colors = [
    const Color.fromARGB(255, 49, 142, 53),
    Colors.orange,
    Colors.red,
  ];

  final tooltip2 = TooltipBehavior(
    enable: true,
    activationMode: ActivationMode.singleTap,
    builder: (data, point, series, pointIndex, seriesIndex) {
      return Container(
        padding: const EdgeInsets.only(left: 10, top: 5),
        height: 60,
        width: 180,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 247, 247, 247),
          border: Border.all(
            color: Colors.green,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              data.title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  data.description,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );

  @override
  void onInit() {
    load();
    // loadPackge();
    super.onInit();
  }

  extractSlider(List<List<RoadCondition>> model, List<RoadConditionCost> costs,
      String title) {
    List<Widget> temp = [];
    for (int i = 0; i < model.length; i++) {
      final v = model[i];
      if (v.isNotEmpty) {
        temp.add(
          SizedBox(
            height: 350,
            child: Neumorphic(
              margin: const EdgeInsets.only(
                top: 5,
                bottom: 5,
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: HalfDoughnutChart1(
                      v
                          .asMap()
                          .entries
                          .map(
                            (e) => BarChartData(
                              "0",
                              e.value.value,
                              title: e.value.key,
                              color: colors[e.key],
                              description: "Length(KM): ${e.value.value}",
                            ),
                          )
                          .toList(),
                      tooltipBehavior: _toolTip(),
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.top,
                      ),
                    ),
                  ),
                  Text(
                    costs[i].achievement,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    costs[i].condition2Cost,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    costs[i].condition3Cost,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Package ${i + 1}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return temp;
  }

  TooltipBehavior _toolTip() {
    return TooltipBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      builder: (data, point, series, pointIndex, seriesIndex) {
        return Container(
          padding: EdgeInsets.only(left: 10, top: 5),
          height: 60,
          width: 180,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 247, 247, 247),
            border: Border.all(
              color: colors[seriesIndex],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                data.title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 5),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: colors[seriesIndex],
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    data.description,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  load() async {
    try {
      state1.value = LoaderState.loading;
      rating = await repository.showRoadConditionRating();
      ratingCost = await repository.showRoadConditionRatingCost();
      paved.value = extractSlider(
          rating!.paved, ratingCost!.paved, "Paved Road condition");
      unpaved.value = extractSlider(
          rating!.unpaved, ratingCost!.unpaved, "Unpaved Road condition");
      state1.value = LoaderState.loaded;
    } catch (err) {
      print(err);
      state1.value = LoaderState.failure;
    }
  }
}
