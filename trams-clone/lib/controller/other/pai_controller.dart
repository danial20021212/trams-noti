import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tram/model/basic/rc_date_model.dart';
import 'package:tram/model/chart/bar_chart_data_model.dart';
import 'package:tram/model/chart/stacked_bar_chart_data_model.dart';
import 'package:tram/repository/date_repository.dart';
import 'package:tram/repository/other_repository.dart';
import 'package:tram/repository/road_repository.dart';

import '../../model/shared/loader_state_model.dart';

class PAIController extends GetxController {
  final repository = OtherRepository();
 
  Rx<LoaderState> state = LoaderState.initial.obs;
  RxList<BarChartData> list = RxList();
  final tooltip =
      TooltipBehavior(enable: true, header: '', canShowMarker: false);
  // final trackBall = TrackballBehavior(
  //     enable: true, tooltipDisplayMode: TrackballDisplayMode.groupAllPoints);

  @override
  void onInit() {
    load();
    super.onInit();
  }

  

  load() async {
    try {
      state.value = LoaderState.loading;
      
      final data = await repository.showPAI();
      List<BarChartData> temp = [];
      for (int i = 0; i < data.paiXAxis.length; i++) {
        final x = data.paiXAxis[i];
        final y = data.paiYAxis[i];
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
