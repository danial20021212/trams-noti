import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/controller/form_depot/common/base_form_controller.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/provider/api_provider.dart';
import 'package:tram/screen/form_depot/common/base_form/photographs_page.dart';

class _TestAuthController extends AuthController {
  @override
  String? getUserType() => 'Service Provider';
}

class _PhotoTestController extends BaseFormController {
  @override
  void onInit() {}
}

void main() {
  testWidgets(
      'Form C labels every reference position and enables non-sequential uploads',
      (tester) async {
    Get.testMode = true;
    addTearDown(Get.reset);
    Get.put<AuthController>(_TestAuthController());
    Get.put<ApiProvider>(ApiProvider());
    final controller = Get.put<BaseFormController>(_PhotoTestController())
      ..formType = 'C'
      ..state.value = LoaderState.loaded;

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          appBar: AppBar(),
          body: const PhotographsPage(),
        ),
      ),
    );
    await tester.pump();

    for (final label in const [
      'P1: Culvert Marker (LHS or RHS)',
      'P2: Waterway & Embankment (Upstream)',
      'P3: Waterway & Embankment (Downstream)',
      'P4: Headwall Wingwall (Inlet)',
      'P5: Headwall Wingwall (Outlet)',
      'P6: Barrel(s) (Culvert Unit(s))',
      'P7: Culvert Approach (Pavement)',
    ]) {
      expect(find.text(label), findsOneWidget);
    }

    expect(find.text('Choose photo'), findsNWidgets(7));
    final chooseButtons = tester.widgetList<NeumorphicButton>(
      find.widgetWithText(NeumorphicButton, 'Choose photo'),
    );
    expect(
        chooseButtons,
        everyElement(predicate<NeumorphicButton>(
          (button) => button.onPressed != null,
        )));

    final additionalButton = tester.widget<NeumorphicButton>(
      find.widgetWithText(NeumorphicButton, 'Add additional photo'),
    );
    expect(additionalButton.onPressed, isNotNull);
    expect(controller.nextAvailablePhotoNumber(startAt: 8), 8);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}
