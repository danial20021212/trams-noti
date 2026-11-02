import 'dart:async';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../../controller/form_depot/form_B_controller.dart';
import '../../../model/shared/loader_state_model.dart';
import '../common/base_form/inspection_form_screen.dart';

class NewInspectionFormBScreen extends StatefulWidget {
  const NewInspectionFormBScreen({super.key});

  @override
  State<NewInspectionFormBScreen> createState() =>
      _NewInspectionFormBScreenState();
}

class _NewInspectionFormBScreenState extends State<NewInspectionFormBScreen> {
  final controller = Get.find<FormBController>();

  StreamSubscription<LoaderState>? _stateSubscription;
  bool _hasNotified = false;

  @override
  void initState() {
    super.initState();
    _stateSubscription = controller.state.listen((state) {
      if (state == LoaderState.loaded && !_hasNotified) {
        _hasNotified = true;
        Future<void>.delayed(const Duration(milliseconds: 500), () {
          _showPreviousDataNotification();
        });
      }
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InspectionFormScreen(
      pages: controller.newInspectionPages,
      exitDialogTitle: 'Are you sure to exit form B ?',
      onPageControllerReady: (pageController) {
        controller.pageController = pageController;
      },
      onSaveDraft: controller.saveDraft,
      onSubmit: controller.submitNewInspection,
      submitState: controller.state,
      saveDraftState: controller.state,
    );
  }

  void _showPreviousDataNotification() {
    final bool isResumeDraft = Get.arguments['isResumeDraft'] ?? false;
    final String? previousRecordID = Get.arguments['previousRecID'];

    if (!isResumeDraft &&
        previousRecordID != null &&
        previousRecordID.isNotEmpty) {
      final String previousDate =
          Get.arguments['previousInspectionDate'] ?? 'the latest record';

      Get.snackbar(
        'Auto-Filled',
        'Data auto-filled using inspection from: $previousDate',
        duration: const Duration(seconds: 5),
      );
    }
  }
}
