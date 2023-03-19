import 'package:flutter/widgets.dart';
import 'spotlight_ant.dart';
import 'spotlight_gaffer.dart';

/// An container for grouping together multiple [SpotlightAnt] widgets.
///
/// Each individual [SpotlightAnt] should with the [SpotlightShow] widget as a
/// common ancestor of all of those. Call methods on [SpotlightShowState] to
/// show, skip, finish, go next or previous [SpotlightAnt] that is a descendant
/// of this [SpotlightShow]. To obtain the [SpotlightShowState], you may use
/// [SpotlightShow.of] with a context whose ancestor is the [SpotlightShow],
/// or pass a [GlobalKey] to the [SpotlightShow] constructor and call
/// [GlobalKey.currentState].
class SpotlightShow extends StatefulWidget {
  /// The widget below this widget in the tree.
  ///
  /// This is the root of the widget hierarchy that contains this show.
  final Widget child;

  /// Callback after skip the show.
  ///
  /// [onFinish] won't be fired if [onSkip] is fired.
  final VoidCallback? onSkip;

  /// Callback after finish the show.
  ///
  /// [onSkip] won't be fired if [onFinish] is fired.
  ///
  /// The scenarios that will finish the show:
  ///   * Go next spotlight in the last (available) spotlight.
  ///   * Programmatically execute [SpotlightShowState.finish].
  final VoidCallback? onFinish;

  /// Callback when user try to pop the navigation.
  ///
  /// Default using:
  ///
  /// ```dart
  /// if (state.isNotPerforming) {
  ///   return true;
  /// }
  /// state.gaffer.currentState?.skip();
  /// return false;
  /// ```
  final Future<bool> Function(SpotlightShowState state)? onWillPop;

  /// Immediate start the show after ready spotlight registered.
  ///
  /// This is useful if you are using special page view (e.g. [TabBarView]):
  ///
  /// ```dart
  /// TabBarView(
  ///   controller: _controller,
  ///   children: [
  ///     Container(),
  ///     SpotlightAnt(
  ///       content: Text(''),
  ///       child: Container(),
  ///     ),
  ///   ],
  /// );
  /// // ...
  /// final desiredIndex = 1;
  /// _controller.addListener(() {
  ///   if (!_controller.indexIsChanging) {
  ///     if (desiredIndex == _controller.index) {
  ///       SpotlightShow.of(context).start();
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

  /// True to make it able to start.
  final bool enable;

