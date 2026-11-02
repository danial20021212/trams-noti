import 'package:get/get.dart';

import '../../model/basic/rc_date_model.dart';
import '../../repository/date_repository.dart';

class DashboardController extends GetxController {
  final dateRepository = DateRepository();

  Rx<RcDateModel?> dateModel = Rxn();

  loadDate() async {
    try {
      dateModel.value = await dateRepository.showRcDate();
    } catch (err) {
      print(err);
    }
  }

  @override
  void onInit() {
    loadDate();
    super.onInit();
  }
}
