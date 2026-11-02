import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/form_B_controller.dart';
import '../../../controller/form_depot/main_listing/main_listing_controller.dart';
import '../common/base_form/paged_form_screen.dart';

class NewRecordFormBScreen extends StatelessWidget {
  const NewRecordFormBScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FormBController>();
    final mainListingController = Get.find<MainListingController>();

    return PagedFormScreen(
      title: 'Form B',
      exitDialogTitle: 'Are you sure to exit form B ?',
      pages: controller.newRecordPages,
      onPageControllerReady: (pageController) {
        controller.pageController = pageController;
      },
      lastButtonTitle: 'Save',
      lastButtonTitleBuilder: () =>
          controller.isReadOnly.value ? 'Close' : 'Save',
      onLastPage: () async {
        if (controller.isReadOnly.value) {
          Get.back();
        }
      },
      onExit: () {
        mainListingController.isFilterApplied.value = false;
      },
      footerHeight: 100,
    );
  }
}
