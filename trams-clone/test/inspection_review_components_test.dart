import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tram/screen/form_depot/common/inspection_review_components.dart';

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

  testWidgets('review components preserve spacing across supported viewports',
      (tester) async {
    for (final size in const [
      Size(390, 844),
      Size(768, 1024),
      Size(1440, 900),
    ]) {
      await _setViewport(tester, size);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            backgroundColor: inspectionReviewBaseColor,
            body: SingleChildScrollView(
              child: Column(
                children: const [
                  InspectionDateBanner(date: '2026-09-22'),
                  InspectionReviewGroup(
                    headerTitle: 'Site Condition',
                    initiallyExpanded: true,
                    children: [
                      SizedBox(height: 80, child: Text('Review details')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Inspection Date: 2026-09-22'), findsOneWidget);
      expect(find.text('SITE CONDITION'), findsOneWidget);
      expect(find.text('Review details'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('review back button and retry panel preserve their actions',
      (tester) async {
    var backPressed = false;
    var retryPressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              InspectionReviewBackButton(
                onPressed: () => backPressed = true,
              ),
              InspectionReviewRetryPanel(
                onRetry: () => retryPressed = true,
              ),
            ],
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(InspectionReviewRetryPanel)).height,
      270,
    );
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retry ?'));
    await tester.pumpAndSettle();

    expect(backPressed, isTrue);
    expect(retryPressed, isTrue);
    expect(tester.takeException(), isNull);
  });
}
