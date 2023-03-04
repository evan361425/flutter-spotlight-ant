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
    return MyScaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Stack(children: [
          for (final a in alignments) _AlignTarget(a: a),
        ]),
      ),
    );
  }
}

class _AlignTarget extends StatelessWidget {
  const _AlignTarget({
    Key? key,
    required this.a,
  }) : super(key: key);

  final Alignment a;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: a,
      child: MySpotlight(
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
                    onPressed: () => SpotlightShow.of(context).finish(),
                    child: const Text('FINISH'),
                  )
                ],
              ),
            ),
          ),
        ),
        child: Text(a.toString().substring(10)),
      ),
    );
  }
}
