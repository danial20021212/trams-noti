import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tram/controller/auth/auth_controller.dart';
import 'package:tram/controller/form_depot/common/base_form_controller.dart';
import 'package:tram/controller/form_depot/form_G_controller.dart';
import 'package:tram/controller/form_depot/form_R_controller.dart';
import 'package:tram/model/form/form_depot/form_G/form_G_model.dart';
import 'package:tram/model/form/form_depot/form_R/form_R_model.dart';
import 'package:tram/provider/api_provider.dart';
import 'package:tram/screen/form_depot/form_G/pages/inspection_items_page.dart';
import 'package:tram/screen/form_depot/form_R/pages/inspection_data_page.dart';

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
      'formPage': 'inspection',
      'isResumeDraft': true,
    };
    Get.put<AuthController>(_TestAuthController());
    Get.put<ApiProvider>(ApiProvider());
    Get.put<BaseFormController>(BaseFormController());
  });

  tearDown(Get.reset);

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
  });

  Widget pageShell(Widget child) => GetMaterialApp(
        home: Scaffold(appBar: AppBar(), body: child),
      );

  testWidgets('Form G exposes eight independent applicability checkboxes',
      (tester) async {
    final controller = Get.put<FormGController>(FormGController());
    controller.form.value = FormGModel(
      barrierDistress: '1',
      barrierCritical: '1',
      barrierClosed: '0',
    );

    await tester.pumpWidget(pageShell(const InspectionItemsPage()));
    await tester.pump();

    expect(controller.inspectionItemCheckboxes, hasLength(8));
    expect(controller.inspectionItemCheckboxes.values, everyElement(isTrue));
    expect(find.byType(Checkbox), findsWidgets);
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();

    expect(controller.isInspectionItemChecked('1'), isFalse);
    expect(controller.getBarrierDistress, isEmpty);
    expect(controller.getBarrierCritical, isEmpty);
    expect(controller.getBarrierClosed, isEmpty);
  });

  testWidgets('Form R ND is exclusive and fixes severity at one',
      (tester) async {
    final controller = Get.put<FormRController>(FormRController());
    controller.form.value = FormRModel(
      distress: const ['R01', 'R02'],
      severity: '4',
    );
    controller.selectedDistress.assignAll(const ['R01', 'R02']);

    await tester.pumpWidget(pageShell(const InspectionDataPage()));
    await tester.pump();
    await tester.tap(find.text('No Distress Observed'));
    await tester.pump();

    expect(controller.getDistress, ['ND']);
    expect(controller.getSeverity, '1');

    await tester.tap(find.text('Buckling under Compression'));
    await tester.pump();

    expect(controller.getDistress, ['R01']);
    expect(controller.isNoDistressSelected, isFalse);
  });

  testWidgets('fresh Form R uses a valid minimum severity', (tester) async {
    Get.put<FormRController>(FormRController());

    await tester.pumpWidget(pageShell(const InspectionDataPage()));
    await tester.pump();
    await tester.dragUntilVisible(
      find.byType(Slider),
      find.byType(ListView),
      const Offset(0, -500),
    );

    expect(tester.takeException(), isNull);
    expect(tester.widget<Slider>(find.byType(Slider)).value, 1);
  });
}
