import 'package:flutter/material.dart';
import 'package:spotlight_ant/src/spotlight_ant.dart';

typedef AntCallback = void Function(SpotlightAntState ant);

class SpotlightGaffer extends StatefulWidget {
  /// Passed from [SpotlightAnt].
  final List<GlobalKey<SpotlightAntState>> ants;

  /// Callback after finish the show.
  final VoidCallback onFinish;

  const SpotlightGaffer({
    Key? key,
    required this.ants,
    required this.onFinish,
  })  : assert(ants.length > 0),
        super(key: key);

  @override
  State<SpotlightGaffer> createState() => SpotlightGafferState();
}

class SpotlightGafferState extends State<SpotlightGaffer>
    with TickerProviderStateMixin {
  // animation
  late final AnimationController _zoomController;
  late final AnimationController _bumpController;
  late final AnimationController _contentController;
  late Animation<double> _zoomAnimation;
  late Animation<double> _bumpAnimation;
  late Animation<double> _contentAnimation;

  /// Index of current ant.
  ///
  /// 0-index
  int currentIndex = -1;

  /// Access current ant by [GlobalKey].
  GlobalKey<SpotlightAntState>? currentAnt;

  /// Current ant is in bumping mode.
  bool isBumping = false;

  @override
  Widget build(BuildContext context) {
    if (!antMounted) {
      return const SizedBox.shrink();
    }

    final spotlight = Stack(children: <Widget>[
      AnimatedBuilder(
        animation: _zoomController,
        builder: (context, child) {
          return AnimatedBuilder(
            animation: _bumpController,
            builder: _buildSpotlight,
          );
        },
      ),
      if (current.widget.content != null) _buildContent(),
    ]);

    final onTap = current.widget.backdropSilent ? () {} : next;

    return Material(
      type: MaterialType.transparency,
      child: current.widget.backdropUsingInkwell
          ? InkWell(
              onTap: onTap,
              splashColor: current.widget.backdropSplashColor,
              child: spotlight,
            )
          : GestureDetector(
              onTap: onTap,
              child: spotlight,
            ),
    );
  }

  Widget _buildSpotlight(BuildContext context, Widget? child) {
    final builder = current.widget.spotlightBuilder;
    final value = isBumping ? _bumpAnimation.value : _zoomAnimation.value;
    final p = current.position;
    final painter = builder.build(p, value, isBumping);
    final rect = builder.inkWellRect(p);

    final onTap = current.widget.spotlightSilent ? () {} : next;

    return Stack(children: <Widget>[
      SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: CustomPaint(painter: painter),
      ),
      Positioned(
        left: rect.left,
        top: rect.top,
        child: current.widget.spotlightUsingInkwell
            ? InkWell(
                borderRadius: BorderRadius.circular(builder.inkwellRadius(p)),
                splashColor: current.widget.spotlightSplashColor,
                onTap: onTap,
                child: SizedBox(
                  width: rect.width,
                  height: rect.height,
                ),
              )
            : GestureDetector(
                onTap: onTap,
                child: SizedBox(
                  width: rect.width,
                  height: rect.height,
                ),
              ),
      )
    ]);
  }

  Widget _buildContent() {
    final w = MediaQuery.of(context).size;
    final p = current.position;
    final a = current.widget.contentAlignment ?? p.getAlignmentIn(w);

    final rect = current.widget.spotlightBuilder.inkWellRect(p);
    final rWidth = rect.width / 2 + w.width * 0.02; // 0.02 for bumping variant
    final rHeight = rect.height / 2 + w.height * 0.02;

    final c = p.center;
    final left = a.x > 0 ? c.dx + a.x * rWidth : null;
    final right = a.x < 0 ? w.width - c.dx - a.x * rWidth : null;
    final top = a.y > 0 ? c.dy + a.y * rHeight : null;
    final bottom = a.y < 0 ? w.height - c.dy - a.y * rHeight : null;

    final width = w.width - (left ?? 0) - (right ?? 0);
    final height = w.height - (top ?? 0) - (bottom ?? 0);

    return Positioned(
      left: left,
      right: right,
      bottom: bottom,
      top: top,
      child: SizedBox(
        width: width,
        height: height,
        child: FadeTransition(
          opacity: _contentAnimation,
          child: Stack(children: [
            SizedBox.expand(child: current.widget.content),
            (current.widget.actionBuilder ?? _buildActions).call(_getActions()),
          ]),
        ),
      ),
    );
  }

  Widget _buildActions(Iterable<Widget> actions) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actions.toList(),
      ),
    );
  }

  Iterable<Widget> _getActions() sync* {
    assert(() {
      return current.widget.actions.toSet().length ==
          current.widget.actions.length;
    }(), 'Spotlight actions must not repeated.');

    for (final action in current.widget.actions) {
      switch (action) {
        case SpotlightAntAction.prev:
          if (currentIndex > 0) {
            yield current.widget.prevAction ??
                TextButton.icon(
                  onPressed: () => prev(),
                  label: const Text('PREV'),
                  icon: const Icon(Icons.arrow_back_ios_sharp),
                );
          }
          break;
        case SpotlightAntAction.next:
          yield current.widget.nextAction ??
              TextButton.icon(
                onPressed: () => next(),
                label: const Text('NEXT'),
                icon: const Icon(Icons.arrow_forward_ios_sharp),
              );
          break;
        case SpotlightAntAction.skip:
          yield current.widget.skipAction ??
              TextButton(
                onPressed: () => skip(),
                child: const Text('SKIP'),
              );
          break;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _zoomController = AnimationController(vsync: this);
    _bumpController = AnimationController(vsync: this);
    _contentController = AnimationController(vsync: this);

    _zoomAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _zoomController,
      curve: Curves.ease,
    ));
    _contentAnimation = Tween(begin: 0.0, end: 1.0).animate(_contentController);

    Future.delayed(Duration.zero, _next);
  }

  @override
  void dispose() {
    _bumpController.dispose();
    _zoomController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Current [SpotlightAntState] from [currentAnt] without checking null-value.
  SpotlightAntState get current {
    return currentAnt!.currentState!;
  }

  /// Is the gaffer and current ant mounted or not.
  bool get antMounted {
    return mounted && currentAnt?.currentState?.mounted == true;
  }

  /// Go to next spotlight properly.
  void next() {
    _startZoomOut().then((value) => _next());
  }

  void _next() {
    if (currentIndex < widget.ants.length - 1) {
      _startZoomIn(++currentIndex);
    } else {
      finish();
    }
  }

  /// Go to previous spotlight properly.
  void prev() {
    _startZoomOut().then((value) => _prev());
  }

  void _prev() {
    if (currentIndex < widget.ants.length - 1) {
      _startZoomIn(--currentIndex);
    }
  }

  /// Finish the show.
  void finish() {
    widget.onFinish();
  }

  /// Skip the show.
  ///
  /// This will call the [finish] internal.
  void skip() {
    current.widget.onSkip?.call();
    finish();
  }

  void _startZoomIn(int index) async {
    currentAnt = widget.ants[index];
    if (!antMounted || !current.widget.enable) {
      Future.delayed(Duration.zero, _next);
      return;
    }

    setState(() {
      final ant = current.widget;
      _zoomController.duration = ant.zoomInDuration;
      _zoomController.reverseDuration = ant.zoomOutDuration;
      _contentController.duration = ant.contentFadeInDuration;
      _bumpAnimation = Tween(begin: 0.0, end: ant.bumpRatio).animate(
        CurvedAnimation(
          parent: _bumpController,
          curve: Curves.ease,
        ),
      );

      // Reset things
      isBumping = false;
      _zoomController.reset();
      _bumpController.reset();
      _contentController.reset();

      current.widget.onShow?.call();

      // Start animate
      _zoomController.forward().then((value) {
        isBumping = true;
        if (antMounted) {
          current.widget.onShown?.call();

          _contentController.forward();
          if (current.widget.bumpDuration != Duration.zero) {
            _bumpController.repeat(
              reverse: true,
              period: current.widget.bumpDuration,
            );
          }
        } else {
          _next();
        }
      });
    });
  }

  Future<void> _startZoomOut() {
    if (isBumping) {
      isBumping = false;
      current.widget.onDismiss?.call();
      _bumpController.stop();
      _contentController.reverse(from: 0);
      return _zoomController.reverse().then((value) {
        current.widget.onDismissed?.call();
      });
    }

    return Future.value();
  }
}
