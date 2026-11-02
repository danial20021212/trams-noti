

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/form_R_controller.dart';
import '../common/base_form/paged_form_screen.dart';

class FormR2ReviewScreen extends StatefulWidget {
  const FormR2ReviewScreen({super.key});

  @override
  State<FormR2ReviewScreen> createState() => _FormR2ReviewScreenState();
}

class _FormR2ReviewScreenState extends State<FormR2ReviewScreen> {
  final controller = Get.find<FormRController>();

  @override
  void initState() {
    super.initState();
    final rawArguments = Get.arguments;
    final reviewRecordID =
        rawArguments is Map ? rawArguments['recID']?.toString() ?? '' : '';
    controller.baseFormController.configureContext(
      formType: 'R',
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
      title: 'Review Form R2',
      exitDialogTitle: 'Are you sure to exit review form R2 ?',
      pages: controller.reviewFormR2Pages,
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
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:get/get.dart';

// import '../../../controller/form_depot/form_R_controller.dart';
// import '../common/base_form/paged_form_screen.dart';

// class FormR2ReviewScreen extends StatelessWidget {
//   const FormR2ReviewScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<FormRController>();

//     return PagedFormScreen(
//       title: 'Review Form R2',
//       exitDialogTitle: 'Are you sure to exit review form R2 ?',
//       pages: controller.reviewFormR2Pages,
//       onPageControllerReady: (pageController) {
//         controller.pageController = pageController;
//       },
//       lastButtonTitle: 'Close',
//       footerPadding: const EdgeInsets.only(bottom: 20),
//       onLastPage: () async {
//         final recordID = controller.baseFormController.recID;
//         if (recordID.isNotEmpty) {
//           await controller.baseFormController.submitRemark(recordID);
//         }
//         Get.back();
//       },
//     );
//   }
// }
