import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/form_C_controller.dart';
import '../common/base_form/paged_form_screen.dart';

class NewRecordFormCScreen extends StatelessWidget {
  const NewRecordFormCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormCController>();

    return PagedFormScreen(
      title: 'Form C',
      exitDialogTitle: 'Are you sure to exit form C ?',
      pages: controller.newRecordPages,
      onPageControllerReady: (pageController) {
        controller.pageController = pageController;
      },
      lastButtonTitle: 'Save',
      onLastPage: controller.submitNewRecord,
      footerHeight: 100,
    );
  }
}
