import 'package:flutter/material.dart';

import 'my_spotlight.dart';

class DelayScreen extends StatefulWidget {
  const DelayScreen({Key? key}) : super(key: key);

  @override
  State<DelayScreen> createState() => _DelayScreenState();
}

class _DelayScreenState extends State<DelayScreen> {
  String waitFor = 'show';

  @override
  Widget build(BuildContext context) {
    final Widget child = waitFor == 'show'
        ? _Timer(
            text: waitFor,
            onDone: () {
              setState(() {
                waitFor = 'disappear';
              });
            },
          )
        : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const MySpotlight(child: Text('Hello SpotlightAnt')),
            const SizedBox(height: 16),
            _Timer(
              text: waitFor,
              onDone: () {
                setState(() {
                  waitFor = 'show';
                });
              },
            )
          ]);

    return MyScaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Text('Delay Example'),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.home_outlined),
          )
        ],
      ),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.headlineMedium!,
        child: Center(child: child),
      ),
    );
  }
}

class _Timer extends StatefulWidget {
  final int timer = 3;

  final String text;

  final VoidCallback onDone;

  const _Timer({
    Key? key,
    required this.text,
    required this.onDone,
  }) : super(key: key);

  @override
  State<_Timer> createState() => _TimerState();
}

class _TimerState extends State<_Timer> {
  late int timer;
  late Future future;

  @override
  Widget build(BuildContext context) {
    return Text('$timer seconds later will ${widget.text}');
  }

  @override
  void initState() {
    super.initState();
    timer = widget.timer;
    minusOne();
  }

  @override
  void dispose() {
    future.ignore();
    super.dispose();
  }

  void minusOne() {
    future = Future.delayed(const Duration(seconds: 1)).then((value) {
      setState(() {
        if (mounted) {
          timer--;
          if (timer != 0) {
            minusOne();
          } else {
            widget.onDone();
          }
        }
      });
    });
  }
}
