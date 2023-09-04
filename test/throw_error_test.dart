import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_ant/spotlight_ant.dart';

void main() {
  group('Scenario that should throw exception', () {
    testWidgets("access SpotlightShow from non-exist context", (tester) async {
      final show = GlobalKey<SpotlightShowState>();
      int buildTimes = 0;

      await tester.pumpWidget(MaterialApp(
        home: Column(children: [
          Builder(builder: (context) {
            buildTimes++;
            expect(() => SpotlightShow.of(context), throwsAssertionError);
            return const SizedBox.shrink();
          }),
          SpotlightShow(
            key: show,
            child: Builder(
              builder: (context) {
                buildTimes++;
                expect(SpotlightShow.of(context), equals(show.currentState));
                return const SpotlightAnt(
                  duration: SpotlightDurationConfig.zero,
                  child: Text('hi'),
                );
              },
            ),
          ),
        ]),
      ));

      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 1));

      expect(buildTimes, equals(2));
    });
  });
}
