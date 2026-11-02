import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/form_C_controller.dart';
import '../common/base_form/inspection_form_screen.dart';

class NewInspectionFormCScreen extends StatefulWidget {
  const NewInspectionFormCScreen({super.key});

  @override
  State<NewInspectionFormCScreen> createState() =>
      _NewInspectionFormCScreenState();
}

class _NewInspectionFormCScreenState extends State<NewInspectionFormCScreen> {
  final controller = Get.find<FormCController>();

  @override
  void initState() {
    super.initState();
    controller.baseFormController.configureContext(
      formType: 'C',
      recID: Get.arguments['recID']?.toString() ?? '',
      reviewMode: false,
    );
    controller.baseFormController.isReadOnly.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return InspectionFormScreen(
      pages: controller.newInspectionPages,
      exitDialogTitle: 'Are you sure to exit form C ?',
      onPageControllerReady: (pageController) {
        controller.pageController = pageController;
      },
      onSaveDraft: controller.saveDraft,
      onSubmit: controller.submitNewInspection,
      submitState: controller.state,
      saveDraftState: controller.state,
    );
  }
}
