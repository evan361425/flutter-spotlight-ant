import 'dart:math';

import 'package:flutter/material.dart';
import 'spotlights/spotlight_circular_builder.dart';
import 'spotlights/spotlight_rect_builder.dart';
import 'spotlights/spotlight_builder.dart';
import 'spotlight_content.dart';
import 'spotlight_gaffer.dart';

class SpotlightAnt extends StatefulWidget {
  /// Tell the [SpotlightGaffer] which need to show.
  ///
  /// You should only make one [SpotlightAnt] with this value.
  ///
  /// We call this ant gaffer which means it is controlling the spotlight.
  /// When you see the document: *This property is only for gaffer*,
  /// it means the property is only useful for the gaffer.
  final Iterable<GlobalKey<SpotlightAntState>>? ants;

  /// Set to false will ignore this spotlight
  final bool enable;

  /// Immediate show this ant after fire `initState`.
  ///
  /// *This property is only for gaffer*
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
  final bool showAfterInit;

  /// Wait until the [Future] has done and start the spotlight show.
  ///
  /// *This property is only for gaffer*
  ///
  /// Default using:
  /// ```dart
  /// Future.delayed(Duration.zero)
  /// ```
  final Future? showWaitFuture;

  /// Building painter for spotlight.
  ///
  /// Default is using [SpotlightCircularBuilder].
  /// You can use [SpotlightRectBuilder] for rectangle.
  ///
  /// See also:
  ///
  ///  * [SpotlightBuilder], which provide an interface for custom painter.
  final SpotlightBuilder spotlightBuilder;

  /// Padding of spotlight.
  final EdgeInsets spotlightPadding;

  /// Listen `onTap` event on the spotlight to dismiss the tutorial.
  ///
  /// Setting true will make it unable to go next when tapping the spotlight.
  final bool spotlightSilent;

  /// Using [InkWell] or [GestureDetector] on spotlight.
  final bool spotlightUsingInkwell;

  /// Spotlight inkwell splash color.
  ///
  /// Setting null to use default color (control by the app theme).
  ///
  /// Only useful when [spotlightSilent] is false.
  final Color? spotlightSplashColor;

  /// Set to false will not build backdrop.
  ///
  /// Backdrop is use to close the spotlight when tapping anywhere.
  final bool backdropSilent;

  /// Using [InkWell] or [GestureDetector] on backdrop.
  final bool backdropUsingInkwell;

  /// Backdrop inkwell splash color.
  ///
  /// Setting null to use default color (control by the app theme).
  ///
  /// Only useful when [backdropSilent] is false.
  final Color? backdropSplashColor;

  /// Ordering actions by [SpotlightAntAction].
  ///
  /// send empty list for disabling default actions.
  final List<SpotlightAntAction> actions;

  /// Build the actions wrapper.
  ///
  /// Default using:
  /// ```dart
  /// Positioned(
  ///   bottom: 16,
  ///   left: 16,
  ///   right: 16,
  ///   child: Row(
  ///     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  ///     children: actions.toList(),
  ///   ),
  /// );
  /// ```
  final Widget Function(BuildContext context, Iterable<Widget> actions)?
      actionBuilder;

  /// Pressed the action widget will go to next spotlight.
  ///
  /// Default using:
  /// ```dart
  /// IconButton(
  ///   onPressed: () => prev(),
  ///   tooltip: 'Next spotlight',
  ///   color: Colors.white,
  ///   icon: const Icon(Icons.arrow_forward_ios_sharp),
  /// );
  /// ```
  final Widget? nextAction;

  /// Pressed the action widget will go to previous spotlight.
  ///
  /// Default using:
  /// ```dart
  /// IconButton(
  ///   onPressed: () => prev(),
  ///   tooltip: 'Previous spotlight',
  ///   color: Colors.white,
  ///   icon: const Icon(Icons.arrow_back_ios_sharp),
  /// );
  /// ```
  final Widget? prevAction;

  /// Pressed the action widget will skip all spotlights.
  ///
  /// Default using:
  /// ```dart
  /// IconButton(
  ///   onPressed: () => skip(),
  ///   tooltip: 'Skip spotlight show',
  ///   color: Colors.white,
  ///   icon: const Icon(Icons.close_sharp),
  /// );
  /// ```
  final Widget? skipAction;

  /// Duration for zoom in the spotlight (start).
  final Duration zoomInDuration;

  /// Duration for zoom out the spotlight (finish).
  final Duration zoomOutDuration;

  /// Duration for bump forward and reverse duration.
  ///
  /// One cycle of bumping will cost [bumpDuration] * 2 time.
  final Duration bumpDuration;

