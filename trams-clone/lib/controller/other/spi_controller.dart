import 'package:get/get.dart';
import 'package:tram/model/chart/bar_chart_data_model.dart';
import 'package:tram/model/chart/stacked_bar_chart_data_model.dart';
import 'package:tram/repository/other_repository.dart';
import 'package:tram/repository/road_repository.dart';

import '../../model/shared/loader_state_model.dart';

class SPIController extends GetxController {
  final repository = OtherRepository();
  Rx<LoaderState> state = LoaderState.initial.obs;
  RxList<BarChartData> list = RxList();

  @override
  void onInit() {
    load();
    super.onInit();
  }

  load() async {
    try {
      state.value = LoaderState.loading;
      final data = await repository.showSPI();
      List<BarChartData> temp = [];
      for (int i = 0; i < data.spiXAxis.length; i++) {
        final x = data.spiXAxis[i];
        final y = data.spiYAxis[i].replaceAll(" ", "");

        temp.add(
          BarChartData(x, double.parse(y)),
        );
      }
      list.value = temp;
      state.value = LoaderState.loaded;
    } catch (err) {
      print(err);
      state.value = LoaderState.failure;
    }
  }
}
