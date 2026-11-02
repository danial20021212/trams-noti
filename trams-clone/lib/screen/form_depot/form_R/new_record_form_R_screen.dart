import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/form_R_controller.dart';
import '../common/base_form/paged_form_screen.dart';

class NewRecordFormRScreen extends StatelessWidget {
  const NewRecordFormRScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormRController>();

    return PagedFormScreen(
      title: 'Form R',
      exitDialogTitle: 'Are you sure to exit form R ?',
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
