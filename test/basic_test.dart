import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_ant/spotlight_ant.dart';

void main() {
  group('Spotlight Ant and Gaffer Interaction', () {
    testWidgets('basic', (WidgetTester tester) async {
      const actions = [
        SpotlightAntAction.prev,
        SpotlightAntAction.skip,
        SpotlightAntAction.next,
      ];
      final ant1 = GlobalKey<SpotlightAntState>();
      final ant2 = GlobalKey<SpotlightAntState>();
      int onShow = 0;
      int onShown = 0;
      int onDismiss = 0;
      int onDismissed = 0;
      int onSkip = 0;
      int onFinish = 0;

      await tester.pumpWidget(MaterialApp(
        home: Column(children: [
          SpotlightAnt(
            key: ant1,
            ants: [ant1, ant2],
            content: const SpotlightContent(child: Text('content-1')),
            zoomInDuration: const Duration(milliseconds: 5),
            zoomOutDuration: const Duration(milliseconds: 5),
            contentFadeInDuration: Duration.zero,
            actions: actions,
            onShow: () => onShow++,
            onShown: () => onShown++,
            onDismiss: () => onDismiss++,
            onDismissed: () => onDismissed++,
            onSkip: () => onSkip++,
            onFinish: () => onFinish++,
            child: const Text('child-1'),
          ),
          SpotlightAnt(
            key: ant2,
            content: const SpotlightContent(child: Text('content-2')),
            zoomInDuration: const Duration(milliseconds: 5),
            zoomOutDuration: const Duration(milliseconds: 5),
            contentFadeInDuration: Duration.zero,
            spotlightBuilder: const SpotlightRectBuilder(),
            actions: actions,
            onShow: () => onShow += 2,
            onShown: () => onShown += 2,
            onDismiss: () => onDismiss += 2,
            onDismissed: () => onDismissed += 2,
            child: const Text('child-2'),
          ),
        ]),
      ));
      await tester.pumpAndSettle();

      expect(ant1.currentState?.isShowing, isTrue);
      expect(onShow + onShown + onDismiss + onDismissed + onSkip + onFinish,
          isZero);

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
      await tester.tap(find.text('PREV'));
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
      await tester.tap(find.text('NEXT'));
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
      await tester.tap(find.text('SKIP'));
      expect(onShow, equals(6));
      expect(onShown, equals(6));
      expect(onDismiss, equals(6));
      expect(onDismissed, equals(4)); // wait for zooming out
      expect(onSkip, equals(1));
      expect(onFinish, equals(0));

      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump(const Duration(milliseconds: 6));
      expect(onDismissed, equals(6));
      expect(onFinish, equals(1));
    });

    testWidgets('should disable', (WidgetTester tester) async {
      final ant = GlobalKey<SpotlightAntState>();
      bool onShow = false;
      bool onFinish = false;

      await tester.pumpWidget(MaterialApp(
        home: Column(children: [
          SpotlightAnt(
            key: ant,
            ants: [ant],
            enable: false,
            content: const Text('content-1'),
            zoomInDuration: Duration.zero,
            zoomOutDuration: Duration.zero,
            contentFadeInDuration: Duration.zero,
            onShow: () => onShow = true,
            onFinish: () => onFinish = true,
            child: const Text('child-1'),
          ),
        ]),
      ));
      await tester.pumpAndSettle();

      // wait the zero delay in `_startZoomIn`
      await tester.pump(const Duration(milliseconds: 5));

      expect(onShow, isFalse);
      expect(onFinish, isTrue);
    });

    testWidgets('control by ant', (WidgetTester tester) async {
      final ant1 = GlobalKey<SpotlightAntState>();
      final ant2 = GlobalKey<SpotlightAntState>();
      int onShow = 0;
      int onDismiss = 0;
      int onSkip = 0;
      int onFinish = 0;

      await tester.pumpWidget(MaterialApp(
        home: Column(children: [
          SpotlightAnt(
            key: ant1,
            ants: [ant1, ant2],
            content: const Text('content-1'),
            zoomInDuration: Duration.zero,
            zoomOutDuration: Duration.zero,
            contentFadeInDuration: Duration.zero,
            spotlightUsingInkwell: false,
            backdropUsingInkwell: false,
            onShow: () => onShow++,
            onDismiss: () => onDismiss++,
            onSkip: () => onSkip++,
            onFinish: () => onFinish++,
            child: const Text('child-1'),
          ),
          SpotlightAnt(
            key: ant2,
            content: const Text('content-2'),
            zoomInDuration: Duration.zero,
            zoomOutDuration: Duration.zero,
            contentFadeInDuration: Duration.zero,
            spotlightSilent: true,
            backdropSilent: true,
            onShow: () => onShow += 2,
            onDismiss: () => onDismiss += 2,
            child: const Text('child-2'),
          ),
        ]),
      ));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 1)); // zoom in
      expect(onShow, equals(1));

      ant1.currentState?.next();
      await tester.pump(const Duration(milliseconds: 1)); // zoom out and in
      expect(onDismiss, equals(1));
      expect(onShow, equals(3));

      // silent should not fire tap event
      await tester.tapAt(Offset.zero);
      await tester.pump(const Duration(milliseconds: 1));
      expect(onDismiss, equals(1));

      ant1.currentState?.prev();
      await tester.pump(const Duration(milliseconds: 1));
      expect(onDismiss, equals(3));
      expect(onShow, equals(4));

      ant1.currentState?.skip();
      await tester.pump(const Duration(milliseconds: 1));
      expect(onDismiss, equals(4));
      expect(onShow, equals(4));
      expect(onSkip, equals(1));
      expect(onFinish, equals(1));

      // already finish should not fire again
      ant1.currentState?.skip();
      await tester.pump(const Duration(milliseconds: 1));
      ant1.currentState?.finish();
      await tester.pump(const Duration(milliseconds: 1));
      expect(onSkip, equals(1));
      expect(onFinish, equals(1));
    });

    testWidgets('should finish press next in last ant', (tester) async {
      final ant = GlobalKey<SpotlightAntState>();
      bool onShow = false;
      bool onFinish = false;

      await tester.pumpWidget(MaterialApp(
        home: Column(children: [
          SpotlightAnt(
            key: ant,
            ants: [ant],
            content: const Text('content-1'),
            zoomInDuration: Duration.zero,
            zoomOutDuration: Duration.zero,
            contentFadeInDuration: Duration.zero,
            onShow: () => onShow = true,
            onFinish: () => onFinish = true,
            child: const Text('child-1'),
          ),
        ]),
      ));
      await tester.pumpAndSettle();

      await tester.pump(const Duration(milliseconds: 5));
      expect(onShow, isTrue);

      ant.currentState?.next();
      await tester.pump(const Duration(milliseconds: 1)); // zoom out and in
      expect(onFinish, isTrue);
    });
  });
}
