import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/controller/form_depot/common/base_form_controller.dart';
import 'package:tram/controller/form_depot/form_B_controller.dart';
import 'package:tram/provider/api_provider.dart';
import 'package:tram/screen/form_depot/form_B/pages/primary_member_page.dart';
import 'package:tram/screen/form_depot/form_B/pages/secondary_member_page.dart';

class _TestAuthController extends AuthController {
  @override
  String? getUserType() => 'Service Provider';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
          pathProviderChannel, (_) async => '/private/tmp');

  setUp(() {
    Get.testMode = true;
    Get.reset();
    Get.routing.args = {
      'formType': 'B',
      'formPage': 'inspection',
      'isResumeDraft': true,
    };
    Get.put<AuthController>(_TestAuthController());
    Get.put<ApiProvider>(ApiProvider());
    Get.put<BaseFormController>(BaseFormController());
    Get.put<FormBController>(FormBController());
  });

  tearDown(Get.reset);

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  Widget pageShell(Widget child) => GetMaterialApp(
        home: Scaffold(
          appBar: AppBar(),
          body: child,
        ),
      );

  testWidgets('primary members expose five independent applicability boxes',
      (tester) async {
    final controller = Get.find<FormBController>();

    await tester.pumpWidget(pageShell(const PrimaryMemberPage()));
    await tester.pump();

    expect(find.byType(Checkbox), findsNWidgets(5));
    expect(controller.memberCheckboxes.values, everyElement(isTrue));

    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();

    expect(controller.isMemberChecked('P1'), isFalse);
    expect(find.text('Material *'), findsNWidgets(4));
  });

  testWidgets('secondary members expose seven independent applicability boxes',
      (tester) async {
    final controller = Get.find<FormBController>();

    await tester.pumpWidget(pageShell(const SecondaryMemberPage()));
    await tester.pump();

    expect(find.byType(Checkbox), findsNWidgets(7));

    final lastCheckbox = find.byType(Checkbox).last;
    await tester.ensureVisible(lastCheckbox);
    await tester.pumpAndSettle();
    await tester.tap(lastCheckbox);
    await tester.pump();

    expect(controller.isMemberChecked('S7'), isFalse);
    expect(find.text('Material *'), findsNWidgets(6));
  });
}