  const SpotlightShow({
    Key? key,
    this.startWhenReady = true,
    this.showWaitFuture,
    this.onSkip,
    this.onFinish,
    this.onWillPop,
    this.enable = true,
    required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => SpotlightShowState();

  /// Returns the [SpotlightShowState] of the closest [SpotlightShow] widget
  /// which encloses the given context, or null if none is found.
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// SpotlightShowState? show = SpotlightShow.maybeOf(context);
  /// show?.start();
  /// ```
  ///
  /// Calling this method will create a dependency on the closest
  /// [SpotlightShow] in the [context], if there is one.
  ///
  /// See also:
  ///
  /// * [SpotlightShow.of], which is similar to this method, but asserts if no
  ///   [SpotlightShow] ancestor is found.
  static SpotlightShowState? maybeOf(BuildContext context) {
    final _ShowScope? scope = context.dependOnInheritedWidgetOfExactType<_ShowScope>();
    return scope?._showState;
  }

  /// Returns the [SpotlightShowState] of the closest [SpotlightShow] widget
  /// which encloses the given [context].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// SpotlightShowState show = SpotlightShow.of(context);
  /// show.start();
  /// ```
  ///
  /// If no [SpotlightShow] ancestor is found, this will assert in debug mode,
  /// and throw an exception in release mode.
  ///
  /// Calling this method will create a dependency on the closest
  /// [SpotlightShow] in the [context].
  ///
  /// See also:
  ///
  /// * [SpotlightShow.maybeOf], which is similar to this method, but returns
  ///   null if no [SpotlightShow] ancestor is found.
  static SpotlightShowState of(BuildContext context) {
    final SpotlightShowState? gafferState = maybeOf(context);
    assert(
      gafferState != null,
      'SpotlightShow.of() was called with a context '
      'that does not contain a SpotlightShow widget.\n'
      'No SpotlightShow widget ancestor could be found '
      'starting from the context that was passed to SpotlightShow.of(). '
      'This can happen because you are using a widget '
      'that looks for a SpotlightShow ancestor, but no such ancestor exists.\n'
      'The context used was:\n'
      '  $context',
    );
    return gafferState!;
  }
}

class SpotlightShowState extends State<SpotlightShow> {
  OverlayEntry? _overlayEntry;
  final _antSet = <SpotlightAntState>{};
  final _antQueue = <SpotlightAntState>[];

  /// Let you able to control the gaffer's behavior
  final gaffer = GlobalKey<SpotlightGafferState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.onWillPop != null) {
          return widget.onWillPop!(this);
        }

        if (isNotPerforming) {
          return true;
        }

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

  /// Is this show ready to start?
  ///
  /// If this show is in perform, it will return false.
  ///
  /// See also:
  ///
  /// * [isNotReadyToStart], which will return the opposite result of this.
  /// * [isNotPerforming], whether this show is performing.
  bool get isReadyToStart {
    if (_antQueue.isNotEmpty) {
      final index = _antQueue.first.widget.index;
      return (index == null || index == 0) && isNotPerforming;
    }

    return false;
  }

  /// Is this show not ready to start?
  ///
  /// See also:
  ///
  /// * [isReadyToStart], which will return the opposite result of this.
  bool get isNotReadyToStart => !isReadyToStart;

  /// Whether this show is performing.
  bool get isNotPerforming => _overlayEntry == null;

  /// Start the show.
  ///
  /// It will start automatically if [SpotlightAnt] is registered.
  ///
  /// See also:
  ///
  /// * [SpotlightShow.startWhenReady], will disable automatic behavior.
  /// * [skip], will turn off the show, and call the [SpotlightShow.onSkip].
  /// * [finish], will turn off the show, and call the [SpotlightShow.onFinish].
  void start() {
    if (_antQueue.isEmpty || !widget.enable) return;

    WidgetsBinding.instance.scheduleFrameCallback((timeStamp) {
      if (isNotPerforming) {
        _overlayEntry = OverlayEntry(builder: (context) {
          return SpotlightGaffer(
              key: gaffer,
              ants: _antQueue,
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
  ///
  /// This will also be execute when go next in last spotlight.
  void finish() => gaffer.currentState?.finish();

  /// Skip the show.
  void skip() => gaffer.currentState?.skip();

  /// Go to next spotlight properly.
  void next() => gaffer.currentState?.next();

  /// Go to previous spotlight properly.
  void prev() => gaffer.currentState?.prev();

  /// Register [SpotlightAnt] programmatically.
  void register(SpotlightAntState ant) {
    final success = _antSet.add(ant);

    if (success) {
      _queue(ant);
    }
  }

  /// Unregister [SpotlightAnt] programmatically.
  ///
  /// If no more spotlights exist, it will finish show.
  void unregister(SpotlightAntState ant) {
    final success = _antSet.remove(ant);

    if (success) {
      _dequeue(ant);
    }
  }

  void _queue(SpotlightAntState ant) {
    _antQueue.add(ant);

    if (ant.widget.index != null) {
      assert(
        _antQueue.every((e) => e.widget.index != null),
        'Should make sure all SpotlightAnt under SpotlightShow have '
        'either all null or all indexed.',
      );

      _antQueue.sort((a, b) => a.widget.index! - b.widget.index!);
    }

    if (isReadyToStart && widget.startWhenReady) {
      final future = widget.showWaitFuture ?? Future.delayed(Duration.zero);
      future.then((value) => start());
    }
  }

  void _dequeue(SpotlightAntState ant) {
    _antQueue.removeWhere((e) => e == ant);

    if (_antQueue.isEmpty) {
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

  @override // coverage:ignore-line
  bool updateShouldNotify(_ShowScope old) => false;
}
