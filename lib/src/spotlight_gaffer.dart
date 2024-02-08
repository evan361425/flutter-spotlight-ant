import 'package:flutter/material.dart';
import 'package:spotlight_ant/src/spotlight_ant.dart';

typedef AntCallback = void Function(SpotlightAntState ant);

class SpotlightGaffer extends StatefulWidget {
  /// Passed from [SpotlightAnt].
  final List<SpotlightAntState> ants;

  /// Start at which ant.
  final int startAt;

  /// Callback after finish the show.
  final VoidCallback onFinish;

  /// Callback after skip the show.
  final VoidCallback onSkip;

  /// Callback after any ant is [SpotlightAntState.paused].
  final void Function(int pausedAt) onPaused;

  const SpotlightGaffer({
    Key? key,
    required this.ants,
    required this.startAt,
    required this.onFinish,
    required this.onSkip,
    required this.onPaused,
  })  : assert(ants.length > 0),
        super(key: key);

  @override
  State<SpotlightGaffer> createState() => SpotlightGafferState();
}

class SpotlightGafferState extends State<SpotlightGaffer> with TickerProviderStateMixin {
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

  /// Access current ant.
  SpotlightAntState? currentAnt;

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
      if (currentAnt!.widget.content != null) _buildContent(),
    ]);

    final onTap = currentAnt!.widget.backdrop.silent ? () {} : next;

    return Material(
      type: MaterialType.transparency,
      child: currentAnt!.widget.backdrop.usingInkwell
          ? InkWell(
              onTap: onTap,
              splashColor: currentAnt!.widget.backdrop.splashColor,
              child: spotlight,
            )
          : GestureDetector(
              onTap: onTap,
              child: spotlight,
            ),
    );
  }

  Widget _buildSpotlight(BuildContext context, Widget? child) {
    Widget widget = const SizedBox.shrink();

    if (mounted && antMounted) {
      final builder = currentAnt!.widget.spotlight.builder;
      final value = isBumping ? _bumpAnimation.value : _zoomAnimation.value;
      final r = currentAnt!.rect;
      final painter = builder.build(r, value, isBumping);
      final rect = builder.targetRect(r);

      final onTap = currentAnt!.widget.spotlight.silent ? () {} : next;

      widget = Stack(children: <Widget>[
        SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: CustomPaint(painter: painter),
        ),
        Positioned(
          left: rect.left,
          top: rect.top,
          child: currentAnt!.widget.spotlight.usingInkwell
              ? InkWell(
                  borderRadius: BorderRadius.circular(builder.inkwellRadius(r)),
                  splashColor: currentAnt!.widget.spotlight.splashColor,
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

    return widget;
  }

  Widget _buildContent() {
    final p = currentAnt!.position;

    return Positioned(
      left: p[0],
      right: p[1],
      top: p[2],
      bottom: p[3],
      child: SizedBox(
        width: p[4],
        height: p[5],
        child: FadeTransition(
          opacity: _contentAnimation,
          child: Stack(children: [
            SizedBox.expand(child: currentAnt!.widget.content),
            (currentAnt!.widget.action.builder ?? _buildActions).call(context, _getActions()),
          ]),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, Iterable<Widget> actions) {
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
      return currentAnt!.widget.action.enabled.toSet().length == currentAnt!.widget.action.enabled.length;
    }(), 'Spotlight actions must not repeated.');

    for (final action in currentAnt!.widget.action.enabled) {
      switch (action) {
        case SpotlightAntAction.prev:
          yield currentAnt!.widget.action.prev?.call(prev) ??
              IconButton(
                onPressed: prev,
                tooltip: 'Previous spotlight',
                color: Colors.white,
                icon: const Icon(Icons.arrow_back_ios_sharp),
              );
          break;
        case SpotlightAntAction.next:
          yield currentAnt!.widget.action.next?.call(next) ??
              IconButton(
                onPressed: next,
                tooltip: 'Next spotlight',
                color: Colors.white,
                icon: const Icon(Icons.arrow_forward_ios_sharp),
              );
          break;
        case SpotlightAntAction.skip:
          yield currentAnt!.widget.action.skip?.call(skip) ??
              IconButton(
                onPressed: skip,
                tooltip: 'Skip spotlight show',
                color: Colors.white,
                icon: const Icon(Icons.close_sharp),
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

    // start at -1 to make different with 0 when ants is empty
    currentIndex = widget.startAt - 1;

    Future.delayed(Duration.zero, _next);
  }

  @override
  void dispose() {
    _bumpController.dispose();
    _zoomController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Is the gaffer and current ant mounted or not.
  bool get antMounted {
    return mounted && currentAnt?.mounted == true;
  }

  /// Go to next spotlight properly.
  void next() {
    if (currentIndex < widget.ants.length - 1) {
      _startZoomOut().then((success) {
        if (success) {
          _next();
        }
      });
    } else if (isBumping) {
      finish();
    }
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
    if (currentIndex > 0) {
      _startZoomOut().then((success) {
        if (success) {
          _startZoomIn(--currentIndex);
        }
      });
    }
  }

  /// Finish the show.
  ///
  /// This call the [SpotlightAnt.onFinish],
  /// but won't call the [SpotlightAnt.onSkip].
  void finish() {
    _startZoomOut().then((success) {
      widget.onFinish();
    });
  }

  /// Skip the show.
  ///
  /// This call the [SpotlightAnt.onSkip],
  /// but won't call the [SpotlightAnt.onFinish].
  void skip() {
    _startZoomOut().then((success) {
      widget.onSkip();
    });
  }

  void _startZoomIn(int index) async {
    currentAnt = widget.ants[index];
    if (!antMounted || !currentAnt!.widget.enable) {
      Future.delayed(Duration.zero, _next);
      return;
    }

    // abort this show if some actors are being paused
    if (currentAnt!.paused) {
      widget.onPaused(index);
      return;
    }

    setState(() {
      final ant = currentAnt!.widget;
      _zoomController.duration = ant.duration.zoomIn;
      _zoomController.reverseDuration = ant.duration.zoomOut;
      _contentController.duration = ant.duration.contentFadeIn;
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

      currentAnt!.widget.onShow?.call();

      // Start animation
      _zoomController.forward().then((value) {
        isBumping = true;
        if (antMounted) {
          currentAnt!.widget.onShown?.call();

          _contentController.forward();
          if (currentAnt!.widget.duration.bump != Duration.zero) {
            _bumpController.repeat(
              reverse: true,
              period: currentAnt!.widget.duration.bump,
            );
          }
        }
      });
    });
  }

  Future<bool> _startZoomOut() async {
    if (isBumping) {
      isBumping = false;
      currentAnt!.widget.onDismiss?.call();
      _bumpController.stop();
      _contentController.reverse(from: 0);
      return _zoomController.reverse().then((value) {
        currentAnt!.widget.onDismissed?.call();
        return true;
      });
    }
    return false;
  }
}
