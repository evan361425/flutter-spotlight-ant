import 'package:flutter/material.dart';

import 'my_spotlight.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({Key? key}) : super(key: key);

  @override
  State<AnimationScreen> createState() => AnimationScreenState();
}

class AnimationScreenState extends State<AnimationScreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double smallLogo = 100;
    const double bigLogo = 200;

    return MyScaffold(
      appBar: AppBar(
        title: const Text('Animation Example'),
        actions: const [BackButton()],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size biggest = constraints.biggest;
          return Stack(children: <Widget>[
            Center(child: Text('Set `traceChild` to true', style: Theme.of(context).textTheme.labelMedium)),
            Spotlight(
              traceChild: true,
              child: PositionedTransition(
                rect: RelativeRectTween(
                  begin: RelativeRect.fromSize(
                    const Rect.fromLTWH(0, 0, smallLogo, smallLogo),
                    biggest,
                  ),
                  end: RelativeRect.fromSize(
                    Rect.fromLTWH(
                      biggest.width - bigLogo,
                      biggest.height - bigLogo,
                      bigLogo,
                      bigLogo,
                    ),
                    biggest,
                  ),
                ).animate(CurvedAnimation(
                  parent: _controller,
                  curve: Curves.elasticInOut,
                )),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: FlutterLogo(),
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
