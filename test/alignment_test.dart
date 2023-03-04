import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_ant/spotlight_ant.dart';

void main() {
  group('SpotlightAnt automatic setup different alignment', () {
    Future<GlobalKey<SpotlightShowState>> prepare(
      WidgetTester tester,
      Alignment alignment,
    ) async {
      final show = GlobalKey<SpotlightShowState>();
      await tester.pumpWidget(MaterialApp(
        home: SpotlightShow(
          key: show,
          child: Stack(children: [
            Align(
              alignment: alignment,
              child: const SpotlightAnt(
                content: Center(child: Text('content')),
                zoomInDuration: Duration.zero,
                zoomOutDuration: Duration.zero,
                contentFadeInDuration: Duration.zero,
                preferVertical: false,
                child: Text('child'),
              ),
            ),
          ]),
        ),
      ));
      await tester.pumpAndSettle();

      // zoom in
      await tester.pump(const Duration(milliseconds: 1));

      return show;
    }

    Offset getContentCenter(WidgetTester tester) {
      return tester.getCenter(find.text('content'));
    }

    Size getWindowSize(GlobalKey<SpotlightShowState> show) {
      return MediaQuery.of(show.currentState!.gaffer.currentState!.currentAnt!.context).size;
    }

    testWidgets('Alignment.topLeft', (tester) async {
      final show = await prepare(tester, Alignment.topLeft);

      final content = getContentCenter(tester);
      final window = getWindowSize(show) / 2;

      // bottom center
      expect(content.dx, closeTo(window.width, 1));
      expect(content.dy, greaterThan(window.height));
    });

    testWidgets('Alignment.centerLeft', (tester) async {
      final show = await prepare(tester, Alignment.centerLeft);

      final content = getContentCenter(tester);
      final window = getWindowSize(show) / 2;

      // center right
      expect(content.dx, greaterThan(window.width));
      expect(content.dy, closeTo(window.height, 1));
    });

    testWidgets('Alignment.bottomRight', (tester) async {
      final show = await prepare(tester, Alignment.bottomRight);

      final content = getContentCenter(tester);
      final window = getWindowSize(show) / 2;

      // top center
      expect(content.dx, closeTo(window.width, 1));
      expect(content.dy, lessThan(window.height));
    });

    testWidgets('Alignment.center', (tester) async {
      final show = await prepare(tester, Alignment.center);

      final content = getContentCenter(tester);
      final window = getWindowSize(show) / 2;

      // bottom center
      expect(content.dx, closeTo(window.width, 1));
      expect(content.dy, greaterThan(window.height));
    });

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });
  });
}
