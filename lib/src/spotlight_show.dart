import 'package:flutter/widgets.dart';
import 'package:spotlight_ant/spotlight_ant.dart';

class SpotlightShow extends StatefulWidget {
  /// The child contained by the [SpotlightShow].
  final Widget child;

  /// Callback after skip the show.
  ///
  /// Notice that after tapping skip button, [onFinish] will also be fired.
  /// This callback will be executed before [onDismiss] and [onDismissed].
  final VoidCallback? onSkip;

  /// Callback after finish the show.
  ///
  /// The scenarios that will finish the show:
  ///   * Go next spotlight in the last (available) spotlight.
  ///   * Skip the show.
  final VoidCallback? onFinish;

  /// Immediate start the show after ready ant registered.
  ///
  /// This is useful if you are using special page view (e.g. [TabBarView]):
  ///
  /// ```dart
  /// TabBarView(
  ///   controller: _controller,
  ///   children: [
  ///     Container(),
  ///     SpotlightAnt(
  ///       key: _ant,
  ///       content: Text(''),
  ///       ants: [_ant],
  ///       child: Container(),
  ///     ),
  ///   ],
  /// );
  /// // ...
  /// final desiredIndex = 1;
  /// _controller.addListener(() {
  ///   if (!_controller.indexIsChanging) {
  ///     if (desiredIndex == _controller.index) {
  ///       _ant.show();
  ///     }
  ///   }
  /// });
  /// ```
  final bool startWhenReady;

  /// Wait until the [Future] has done and start the spotlight show.
  ///
  /// Default using:
  /// ```dart
  /// Future.delayed(Duration.zero)
  /// ```
  final Future? showWaitFuture;

  const SpotlightShow({
    Key? key,
    this.startWhenReady = true,
    this.showWaitFuture,
    this.onSkip,
    this.onFinish,
    required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SpotlightShowState();

  static SpotlightShowState? maybeOf(BuildContext context) {
    final _ShowScope? scope = context.dependOnInheritedWidgetOfExactType<_ShowScope>();
    return scope?._showState;
  }

  static SpotlightShowState of(BuildContext context) {
    final SpotlightShowState? gafferState = maybeOf(context);
    assert(() {
      if (gafferState == null) {
        throw FlutterError(
          'SpotlightShow.of() was called with a context '
          'that does not contain a SpotlightShow widget.\n'
          'No SpotlightShow widget ancestor could be found '
          'starting from the context that was passed to SpotlightShow.of(). '
          'This can happen because you are using a widget '
          'that looks for a SpotlightShow ancestor, but no such ancestor exists.\n'
          'The context used was:\n'
          '  $context',
        );
      }
      return true;
    }());
    return gafferState!;
  }
}

class SpotlightShowState extends State<SpotlightShow> {
  OverlayEntry? _overlayEntry;
  final _charSet = <SpotlightAntState>{};
  final _charQueue = <SpotlightAntState>[];

  /// Make you able to control the gaffer's behavior
  final gaffer = GlobalKey<SpotlightGafferState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        gaffer.currentState?.skip();
        return false;
      },
      child: _ShowScope(
        showState: this,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  bool get isReadyToStart {
    if (_charQueue.isNotEmpty) {
      final index = _charQueue.first.widget.index;
      return (index == null || index == 0) && isNotPerforming;
    }

    return false;
  }

  bool get isNotReadyToStart => !isReadyToStart;

  bool get isNotPerforming => _overlayEntry == null;

  void start() {
    if (_charQueue.isEmpty) return;

    WidgetsBinding.instance.scheduleFrameCallback((timeStamp) {
      if (isNotPerforming) {
        _overlayEntry = OverlayEntry(builder: (context) {
          return SpotlightGaffer(
              key: gaffer,
              ants: _charQueue,
              onFinish: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
                widget.onFinish?.call();
              },
              onSkip: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
                widget.onSkip?.call();
              });
        });
        Overlay.of(context).insert(_overlayEntry!);
      }
    });
  }

  /// Finish the show.
  void finish() => gaffer.currentState?.finish();

  /// Skip the show.
  ///
  /// This will call the [finish] internal.
  void skip() => gaffer.currentState?.skip();

  /// Go to next spotlight properly.
  void next() => gaffer.currentState?.next();

  /// Go to previous spotlight properly.
  void prev() => gaffer.currentState?.prev();

  void register(SpotlightAntState char) {
    final success = _charSet.add(char);

    if (success) {
      _queue(char);
    }
  }

  void unregister(SpotlightAntState char) {
    final success = _charSet.remove(char);

    if (success) {
      _dequeue(char);
    }
  }

  void _queue(SpotlightAntState char) {
    _charQueue.add(char);

    if (char.widget.index != null) {
      assert(() {
        return _charQueue.any((e) => e.widget.index != null);
      }());

      _charQueue.sort((a, b) => a.widget.index! - b.widget.index!);
    }

    if (isReadyToStart && widget.startWhenReady) {
      final future = widget.showWaitFuture ?? Future.delayed(Duration.zero);
      future.then((value) => start());
    }
  }

  void _dequeue(SpotlightAntState char) {
    _charQueue.removeWhere((e) => e == char);

    if (_charQueue.isEmpty) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }
}

class _ShowScope extends InheritedWidget {
  const _ShowScope({
    required super.child,
    required SpotlightShowState showState,
  }) : _showState = showState;

  final SpotlightShowState _showState;

  /// The [SpotlightShow] associated with this widget.
  SpotlightShow get show => _showState.widget;

  @override
  bool updateShouldNotify(_ShowScope old) => false;
}
