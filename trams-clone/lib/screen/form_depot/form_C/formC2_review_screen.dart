import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/common/base_form_controller.dart';
import '../../../controller/form_depot/form_C_controller.dart';
import '../common/base_form/paged_form_screen.dart';

class FormC2ReviewScreen extends StatefulWidget {
  const FormC2ReviewScreen({super.key});

  @override
  State<FormC2ReviewScreen> createState() => _FormC2ReviewScreenState();
}

class _FormC2ReviewScreenState extends State<FormC2ReviewScreen> {
  final controller = Get.find<FormCController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) controller.loadReviewData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PagedFormScreen(
      title: 'Review Form C2',
      exitDialogTitle: 'Are you sure to exit review form C2 ?',
      pages: controller.reviewFormC2Pages,
      onPageControllerReady: (pageController) {
        controller.pageController = pageController;
      },
      lastButtonTitle: 'Close',
      footerPadding: const EdgeInsets.only(bottom: 20),
      onLastPage: () async {
        final baseController = controller.baseFormController;
        final recordID = baseController.recID;
        if (recordID.isNotEmpty &&
            baseController.currentRole == Roles.cons &&
            !baseController.isReadOnly.value) {
          await baseController.submitRemark(recordID);
        }
        Get.back();
      },
    );
  }
}
