import 'package:flutter/material.dart';

import 'my_spotlight.dart';

class DelayScreen extends StatefulWidget {
  const DelayScreen({super.key});

  @override
  State<DelayScreen> createState() => _DelayScreenState();
}

class _DelayScreenState extends State<DelayScreen> {
  String waitFor = 'show';
  bool pushed = false;

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
            const Spotlight(child: Text('Hello SpotlightAnt')),
            const SizedBox(height: 16),
            _Timer(
              text: waitFor,
              onDone: () {
                if (!pushed) {
                  setState(() {
                    waitFor = 'show';
                  });
                }
              },
            )
          ]);

    return MyScaffold(
      appBar: AppBar(
        title: const Text('Delay Example'),
        actions: const [BackButton()],
      ),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.headlineMedium!,
        child: Column(
          children: [
            Center(child: child),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                pushed = true;
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_outlined),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      body: const Center(
                        child: Text('The spotlight should not show upon this page!'),
                      ),
                    );
                  },
                ));
              },
              child: const Text('Push some new page upon this one'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Timer extends StatefulWidget {
  final int timer = 3;

  final String text;

  final VoidCallback onDone;

  const _Timer({
    required this.text,
    required this.onDone,
  });

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
