import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/form_B_controller.dart';
import '../common/base_form/paged_form_screen.dart';

class FormB2ReviewScreen extends StatefulWidget {
  const FormB2ReviewScreen({super.key});

  @override
  State<FormB2ReviewScreen> createState() => _FormB2ReviewScreenState();
}

class _FormB2ReviewScreenState extends State<FormB2ReviewScreen> {
  final controller = Get.find<FormBController>();

  @override
  void initState() {
    super.initState();
    final rawArguments = Get.arguments;
    final reviewRecordID =
        rawArguments is Map ? rawArguments['recID']?.toString() ?? '' : '';
    controller.baseFormController.configureContext(
      formType: 'B',
      recID: reviewRecordID,
      reviewMode: true,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) controller.loadReviewData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PagedFormScreen(
      title: 'Review Form B2',
      exitDialogTitle: 'Are you sure to exit review form B2 ?',
      pages: controller.reviewFormB2Pages,
      onPageControllerReady: (pageController) {
        controller.pageController = pageController;
      },
      lastButtonTitle: 'Close',
      footerPadding: const EdgeInsets.only(bottom: 20),
      animateForward: false,
      animateBack: false,
      onLastPage: () async {
        final recordID = controller.baseFormController.recID;
        if (recordID.isNotEmpty) {
          await controller.baseFormController.submitRemark(recordID);
        }
        Get.back();
      },
    );
  }
}
