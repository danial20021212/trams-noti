import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tram/components/Neumorphic/tile_bottom_bar.dart';
import 'package:tram/screen/form_depot/common/form_depot_screen.dart';
import 'package:tram/screen/home/dashboard_screen.dart';

Widget _testApp(Widget child) {
  return NeumorphicTheme(
    themeMode: ThemeMode.light,
    theme: const NeumorphicThemeData(
      lightSource: LightSource.topLeft,
      depth: 4,
      intensity: 0.9,
    ),
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

Future<void> _setViewport(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
}

void main() {
  tearDown(() {
    TestWidgetsFlutterBinding.ensureInitialized()
        .platformDispatcher
        .clearAllTestValues();
  });

  testWidgets('bottom navigation controls remain compact on every viewport',
      (tester) async {
    for (final size in const [
      Size(390, 844),
      Size(768, 1024),
      Size(960, 900),
    ]) {
      await _setViewport(tester, size);
      await tester.pumpWidget(
        _testApp(
          Row(
            children: [
              NeumorphicTileBottomBar(
                icon: Icons.home,
                title: 'Home',
                pressed: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(NeumorphicTileBottomBar)).height,
        60,
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('dashboard option rows adapt without overflow', (tester) async {
    for (final size in const [
      Size(390, 844),
      Size(768, 1024),
      Size(960, 900),
      Size(1440, 900),
    ]) {
      await _setViewport(tester, size);
      final keys = List.generate(7, (index) => Key('option-$index'));
      await tester.pumpWidget(
        _testApp(
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: size.width,
              child: generateColumn(
                keys
                    .map(
                      (key) => SizedBox(
                        key: key,
                        height: 80,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byKey(keys.last), findsOneWidget);
    }
  });

  testWidgets('Form Depot is responsive and pagination is unchanged',
      (tester) async {
    for (final size in const [
      Size(390, 844),
      Size(768, 1024),
      Size(960, 900),
      Size(1440, 900),
    ]) {
      await _setViewport(tester, size);
      await tester.pumpWidget(_testApp(const FormDepotScreen()));
      await tester.pump();

      expect(find.text('FORM B'), findsOneWidget);
      expect(find.text('FORM M'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    await tester.tap(find.text('2'));
    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('FORM B'), findsNothing);
    expect(find.text('FORM FC'), findsOneWidget);
    expect(find.text('FORM F5'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
