import 'package:flutter/material.dart';
import 'package:spotlight_ant/spotlight_ant.dart';

import 'my_spotlight.dart';

class AlignmentScreen extends StatelessWidget {
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

  const AlignmentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ants = [for (final _ in alignments) GlobalKey<SpotlightAntState>()];
    final keys = [for (final _ in alignments) GlobalKey<MySpotlightState>()];
    int i = 0;

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Text('Alignment Example'),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.home_outlined),
          )
        ],
      ),
      drawer: const D(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          for (final k in keys) {
            k.currentState?.show();
          }
        },
        child: const Icon(Icons.refresh_sharp),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Stack(children: [
            for (final a in alignments)
              Align(
                alignment: a,
                child: MySpotlight(
                  key: keys[i],
                  ants: i == 0 ? ants : null,
                  ant: ants[i++],
                  content: Material(
                    color: Colors.indigo,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Content of ${a.toString().substring(10)}\n',
                              style: const TextStyle(fontSize: 32),
                            ),
                            ElevatedButton(
                              onPressed: () => ants[0].currentState?.finish(),
                              child: const Text('FINISH'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  child: Text(a.toString().substring(10)),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
