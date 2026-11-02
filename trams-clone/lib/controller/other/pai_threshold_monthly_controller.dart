// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// import '../../model/basic/other/pai_threshold_model.dart';
// import '../../model/chart/bar_chart_data_model.dart';
// import '../../model/shared/loader_state_model.dart';
// import '../../repository/other_repository.dart';

// class PAIThresholdController extends GetxController {
//   final repository = OtherRepository();

//   Rx<LoaderState> state = LoaderState.initial.obs;
//   RxList<BarChartData> list = RxList();
//   final tooltip = TooltipBehavior(enable: true, header: '', canShowMarker: false);
//   Rx<PaiThresholdModel> thresholdData = Rx<PaiThresholdModel>(const PaiThresholdModel(httpStatus: '', paiXAxis: [], paiYAxis: [], threshold: 0.0));

//   RxString displayMonth = ''.obs; // To hold the month
//   RxInt displayYear = 0.obs;      // To hold the year

//   @override
//   void onInit() {
//     load(); // Load data when the controller is initialized
//     super.onInit();
//   }

//   load() async {
//     try {
//       state.value = LoaderState.loading;

//       final data = await repository.showPAIThresholdMonthlyToken();
//       thresholdData.value = data; // Store the fetched threshold data

//       // If displayMonth and displayYear exist, assign them
//       displayMonth.value = data.displayMonth ?? '';
//       displayYear.value = data.displayYear ?? 0;

//       List<BarChartData> temp = [];
//       for (int i = 0; i < data.paiXAxis.length; i++) {
//         final x = data.paiXAxis[i];
//         final y = data.paiYAxis[i];
//         temp.add(BarChartData(x, double.parse(y))); // Ensure y is parsed correctly
//       }
//       list.value = temp;
//       state.value = LoaderState.loaded;

//       // Optionally, print or use the month and year
//       print('Month: ${displayMonth.value}, Year: ${displayYear.value}');
//     } catch (err) {
//       print(err);
//       state.value = LoaderState.failure;
//     }
//   }
// }
