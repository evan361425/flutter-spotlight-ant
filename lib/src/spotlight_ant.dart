import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spotlight_ant/src/configs/spotlight_action_config.dart';
import 'package:spotlight_ant/src/configs/spotlight_backdrop_config.dart';
import 'package:spotlight_ant/src/configs/spotlight_content_layout_config.dart';
import 'package:spotlight_ant/src/configs/spotlight_duration_config.dart';
import 'package:spotlight_ant/src/configs/spotlight_config.dart';
import 'package:spotlight_ant/src/spotlight_show.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'spotlight_content.dart';

/// Basic widget that contains the spotlight information.
class SpotlightAnt extends StatefulWidget {
  /// Set to false will ignore this spotlight
  final bool enable;

  /// Set non-null value to monitor widget's visibility and stop monitor after
  /// it first 100% shown.
  ///
  /// Once it's shown, the spotlight show will continue to start and any
  /// previous shown and finished ant will be ignored.
  ///
  /// monitorId must be unique among all [VisibilityDetector] and
  /// [SliverVisibilityDetector] widgets to properly identify this widget.
  final String? monitorId;

  /// Config spotlight behavior.
  final SpotlightConfig spotlight;

  /// Config backdrop behavior.
  final SpotlightBackdropConfig backdrop;

  /// Config action below content.
  final SpotlightActionConfig action;

  /// Config the duration of any animations.
  final SpotlightDurationConfig duration;

  /// Config the layout of content.
  final SpotlightContentLayoutConfig contentLayout;

  /// Bumping ratio, higher value will have larger bumping area.
  final double bumpRatio;

  /// Order of the show.
  ///
  /// Make sure all of the [SpotlightAnt]s have not set the index, or all of the
  /// ants have set the index.
  ///
  /// Once you set the index, [SpotlightShow] will wait for the ant with index 0
  /// and start the show.
  final int? index;

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

  /// The child contained by the [SpotlightAnt].
  final Widget child;

  const SpotlightAnt({
    Key? key,
    this.enable = true,
    this.monitorId,
    this.spotlight = const SpotlightConfig(),
    this.backdrop = const SpotlightBackdropConfig(),
    this.action = const SpotlightActionConfig(),
    this.duration = const SpotlightDurationConfig(),
    this.contentLayout = const SpotlightContentLayoutConfig(),
    this.bumpRatio = 0.1,
    this.index,
    this.content,
    this.onShown,
    this.onShow,
    this.onDismiss,
    this.onDismissed,
    required this.child,
  })  : assert(index == null || index >= 0),
        super(key: key);

  @override
  State<StatefulWidget> createState() => SpotlightAntState();
}

class SpotlightAntState extends State<SpotlightAnt> {
  /// If this ant required to be monitored([SpotlightAnt.monitorId] has set),
  /// it might be paused to be shown.
  bool paused = false;

  @override
  Widget build(BuildContext context) {
    SpotlightShow.maybeOf(context)?.register(this);

    if (paused) {
      final key = Key(widget.monitorId!);
      return VisibilityDetector(
        key: key,
        onVisibilityChanged: (info) async {
          if (paused && info.visibleFraction == 1.0) {
            // no need to rebuild by setState since we are not changing UI.
            paused = false;
            SpotlightShow.maybeOf(context)?.start();

            // avoid edit callback collection in callback
            await Future.delayed(Duration.zero);
            VisibilityDetectorController.instance.forget(key);
          }
        },
        child: widget.child,
      );
    }

    return widget.child;
  }

  @override
  void deactivate() {
    SpotlightShow.maybeOf(context)?.unregister(this);
    super.deactivate();
  }

  @override
  void initState() {
    paused = widget.monitorId != null && widget.enable;
    super.initState();
  }

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
      offset.dx - widget.spotlight.padding.left,
      offset.dy - widget.spotlight.padding.top,
      offset.dx + size.width + widget.spotlight.padding.right,
      offset.dy + size.height + widget.spotlight.padding.bottom,
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

    final a = widget.contentLayout.alignment ?? getAlignment(w, c);

    final rect = widget.spotlight.builder.targetRect(r);
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

  /// Get target alignment from [center] in specific [windowSize].
  Alignment getAlignment(Size windowSize, Offset center) {
    // < 0 means ant is in left side, else right side
    final xRatio = (center.dx / windowSize.width) - 0.5;
    // < 0 means ant is in top side, else bottom side
    final yRatio = (center.dy / windowSize.height) - 0.5;

    if (widget.contentLayout.prefer.isPreferHorizontal(xRatio, yRatio)) {
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
