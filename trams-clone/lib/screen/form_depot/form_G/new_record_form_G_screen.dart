import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/form_G_controller.dart';
import '../common/base_form/paged_form_screen.dart';

class NewRecordFormGScreen extends StatelessWidget {
  const NewRecordFormGScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormGController>();

    return PagedFormScreen(
      title: 'Form G',
      exitDialogTitle: 'Are you sure to exit form G ?',
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
