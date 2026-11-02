import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tram/model/shared/loader_state_model.dart';
import 'package:tram/screen/form_depot/common/base_form/inspection_form_screen.dart';

Widget _testApp(Widget child) {
  return NeumorphicTheme(
    themeMode: ThemeMode.light,
    theme: const NeumorphicThemeData(
      lightSource: LightSource.topLeft,
      depth: 4,
      intensity: 0.9,
    ),
    child: GetMaterialApp(home: child),
  );
}

Future<void> _setViewport(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.view.viewInsets = FakeViewPadding.zero;
}

void main() {
  tearDown(() {
    TestWidgetsFlutterBinding.ensureInitialized()
        .platformDispatcher
        .clearAllTestValues();
  });

  testWidgets('inspection shell keeps its controls on compact and wide layouts',
      (tester) async {
    for (final size in const [
      Size(390, 844),
      Size(768, 1024),
      Size(1440, 900),
    ]) {
      await _setViewport(tester, size);
      PageController? assignedController;

      await tester.pumpWidget(
        _testApp(
          InspectionFormScreen(
            key: ValueKey(size),
            pages: const [
              ColoredBox(color: Colors.white),
              ColoredBox(color: Colors.white),
            ],
            exitDialogTitle: 'Exit test form?',
            onPageControllerReady: (value) => assignedController = value,
            onSaveDraft: () async {},
            onSubmit: () async {},
            submitState: LoaderState.loaded.obs,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('New Inspection'), findsOneWidget);
      expect(
        tester
            .widget<Visibility>(
              find.byKey(const ValueKey('inspection-bottom-controls')),
            )
            .visible,
        isTrue,
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Continue'), findsOneWidget);
      expect(assignedController, isNotNull);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Save as draft'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('inspection shell preserves back and submit dialog behavior',
      (tester) async {
    var submitted = false;
    await _setViewport(tester, const Size(390, 844));
    await tester.pumpWidget(
      _testApp(
        InspectionFormScreen(
          pages: const [ColoredBox(color: Colors.white)],
          exitDialogTitle: 'Exit test form?',
          onPageControllerReady: (_) {},
          onSaveDraft: () async {},
          onSubmit: () async => submitted = true,
          submitState: LoaderState.loaded.obs,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Submit Inspection?'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);

    await tester.tap(find.text('Submit').last);
    await tester.pumpAndSettle();
    expect(submitted, isTrue);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Exit test form?'), findsOneWidget);
  });
}
