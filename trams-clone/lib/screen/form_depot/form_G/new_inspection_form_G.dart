import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/form_G_controller.dart';
import '../../../model/shared/loader_state_model.dart';
import '../common/base_form/inspection_form_screen.dart';

class NewInspectionFormGScreen extends StatelessWidget {
  const NewInspectionFormGScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormGController>();

    return InspectionFormScreen(
      pages: controller.newInspectionPages,
      exitDialogTitle: 'Are you sure to exit form G ?',
      onPageControllerReady: (pageController) {
        controller.pageController = pageController;
      },
      onSaveDraft: () async {
        controller.state.value = LoaderState.loading;
        await Future<void>.delayed(const Duration(seconds: 2));
        await controller.saveDraft();
        controller.state.value = LoaderState.loaded;
      },
      onSubmit: controller.submitNewInspection,
      submitState: controller.state,
    );
  }
}
