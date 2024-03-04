import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_ant/spotlight_ant.dart';

void main() {
  group('Spotlight Ant and Custom Action button overrides', () {
    const duration = SpotlightDurationConfig(
      zoomIn: Duration(milliseconds: 5),
      zoomOut: Duration(milliseconds: 5),
      contentFadeIn: Duration.zero,
      bump: Duration.zero,
    );

    testWidgets('basic', (WidgetTester tester) async {
      const actions = [
        SpotlightAntAction.prev,
        SpotlightAntAction.skip,
        SpotlightAntAction.finish,
        SpotlightAntAction.next,
      ];
      final show = GlobalKey<SpotlightShowState>();
      const nextButton = ValueKey('next');
      const prevButton = ValueKey('prev');
      const skipButton = ValueKey('skip');

      int onShown = 0;
      int onDismissed = 0;
      int onSkip = 0;
      int onFinish = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: SpotlightShow(
            key: show,
            onSkip: () => onSkip++,
            onFinish: () => onFinish++,
            child: Column(
              children: [
                SpotlightAnt(
                  duration: duration,
                  content: const SpotlightContent(child: Text('content-1')),
                  onShown: () => onShown++,
                  onDismissed: () => onDismissed++,
                  action: SpotlightActionConfig(
                    enabled: actions,
                    next: (callback) => ElevatedButton(
                      key: nextButton,
                      onPressed: () => callback(),
                      child: const Text('Next'),
                    ),
                    skip: (callback) => ElevatedButton(
                      key: skipButton,
                      onPressed: () => callback(),
                      child: const Text('Skip'),
                    ),
                  ),
                  child: const Text('widget-1'),
                ),
                SpotlightAnt(
                  duration: duration,
                  content: const SpotlightContent(child: Text('content-2')),
                  onShown: () => onShown++,
                  onDismissed: () => onDismissed++,
                  action: SpotlightActionConfig(
                    enabled: actions,
                    prev: (callback) => ElevatedButton(
                      key: prevButton,
                      onPressed: () => callback(),
                      child: const Text('Prev'),
                    ),
                  ),
                  child: const Text('widget-2'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 1));
      expect(onShown, equals(0));
      expect(find.text('content-1'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 6));
      expect(onShown, equals(1));

      // forward
      await tester.tap(find.byKey(nextButton));
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 6));
      expect(find.text('content-2'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 6));
      expect(onShown, equals(2));

      // backward
      await tester.tap(find.byKey(prevButton));
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 6));
      expect(find.text('content-1'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 6));
      expect(onShown, equals(3));

      // skip
      await tester.tap(find.byKey(skipButton));
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 6));
      expect(find.text('content-1'), findsNothing);
      expect(find.text('content-2'), findsNothing);

      expect(onSkip, equals(1));
      expect(onFinish, equals(0));
    });

    testWidgets('finish', (tester) async {
      final show = GlobalKey<SpotlightShowState>();
      const button = ValueKey('finish');

      int onSkip = 0;
      int onFinish = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: SpotlightShow(
            key: show,
            onSkip: () => onSkip++,
            onFinish: () => onFinish++,
            child: Column(
              children: [
                SpotlightAnt(
                  duration: duration,
                  content: const SpotlightContent(child: Text('content-1')),
                  action: SpotlightActionConfig(
                    enabled: [SpotlightAntAction.finish],
                    finish: (callback) => ElevatedButton(
                      key: button,
                      onPressed: () => callback(),
                      child: const Text('Finish'),
                    ),
                  ),
                  child: const Text('widget-1'),
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 6));
      expect(find.text('content-1'), findsOneWidget);

      // finish
      await tester.tap(find.byKey(button));
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 6));
      expect(find.text('content-1'), findsNothing);
      expect(onSkip, equals(0));
      expect(onFinish, equals(1));
    });
  });
}
