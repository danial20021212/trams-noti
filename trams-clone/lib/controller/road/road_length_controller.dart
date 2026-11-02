import 'package:get/get.dart';
import 'package:tram/model/basic/road/road_length_statewide_model.dart';
import 'package:tram/model/chart/stacked_bar_chart_data_model.dart';
import 'package:tram/repository/road_repository.dart';

import '../../model/shared/loader_state_model.dart';

class RoadlengthController extends GetxController {
  final repository = RoadRepository();
  Rx<LoaderState> state = LoaderState.initial.obs;
  RxList<StackedBarChartData> list = RxList();
  Rxn<RoadLengthStatewideModel> statewide = Rxn();

  @override
  void onInit() {
    load();
    super.onInit();
  }

  load() async {
    try {
      state.value = LoaderState.loading;
      final data = await repository.showRoadLength();
      statewide.value = await repository.showRoadLengthStatewide();
      list.addAll(
        data.dataCharts
            .map(
              (e) => StackedBarChartData(
                x: e.serviceProvider,
                y: e.pavedRoadLength,
                yValue: e.unpavedRoadLength,
              ),
            )
            .toList()
            .reversed,
      );

      state.value = LoaderState.loaded;
    } catch (err) {
      state.value = LoaderState.failure;
    }
  }
}
