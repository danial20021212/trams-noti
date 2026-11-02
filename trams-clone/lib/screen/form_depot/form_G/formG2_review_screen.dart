import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/form_G_controller.dart';
import '../common/base_form/paged_form_screen.dart';

class FormG2ReviewScreen extends StatefulWidget {
  const FormG2ReviewScreen({super.key});

  @override
  State<FormG2ReviewScreen> createState() => _FormG2ReviewScreenState();
}

class _FormG2ReviewScreenState extends State<FormG2ReviewScreen> {
  final controller = Get.find<FormGController>();

  @override
  void initState() {
    super.initState();
    final rawArguments = Get.arguments;
    final reviewRecordID =
        rawArguments is Map ? rawArguments['recID']?.toString() ?? '' : '';
    controller.baseFormController.configureContext(
      formType: 'G',
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
      title: 'Review Form G2',
      exitDialogTitle: 'Are you sure to exit review form G2 ?',
      pages: controller.reviewFormG2Pages,
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

// import '../../../controller/form_depot/form_G_controller.dart';
// import '../common/base_form/paged_form_screen.dart';

// class FormG2ReviewScreen extends StatelessWidget {
//   const FormG2ReviewScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<FormGController>();

//     return PagedFormScreen(
//       title: 'Review Form G2',
//       exitDialogTitle: 'Are you sure to exit review form G2 ?',
//       pages: controller.reviewFormG2Pages,
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


