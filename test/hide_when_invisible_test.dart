import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotlight_ant/spotlight_ant.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  group('Invisible Check', () {
    testWidgets('not show if invisible', (tester) async {
      final hider = GlobalKey<_HiderState>();
      late BuildContext ctx;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SpotlightShow(
            child: Builder(
              builder: (context) {
                ctx = context;
                return Hider(key: hider);
              },
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 5));

      expect(find.text('Hider'), findsOneWidget);
      // the show is not start
      expect(find.text('Spotlight Target'), findsNothing);

      Navigator.of(ctx).push(MaterialPageRoute(
        builder: (context) {
          return Scaffold(
            body: TextButton(
              child: const Text('POP'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          );
        },
      ));
      await tester.pumpAndSettle();

      expect(find.text('POP'), findsOneWidget);

      // try starting the show
      hider.currentState?.show();
      await tester.pumpAndSettle();
      expect(find.text('WaLa'), findsNothing);

      // pop back
      await tester.tap(find.text('POP'));
      await tester.pumpAndSettle();

      VisibilityDetectorController.instance.notifyNow();
      await tester.pump(const Duration(milliseconds: 5));
      await tester.pump(const Duration(milliseconds: 5));

      // the show start
      expect(find.text('WaLa'), findsOneWidget);

      // avoid pending timer
      // detailed in https://github.com/google/flutter.widgets/tree/master/packages/visibility_detector#widget-tests
      await tester.pumpWidget(const Placeholder());
      VisibilityDetectorController.instance.notifyNow();
    });
  });
}

class Hider extends StatefulWidget {
  const Hider({super.key});

  @override
  State<Hider> createState() => _HiderState();
}

class _HiderState extends State<Hider> {
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text('Hider'),
      if (isShow)
        const SpotlightAnt(
          duration: SpotlightDurationConfig.zero,
          content: Text('WaLa'),
          monitorId: 'hider',
          child: Text('Spotlight Target'),
        ),
    ]);
  }

  void show() {
    setState(() {
      isShow = true;
    });
  }
}