  /// Bumping ratio, higher value will have larger bumping area.
  final double bumpRatio;

  /// Alignment of content.
  ///
  /// Setting null will auto-detected by the center position.
  final Alignment? contentAlignment;

  /// Prefer content shown in vertical side.
  ///
  /// If both [preferHorizontal] and [preferVertical] set to false,
  /// it will choose the largest ratio compare to window.
  ///
  /// For example, target is at `(0.7 * window_width, 0.4 * window_height)`
  /// it will align to [Alignment.centerLeft], since
  /// `|0.7 - 0.5| > |0.4 - 0.5|`
  ///
  /// If [preferVertical] set to true, it will choose
  /// [Alignment.topCenter] or [Alignment.bottomCenter]
  ///
  /// If both [preferHorizontal] and [preferVertical] set to true,
  /// [preferHorizontal] will take the procedure.
  final bool preferVertical;

  /// Prefer content shown in horizontal side.
  ///
  /// If both [preferHorizontal] and [preferVertical] set to false,
  /// it will choose the largest ratio compare to window.
  ///
  /// For example, target is at `(0.7 * window_width, 0.4 * window_height)`
  /// it will align to [Alignment.centerLeft], since
  /// `|0.7 - 0.5| > |0.4 - 0.5|`
  ///
  /// If [preferHorizontal] set to true, it will choose
  /// [Alignment.centerLeft] or [Alignment.centerRight]
  ///
  /// If both [preferHorizontal] and [preferVertical] set to true,
  /// [preferHorizontal] will take the procedure.
  ///
  /// The reason horizontal has higher procedure is make user easy to setup
  /// [preferHorizontal], since the default is [preferVertical].
  final bool preferHorizontal;

  /// Duration of fading in the content after zoom-in.
  final Duration contentFadeInDuration;

  /// Content beside the spotlight.
  ///
  /// See also:
  ///
  ///  * [SpotlightContent], which provide a nice wrapper for you (and me).
  final Widget? content;

  /// Callback before zoom-in.
  final VoidCallback? onShow;

  /// Callback after zoom-in.
  final VoidCallback? onShown;

  /// Callback before zoom-out.
  final VoidCallback? onDismiss;

  /// Callback after zoom-out.
  final VoidCallback? onDismissed;

  /// Callback after skip the show.
  ///
  /// *This property is only for gaffer*
  ///
  /// Notice that after tapping skip button, [onFinish] will also be fired.
  /// This callback will be executed before [onDismiss] and [onDismissed].
  final VoidCallback? onSkip;

  /// Callback after finish the show.
  ///
  /// *This property is only for gaffer*
  ///
  /// The scenarios that will finish the show:
  ///   * Go next spotlight in the last (available) spotlight.
  ///   * Skip the show.
  final VoidCallback? onFinish;

  /// The child contained by the [SpotlightAnt].
  final Widget child;

  const SpotlightAnt({
    required GlobalKey<SpotlightAntState> key,
    this.ants,
    this.enable = true,
    this.spotlightBuilder = const SpotlightCircularBuilder(),
    this.spotlightPadding = const EdgeInsets.all(8),
    this.spotlightSilent = false,
    this.spotlightUsingInkwell = true,
    this.spotlightSplashColor,
    this.backdropSilent = false,
    this.backdropUsingInkwell = true,
    this.backdropSplashColor,
    this.actions = const [SpotlightAntAction.skip],
    this.actionBuilder,
    this.nextAction,
    this.prevAction,
    this.skipAction,
    this.showAfterInit = true,
    this.showWaitFuture,
    this.zoomInDuration = const Duration(milliseconds: 600),
    this.zoomOutDuration = const Duration(milliseconds: 600),
    this.bumpDuration = const Duration(milliseconds: 500),
    this.bumpRatio = 0.1,
    this.contentAlignment,
    this.preferVertical = true,
    this.preferHorizontal = false,
    this.contentFadeInDuration = const Duration(milliseconds: 200),
    this.content,
    this.onShown,
    this.onShow,
    this.onDismiss,
    this.onDismissed,
    this.onSkip,
    this.onFinish,
    required this.child,
  })  : assert(
            ants != null ||
                (onSkip == null && onFinish == null && showWaitFuture == null),
            'Only gaffer can set properties: `onSkip`, `onFinish`, `showWaitFuture`'),
        super(key: key);

  @override
  State<StatefulWidget> createState() => SpotlightAntState();
}

class SpotlightAntState extends State<SpotlightAnt> {
  OverlayEntry? _overlayEntry;

