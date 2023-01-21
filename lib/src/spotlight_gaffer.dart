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
  bool shouldBumping = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: antMounted
          ? InkWell(
              onTap: current.widget.enableBackDrop ? _startZoomOut : null,
              splashColor: current.widget.backdropSplashColor,
              child: Stack(children: <Widget>[
                AnimatedBuilder(
                  animation: _zoomController,
                  builder: (context, child) {
                    return AnimatedBuilder(
                      animation: _bumpController,
                      builder: _buildSpotlight,
                    );
                  },
                ),
                _buildContent(),
              ]),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildSpotlight(BuildContext context, Widget? child) {
    final builder = current.widget.spotlightBuilder;
    final value = shouldBumping ? _bumpAnimation.value : _zoomAnimation.value;
    final p = current.position;
    final painter = builder.build(p, value);
    final rect = builder.inkWellRect(p);
    final radius = builder.inkWellRadius(p);

    return Stack(children: <Widget>[
      SizedBox(
        width: double.maxFinite,
        height: double.maxFinite,
        child: CustomPaint(painter: painter),
      ),
      Positioned(
        left: rect.left,
        top: rect.top,
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          splashColor: current.widget.spotlightSplashColor,
          onTap: _startZoomOut,
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
          child: current.widget.content,
        ),
      ),
    );
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
    _bumpAnimation = Tween(begin: 1.0, end: 0.99).animate(CurvedAnimation(
      parent: _bumpController,
      curve: Curves.ease,
    ));
    _contentAnimation = Tween(begin: 0.0, end: 1.0).animate(_contentController);

    Future.delayed(Duration.zero, next);
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
    if (currentIndex < widget.ants.length - 1) {
      _startZoomIn(++currentIndex);
    } else {
      finish();
    }
  }

  /// Go to previous spotlight properly.
  void prev() {
    if (currentIndex > widget.ants.length - 1) {
      _startZoomIn(--currentIndex);
    } else {
      finish();
    }
  }

  /// Finish the show.
  void finish() {
    widget.onFinish();
  }

  void _startZoomIn(int index) {
    currentAnt = widget.ants[index];
    if (!antMounted || !current.widget.enableSpotlight) {
      Future.delayed(Duration.zero, next);
      return;
    }

    setState(() {
      final ant = current.widget;
      _zoomController.duration = ant.zoomInDuration;
      _zoomController.reverseDuration = ant.zoomOutDuration;
      _contentController.duration = ant.contentFadeInDuration;

      // Reset things
      shouldBumping = false;
      _zoomController.reset();
      _bumpController.reset();
      _contentController.reset();

      current.widget.onShow?.call();

      // Start animate
      _zoomController.forward().then((value) {
        if (antMounted) {
          shouldBumping = true;
          current.widget.onShown?.call();

          _contentController.forward();
          if (current.widget.bumpDuration != Duration.zero) {
            _bumpController.repeat(
              reverse: true,
              period: current.widget.bumpDuration,
            );
          }
        } else {
          next();
        }
      });
    });
  }

  void _startZoomOut() {
    if (shouldBumping) {
      shouldBumping = false;
      current.widget.onDismiss?.call();
      _bumpController.stop();
      _zoomController.reverse().then((value) {
        current.widget.onDismissed?.call();
        next();
      });
      _contentController.reverse(from: 0);
    }
  }
}
