import 'package:get/get.dart';
import 'package:tram/controller/form_depot/form_draft_controller.dart';

class FormDraftBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FormDraftController>(
          () => FormDraftController(),
    );
  }
}
