import 'package:flutter/material.dart';

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

  const AlignmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text('Alignment Example'),
        actions: const [BackButton()],
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
  const _AlignTarget({required this.a});

  final Alignment a;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: a,
      child: Spotlight(
        content: Material(
          color: Colors.indigo,
          child: Center(
            child: Text(
              'Content of ${a.toString().substring(10)}\n',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        child: Text(a.toString().substring(10)),
      ),
    );
  }
}
