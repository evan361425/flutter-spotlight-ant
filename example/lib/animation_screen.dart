import 'package:flutter/material.dart';
import 'package:flutter_test_example/my_spotlight.dart';

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
        title: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: const Text('Animation Example'),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.home_outlined),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final Size biggest = constraints.biggest;
          return Stack(children: <Widget>[
            MySpotlight(
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
