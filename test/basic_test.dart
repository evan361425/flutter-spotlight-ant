import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_ant/spotlight_ant.dart';
import 'package:spotlight_ant/src/spotlights/spotlight_backdrop_builder.dart';

void main() {
  group('Spotlight Ant and Show Interaction', () {
    testWidgets('basic', (WidgetTester tester) async {
      const actions = [
        SpotlightAntAction.prev,
        SpotlightAntAction.skip,
        SpotlightAntAction.next,
      ];
      final show = GlobalKey<SpotlightShowState>();
      int onShow = 0;
      int onShown = 0;
      int onDismiss = 0;
      int onDismissed = 0;
      int onSkip = 0;
      int onFinish = 0;

      await tester.pumpWidget(MaterialApp(
        home: SpotlightShow(
          key: show,
          onSkip: () => onSkip++,
          onFinish: () => onFinish++,
          child: Column(children: [
            SpotlightAnt(
              content: const SpotlightContent(child: Text('content-1')),
              duration: const SpotlightDurationConfig(
                zoomIn: Duration(milliseconds: 5),
                zoomOut: Duration(milliseconds: 5),
                contentFadeIn: Duration.zero,
              ),
              action: SpotlightActionConfig(
                enabled: actions,
                builder: (context, actions) {
                  return Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: actions.toList(),
                    ),
                  );
                },
              ),
              onShow: () => onShow++,
              onShown: () => onShown++,
              onDismiss: () => onDismiss++,
              onDismissed: () => onDismissed++,
              child: const Text('child-1'),
            ),
            SpotlightAnt(
              content: const SpotlightContent(child: Text('content-2')),
              duration: const SpotlightDurationConfig(
                zoomIn: Duration(milliseconds: 5),
                zoomOut: Duration(milliseconds: 5),
                contentFadeIn: Duration.zero,
              ),
              action: const SpotlightActionConfig(enabled: actions),
              contentLayout: const SpotlightContentLayoutConfig(
                prefer: ContentPreferLayout.largerRatio,
              ),
              spotlight: const SpotlightConfig(
                builder: SpotlightRectBuilder(),
              ),
              onShow: () => onShow += 2,
              onShown: () => onShown += 2,
              onDismiss: () => onDismiss += 2,
              onDismissed: () => onDismissed += 2,
              child: const Text('child-2'),
            ),
          ]),
        ),
      ));
      await tester.pumpAndSettle();

      expect(show.currentState?.isReadyToStart, isFalse);
      expect(show.currentState?.isNotReadyToStart, isTrue);
      expect(show.currentState?.isPerforming, isTrue);
      expect(onShow + onShown + onDismiss + onDismissed + onSkip + onFinish, isZero);

      // zoom in
      await tester.pump(const Duration(milliseconds: 1));
      expect(onShow, equals(1));
      expect(onShown, equals(0));
      // although found it but it should not been seen by user since the 0 opacity.
      expect(find.text('content-1'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 6));
      expect(onShown, equals(1));

      // zoom out
      await tester.tapAt(const Offset(10, 10));
      expect(onDismiss, equals(1));
      expect(onDismissed, equals(0));
      expect(onShow, equals(1));
      expect(onShown, equals(1));
      expect(find.text('content-1'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 6));
      expect(onDismissed, equals(1));
      expect(onShow, equals(3));
      expect(onShown, equals(1));
      expect(find.text('content-1'), findsNothing);

      // zoom in 2
      expect(find.text('content-2'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 6));
      expect(onShown, equals(3));

      // previous
      await tester.tap(find.byIcon(Icons.arrow_back_ios_sharp));
      expect(onDismiss, equals(3));
      expect(onDismissed, equals(1));
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 6)); // zoom out
      expect(onDismissed, equals(3));
      expect(onShow, equals(4));
      expect(onShown, equals(3));
      await tester.pump(const Duration(milliseconds: 6)); // zoom in
      expect(onShown, equals(4));

      // next
      await tester.tap(find.byIcon(Icons.arrow_forward_ios_sharp));
      expect(onDismiss, equals(4));
      expect(onDismissed, equals(3));
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 6)); // zoom out
      expect(onDismissed, equals(4));
      expect(onShow, equals(6));
      expect(onShown, equals(4));
      await tester.pump(const Duration(milliseconds: 6)); // zoom in
      expect(onShown, equals(6));

      // skip
      await tester.tap(find.byIcon(Icons.close_sharp));
      expect(onShow, equals(6));
      expect(onShown, equals(6));
      expect(onDismiss, equals(6));
      expect(onDismissed, equals(4)); // wait for zooming out
      expect(onSkip, equals(0));
      expect(onFinish, equals(0));

      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 6));
      expect(onDismissed, equals(6));
      expect(onSkip, equals(1));
      expect(onFinish, equals(0));
    });

    testWidgets('should disable', (WidgetTester tester) async {
      bool onShow = false;
      bool onFinish = false;

      await tester.pumpWidget(MaterialApp(
        home: SpotlightShow(
          onFinish: () => onFinish = true,
          child: Column(children: [
            SpotlightAnt(
              enable: false,
              content: const Text('content-1'),
              duration: SpotlightDurationConfig.zero,
              contentLayout: const SpotlightContentLayoutConfig(
                prefer: ContentPreferLayout.horizontal,
              ),
              onShow: () => onShow = true,
              child: const Text('child-1'),
            ),
          ]),
        ),
      ));
      await tester.pumpAndSettle();

      // wait the zero delay in `_startZoomIn`
      await tester.pump(const Duration(milliseconds: 5));

      expect(onShow, isFalse);
      expect(onFinish, isTrue);
    });

    testWidgets('control by show', (WidgetTester tester) async {
      final show = GlobalKey<SpotlightShowState>();
      int onShow = 0;
      int onDismiss = 0;
      int onSkip = 0;
      int onFinish = 0;

      await tester.pumpWidget(MaterialApp(
        home: SpotlightShow(
          key: show,
          onSkip: () => onSkip++,
          onFinish: () => onFinish++,
          child: Column(children: [
            SpotlightAnt(
              content: const Text('content-1'),
              duration: SpotlightDurationConfig.zero,
              spotlight: const SpotlightConfig(
                builder: SpotlightBackDropBuilder(),
                usingInkwell: false,
              ),
              backdrop: const SpotlightBackdropConfig(
                usingInkwell: false,
              ),
              onShow: () => onShow++,
              onDismiss: () => onDismiss++,
              child: const Text('child-1'),
            ),
            SpotlightAnt(
              content: const Text('content-2'),
              duration: SpotlightDurationConfig.zero,
              spotlight: const SpotlightConfig(
                silent: true,
                builder: SpotlightBackDropBuilder(),
              ),
              backdrop: const SpotlightBackdropConfig(silent: true),
              onShow: () => onShow += 2,
              onDismiss: () => onDismiss += 2,
              child: const Text('child-2'),
            ),
          ]),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 1)); // zoom in
      expect(onShow, equals(1));

      show.currentState?.next();
      await tester.pump(const Duration(milliseconds: 1)); // zoom out and in
      expect(onDismiss, equals(1));
      expect(onShow, equals(3));

      // silent should not fire tap event
      await tester.tapAt(Offset.zero);
      await tester.pump(const Duration(milliseconds: 1));
      expect(onDismiss, equals(1));

      show.currentState?.prev();
      await tester.pump(const Duration(milliseconds: 1));
      expect(onDismiss, equals(3));
      expect(onShow, equals(4));

      // skip by WillPopScope
      final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
      await widgetsAppState.didPopRoute();
      await tester.pump(const Duration(milliseconds: 1));

      expect(onDismiss, equals(4));
      expect(onShow, equals(4));
      expect(onSkip, equals(1));
      expect(onFinish, equals(0));

      // already finish should not fire again
      show.currentState?.skip();
      await tester.pump(const Duration(milliseconds: 1));
      expect(onSkip, equals(1));

      show.currentState?.start();
      await tester.pump(const Duration(milliseconds: 1));
      show.currentState?.finish();
      await tester.pump(const Duration(milliseconds: 1));
      expect(onFinish, equals(1));
      expect(onSkip, equals(1));
    });

    testWidgets('should finish press next in last ant', (tester) async {
      final show = GlobalKey<SpotlightShowState>();
      bool onShow = false;
      bool onFinish = false;

      await tester.pumpWidget(MaterialApp(
        home: SpotlightShow(
          key: show,
          onFinish: () => onFinish = true,
          child: Column(children: [
            SpotlightAnt(
              content: const Text('content-1'),
              duration: SpotlightDurationConfig.zero,
              onShow: () => onShow = true,
              child: const Text('child-1'),
            ),
          ]),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 5));
      expect(onShow, isTrue);

      show.currentState?.next();
      await tester.pump(const Duration(milliseconds: 1)); // zoom out and in
      expect(onFinish, isTrue);
    });

    testWidgets('should follow index', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: SpotlightShow(
          child: Column(children: [
            SpotlightAnt(
              index: 1,
              content: Text('content-1'),
              duration: SpotlightDurationConfig.zero,
              child: Text('child-1'),
            ),
            SpotlightAnt(
              index: 0,
              content: Text('content-2'),
              duration: SpotlightDurationConfig.zero,
              child: Text('child-2'),
            ),
          ]),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 1));
      expect(find.text('content-2'), findsOneWidget);
    });

    testWidgets('should skip when pop', (tester) async {
      bool skipped = false;
      await tester.pumpWidget(MaterialApp(
        home: SpotlightShow(
          onSkip: () => skipped = true,
          child: const SpotlightAnt(
            content: Text('content'),
            duration: SpotlightDurationConfig.zero,
            child: Text('child'),
          ),
        ),
      ));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 5));
      expect(find.text('content'), findsOneWidget);

      // Pop and pass the WillPopScope
      final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
      await widgetsAppState.didPopRoute();
      await tester.pumpAndSettle();

      expect(skipped, isTrue);
      expect(find.text('content'), findsNothing);
    });
  });
}
