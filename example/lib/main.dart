import 'package:flutter/material.dart';
import 'package:spotlight_ant/spotlight_ant.dart';

void main() {
  final observer = RouteObserver<ModalRoute<void>>();

  runApp(MaterialApp(
    navigatorObservers: [observer],
    theme: ThemeData(),
    home: StartPage(observer: observer),
  ));
}

class StartPage extends StatelessWidget {
  final RouteObserver<ModalRoute<void>> observer;
  final ant1 = GlobalKey<SpotlightAntState>();
  final ant2 = GlobalKey<SpotlightAntState>();
  final ant3 = GlobalKey<SpotlightAntState>();

  StartPage({Key? key, required this.observer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(children: [
          SpotlightAnt(
            key: ant1,
            ants: [ant1, ant2, ant3],
            content: const SpotlightContent(
              children: [
                Text('Title', style: TextStyle(fontSize: 32)),
                Text('This is content\nwith new line!'),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            bumpDuration: Duration.zero,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              padding: const EdgeInsets.all(8.0),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              child: const Text('Circular'),
            ),
          ),
          const SizedBox(height: 16),
          SpotlightAnt(
            key: ant2,
            spotlightPadding: const EdgeInsets.all(4),
            zoomOutDuration: const Duration(milliseconds: 100),
            spotlightBuilder: const RectPainterBuilder(),
            bumpDuration: const Duration(milliseconds: 300),
            content: const SpotlightContent(
              children: [
                ColorBox(96),
                ColorBox(128),
                ColorBox(256),
                ColorBox(512),
                Divider(),
              ],
            ),
            child: const ListTile(
              tileColor: Colors.amber,
              title: Text('tile 2'),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SpotlightAnt(
              key: ant3,
              content: SpotlightContent(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Gesture Detector Content'),
                  ),
                ],
              ),
              contentAlignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Gesture Detector Child'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ant1.currentState?.show();
            },
            child: const Text('Restart'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const FourTypeAlignment(),
              ));
            },
            child: const Text('NEXT'),
          ),
        ]),
      ),
    );
  }
}

class ColorBox extends StatelessWidget {
  final double size;

  const ColorBox(this.size, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const DecoratedBox(
        decoration: BoxDecoration(color: Colors.red),
      ),
    );
  }
}

class FourTypeAlignment extends StatelessWidget {
  final alignments = const [
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
  ];

  const FourTypeAlignment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keys = [for (final _ in alignments) GlobalKey<SpotlightAntState>()];
    int i = 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Text('pop'),
        ),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Stack(children: [
            for (final a in alignments)
              Align(
                alignment: a,
                child: SpotlightAnt(
                  key: keys[i++],
                  ants: i == 1 ? keys : null,
                  content: const ColorBox(double.infinity),
                  child: Text(a.toString()),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
