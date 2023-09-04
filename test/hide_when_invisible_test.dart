// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:spotlight_ant/spotlight_ant.dart';

void main() {
//   group('Invisible Check', () {
//     testWidgets('hide and show after visible', (tester) async {
//       late BuildContext ctx;
//       await tester.pumpWidget(MaterialApp(
//         home: Scaffold(
//           body: SpotlightShow(
//             child: Builder(
//               builder: (context) {
//                 ctx = context;
//                 return const Center(
//                   child: SpotlightAnt(
//                     duration: SpotlightDurationConfig.zero,
//                     content: SpotlightContent(child: Text('WaLa')),
//                     child: Text('Spotlight Target'),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//       ));
//       await tester.pumpAndSettle();
//       await tester.pump(const Duration(milliseconds: 5));

//       // the show is started
//       expect(find.text('Spotlight Target'), findsOneWidget);
//       expect(find.text('WaLa'), findsOneWidget);

//       Navigator.of(ctx).push(MaterialPageRoute(
//         builder: (context) {
//           return Scaffold(
//             body: TextButton(
//               child: const Text('POP'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           );
//         },
//       ));
//       await tester.pump(const Duration(milliseconds: 10));
//       await tester.pump(const Duration(milliseconds: 10));

//       // the show being paused
//       expect(find.text('WaLa'), findsNothing);

//       // pop back
//       await tester.tap(find.text('POP'));
//       await tester.pump(const Duration(milliseconds: 10));
//       await tester.pump(const Duration(milliseconds: 10));

//       // the show start again!
//       expect(find.text('WaLa'), findsOneWidget);
//     });

//     testWidgets('not show if invisible', (tester) async {
//       final hider = GlobalKey<_HiderState>();
//       late BuildContext ctx;
//       await tester.pumpWidget(MaterialApp(
//         home: Scaffold(
//           body: SpotlightShow(
//             child: Builder(
//               builder: (context) {
//                 ctx = context;
//                 return Hider(key: hider);
//               },
//             ),
//           ),
//         ),
//       ));
//       await tester.pumpAndSettle();
//       await tester.pump(const Duration(milliseconds: 5));

//       // the show is not start
//       expect(find.text('Spotlight Target'), findsNothing);

//       Navigator.of(ctx).push(MaterialPageRoute(
//         builder: (context) {
//           return Scaffold(
//             body: TextButton(
//               child: const Text('POP'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           );
//         },
//       ));
//       await tester.pump(const Duration(milliseconds: 10));
//       await tester.pump(const Duration(milliseconds: 10));

//       expect(find.text('POP'), findsOneWidget);

//       // try starting the show
//       hider.currentState?.show();
//       await tester.pump(const Duration(milliseconds: 10));
//       await tester.pump(const Duration(milliseconds: 10));
//       expect(find.text('WaLa'), findsNothing);

//       // pop back
//       await tester.tap(find.text('POP'));
//       await tester.pump(const Duration(milliseconds: 10));
//       await tester.pump(const Duration(milliseconds: 10));

//       // the show start
//       expect(find.text('WaLa'), findsOneWidget);
//     });
//   });
// }

// class Hider extends StatefulWidget {
//   const Hider({Key? key}) : super(key: key);

//   @override
//   State<Hider> createState() => _HiderState();
// }

// class _HiderState extends State<Hider> {
//   bool isShow = false;

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       const Text('Hider'),
//       if (isShow)
//         const SpotlightAnt(
//           duration: SpotlightDurationConfig.zero,
//           content: Text('WaLa'),
//           child: Text('Spotlight Target'),
//         ),
//     ]);
//   }

//   void show() {
//     setState(() {
//       isShow = true;
//     });
//   }
}
