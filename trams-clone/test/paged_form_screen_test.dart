import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tram/screen/form_depot/common/base_form/paged_form_screen.dart';

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

  testWidgets('record pager preserves its 100 pixel footer on every viewport',
      (tester) async {
    for (final size in const [
      Size(390, 844),
      Size(768, 1024),
      Size(1440, 900),
    ]) {
      await _setViewport(tester, size);
      var saved = false;

      await tester.pumpWidget(
        _testApp(
          PagedFormScreen(
            key: ValueKey(size),
            title: 'Form G',
            exitDialogTitle: 'Exit Form G?',
            pages: const [
              ColoredBox(color: Colors.white),
              ColoredBox(color: Colors.white),
            ],
            onPageControllerReady: (_) {},
            lastButtonTitle: 'Save',
            onLastPage: () async => saved = true,
            footerHeight: 100,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final footer = tester.widget<Container>(
        find.byKey(const ValueKey('paged-form-footer')),
      );
      expect(footer.constraints?.maxHeight, 100);
      expect(find.text('Continue'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Save'), findsOneWidget);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(saved, isTrue);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('review pager preserves footer padding and back behavior',
      (tester) async {
    await _setViewport(tester, const Size(390, 844));
    await tester.pumpWidget(
      _testApp(
        PagedFormScreen(
          title: 'Review Form R2',
          exitDialogTitle: 'Exit review Form R2?',
          pages: const [
            ColoredBox(color: Colors.white),
            ColoredBox(color: Colors.white),
          ],
          onPageControllerReady: (_) {},
          lastButtonTitle: 'Close',
          footerPadding: const EdgeInsets.only(bottom: 20),
          onLastPage: () async {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    final footer = tester.widget<Container>(
      find.byKey(const ValueKey('paged-form-footer')),
    );
    expect(
        (footer.child! as Padding).padding, const EdgeInsets.only(bottom: 20));

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Close'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Continue'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Exit review Form R2?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pager supports the Form B read-only and exit hooks',
      (tester) async {
    var exited = false;
    await _setViewport(tester, const Size(390, 844));
    await tester.pumpWidget(
      _testApp(
        PagedFormScreen(
          title: 'Form B',
          exitDialogTitle: 'Exit Form B?',
          pages: const [ColoredBox(color: Colors.white)],
          onPageControllerReady: (_) {},
          lastButtonTitle: 'Save',
          lastButtonTitleBuilder: () => 'Close',
          onLastPage: () async {},
          onExit: () => exited = true,
          footerHeight: 100,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Close'), findsOneWidget);
    expect(find.text('Save'), findsNothing);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();

    expect(exited, isTrue);
    expect(tester.takeException(), isNull);
  });
}
