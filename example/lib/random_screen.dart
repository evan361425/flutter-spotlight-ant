import 'package:flutter/material.dart';

import 'my_spotlight.dart';

class RandomScreen extends StatelessWidget {
  const RandomScreen({super.key});

  static const alignments = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomLeft,
    Alignment.bottomRight,
  ];

  @override
  Widget build(BuildContext context) {
    final orders = <int>[0, 1, 2, 3];
    orders.shuffle();
    return MyScaffold(
      appBar: AppBar(
        title: const Text('Random Example'),
        actions: const [BackButton()],
      ),
      body: Stack(children: [
        for (int i = 0; i < 4; i++)
          Align(
            alignment: alignments[i],
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Spotlight(
                index: orders[i],
                content: Material(
                  color: Colors.indigo,
                  child: Center(
                    child: Text(
                      orders[i].toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                ),
                child: SizedBox.square(
                  dimension: 24,
                  child: Center(child: Text(orders[i].toString())),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