  /// Make you able to control the gaffer's behavior
  ///
  /// *This property is only for gaffer*
  late GlobalKey<SpotlightGafferState> gaffer;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void initState() {
    super.initState();

    if (isAbleToShow) {
      gaffer = GlobalKey<SpotlightGafferState>();
      if (widget.showAfterInit) {
        (widget.showWaitFuture ?? Future.delayed(Duration.zero))
            .then((value) => show());
      }
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  /// Is this ant the gaffer?
  bool get isAbleToShow => widget.ants?.isNotEmpty == true;

  /// Is it in the show?
  bool get isShowing => _overlayEntry != null;

  /// Is this ant not the gaffer?
  bool get isNotAbleToShow => !isAbleToShow;

  /// What the position of this ant.
  Rect get rect {
    final renderBox = context.findRenderObject();
    final box = renderBox is RenderBox ? renderBox : null;
    final state = context.findAncestorStateOfType<NavigatorState>();
    final offset = box?.localToGlobal(
          Offset.zero,
          ancestor: state?.context.findRenderObject(),
        ) ??
        Offset.zero;
    final size = box?.size ?? Size.zero;

    return Rect.fromLTRB(
      offset.dx - widget.spotlightPadding.left,
      offset.dy - widget.spotlightPadding.top,
      offset.dx + size.width + widget.spotlightPadding.right,
      offset.dy + size.height + widget.spotlightPadding.bottom,
    );
  }

  /// Get current position for [Positioned]
  ///
  /// Have six values:
  /// * left (nullable)
  /// * right (nullable)
  /// * top (nullable)
  /// * bottom (nullable)
  /// * width
  /// * height
  List<double?> get position {
    final w = MediaQuery.of(context).size;
    final r = this.rect;
    final c = r.center;

    final a = widget.contentAlignment ?? getAlignment(w, c);

    final rect = widget.spotlightBuilder.inkWellRect(r);
    final rWidth = rect.width * (0.5 + widget.bumpRatio / 2);
    final rHeight = rect.height * (0.5 + widget.bumpRatio / 2);

    final left = a.x > 0 ? max(c.dx + a.x * rWidth, 0.0) : null;
    final right = a.x < 0 ? max(w.width - c.dx - a.x * rWidth, 0.0) : null;
    final top = a.y > 0 ? max(c.dy + a.y * rHeight, 0.0) : null;
    final bottom = a.y < 0 ? max(w.height - c.dy - a.y * rHeight, 0.0) : null;

    final width = max(w.width - (left ?? 0) - (right ?? 0), 0.0);
    final height = max(w.height - (top ?? 0) - (bottom ?? 0), 0.0);

    return [left, right, top, bottom, width, height];
  }

  /// Show the spotlight(s).
  ///
  /// *This method is only for gaffer*
  void show() {
    if (isNotAbleToShow) {
      return;
    }

    WidgetsBinding.instance.scheduleFrameCallback((timeStamp) {
      if (_overlayEntry == null) {
        _overlayEntry = OverlayEntry(builder: (context) {
          final targets = widget.ants!.toList();
          return SpotlightGaffer(
              key: gaffer,
              ants: targets,
              onFinish: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
                widget.onFinish?.call();
              },
              onSkip: () {
                widget.onSkip?.call();
              });
        });
        Overlay.of(context).insert(_overlayEntry!);
      }
    });
  }

  /// Finish the show.
  ///
  /// *This method is only for gaffer*
  void finish() => gaffer.currentState?.finish();

  /// Skip the show.
  ///
  /// *This method is only for gaffer*
  ///
  /// This will call the [finish] internal.
  void skip() => gaffer.currentState?.skip();

  /// Go to next spotlight properly.
  ///
  /// *This method is only for gaffer*
  void next() => gaffer.currentState?.next();

  /// Go to previous spotlight properly.
  ///
  /// *This method is only for gaffer*
  void prev() => gaffer.currentState?.prev();

  /// Get target alignment from [center] in specific [windowSize].
  Alignment getAlignment(Size windowSize, Offset center) {
    // < 0 means ant is in left side, else right side
    final xRatio = (center.dx / windowSize.width) - 0.5;
    // < 0 means ant is in top side, else bottom side
    final yRatio = (center.dy / windowSize.height) - 0.5;

    final useHorizontal = widget.preferHorizontal
        ? true
        : widget.preferVertical
            ? false
            : xRatio.abs() > yRatio.abs();

    if (useHorizontal) {
      return xRatio < 0 ? Alignment.centerRight : Alignment.centerLeft;
    } else {
      return yRatio <= 0 ? Alignment.bottomCenter : Alignment.topCenter;
    }
  }
}

enum SpotlightAntAction {
  prev,
  next,
  skip,
}
