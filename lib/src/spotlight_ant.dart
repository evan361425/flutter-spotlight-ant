import 'package:flutter/material.dart';
import 'package:spotlight_ant/src/spotlights/circular_painter.dart';
import 'package:spotlight_ant/src/spotlights/rect_painter.dart';
import 'package:spotlight_ant/src/spotlights/spotlight_painter.dart';
import 'package:spotlight_ant/src/ant_position.dart';
import 'package:spotlight_ant/src/spotlight_content.dart';
import 'package:spotlight_ant/src/spotlight_gaffer.dart';

class SpotlightAnt extends StatefulWidget {
  /// Content beside the spotlight.
  ///
  /// See also:
  ///
  ///  * [SpotlightContent], which provide a nice wrapper for you (and me).
  final Widget content;

  /// Tell the [SpotlightGaffer] which need to show.
  ///
  /// You should only make one [SpotlightAnt] with this value.
  ///
  /// We call this ant gaffer which means it is controlling the spotlight.
  /// When you see the document: *This property is only for gaffer*,
  /// it means the property is only useful for the gaffer.
  final Iterable<GlobalKey<SpotlightAntState>>? ants;

  /// Set to false will ignore this spotlight
  final bool enableSpotlight;

  /// Set to false will not build backdrop.
  ///
  /// Backdrop is use to close the spotlight when tapping anywhere.
  final bool enableBackDrop;

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

  /// Duration before showing.
  ///
  /// *This property is only for gaffer*
  final Duration showDelayDuration;

  /// Building painter for spotlight.
  ///
  /// default is using [CircularPainterBuilder],
  /// using [RectPainterBuilder] fro rectangle.
  ///
  /// See also:
  ///
  ///  * [SpotlightBuilder], which provide an interface for custom painter.
  final SpotlightBuilder spotlightBuilder;

  /// Padding of spotlight.
  final EdgeInsets spotlightPadding;

  /// Spotlight splash color.
  ///
  /// Setting null to use default color (control by the app theme).
  final Color? spotlightSplashColor;

  /// Backdrop splash color.
  ///
  /// Setting null to use default color (control by the app theme).
  ///
  /// Only useful when [enableBackDrop] is true.
  final Color? backdropSplashColor;

  /// Duration for zoom in the spotlight (start).
  final Duration zoomInDuration;

  /// Duration for zoom out the spotlight (finish).
  final Duration zoomOutDuration;

  /// Duration for bump forward and reverse duration.
  ///
  /// One cycle of bumping will cost [bumpDuration] * 2 time.
  final Duration bumpDuration;

  /// Alignment of content.
  ///
  /// Setting null will auto-detected by the center position.
  final Alignment? contentAlignment;

  /// Duration of fading in the content after zoom-in.
  final Duration contentFadeInDuration;

  /// Callback before zoom-in.
  final VoidCallback? onShow;

  /// Callback after zoom-in.
  final VoidCallback? onShown;

  /// Callback before zoom-out.
  final VoidCallback? onDismiss;

  /// Callback after zoom-out.
  final VoidCallback? onDismissed;

  /// The child contained by the [SpotlightAnt].
  final Widget child;

  const SpotlightAnt({
    required GlobalKey<SpotlightAntState> key,
    this.ants,
    this.enableSpotlight = true,
    this.enableBackDrop = true,
    this.spotlightBuilder = const CircularPainterBuilder(),
    this.spotlightPadding = const EdgeInsets.all(8),
    this.spotlightSplashColor,
    this.backdropSplashColor,
    this.showDelayDuration = Duration.zero,
    this.showAfterInit = true,
    this.zoomInDuration = const Duration(milliseconds: 600),
    this.zoomOutDuration = const Duration(milliseconds: 600),
    this.bumpDuration = const Duration(milliseconds: 500),
    this.contentAlignment,
    this.contentFadeInDuration = const Duration(milliseconds: 300),
    this.onShown,
    this.onShow,
    this.onDismiss,
    this.onDismissed,
    required this.content,
    required this.child,
  }) : super(key: key);

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
    }

    if (widget.showAfterInit) {
      show();
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  /// Is this ant the gaffer?
  bool get isAbleToShow => widget.ants?.isNotEmpty == true;

  /// Is this ant not the gaffer?
  bool get isNotAbleToShow => !isAbleToShow;

  /// What the position of this ant.
  AntPosition get position {
    final renderBox = context.findRenderObject();
    final box = renderBox is RenderBox ? renderBox : null;
    final state = context.findAncestorStateOfType<NavigatorState>();
    final offset = box?.localToGlobal(Offset.zero,
        ancestor: state?.context.findRenderObject());
    return AntPosition(
      offset ?? Offset.zero,
      box?.size ?? Size.zero,
      widget.spotlightPadding,
    );
  }

  /// Show the spotlight(s).
  ///
  /// *This method is only for gaffer*
  void show() async {
    if (isNotAbleToShow) {
      return;
    }

    await Future.delayed(widget.showDelayDuration);

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
            },
          );
        });
        Overlay.of(context)?.insert(_overlayEntry!);
      }
    });
  }

  /// Finish the show.
  ///
  /// *This method is only for gaffer*
  void finish() => gaffer.currentState?.finish();

  /// Go to next spotlight properly.
  ///
  /// *This method is only for gaffer*
  void next() => gaffer.currentState?.next();

  /// Go to previous spotlight properly.
  ///
  /// *This method is only for gaffer*
  void prev() => gaffer.currentState?.prev();
}
