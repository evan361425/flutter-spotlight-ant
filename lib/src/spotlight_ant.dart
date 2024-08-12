import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spotlight_ant/src/configs/spotlight_action_config.dart';
import 'package:spotlight_ant/src/configs/spotlight_backdrop_config.dart';
import 'package:spotlight_ant/src/configs/spotlight_config.dart';
import 'package:spotlight_ant/src/configs/spotlight_content_layout_config.dart';
import 'package:spotlight_ant/src/configs/spotlight_duration_config.dart';
import 'package:spotlight_ant/src/spotlight_show.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'spotlight_content.dart';

/// Basic widget that contains the spotlight information.
class SpotlightAnt extends StatefulWidget {
  /// Set to true will show debug information.
  static bool debug = false;

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

  /// Trace the position of the child.
  ///
  /// If your widget will be animated, set this to true to make sure the
  /// spotlight will follow the child.
  final bool traceChild;

  /// Order in the show.
  ///
  /// null index will be treated as the first.
  ///
  /// When [SpotlightShow.waitForZeroIndexOrNull] is true, the show will only
  /// start if we found the first ant with index 0 or null.
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
    super.key,
    this.enable = true,
    this.monitorId,
    this.spotlight = const SpotlightConfig(),
    this.backdrop = const SpotlightBackdropConfig(),
    this.action = const SpotlightActionConfig(),
    this.duration = const SpotlightDurationConfig(),
    this.contentLayout = const SpotlightContentLayoutConfig(),
    this.bumpRatio = 0.1,
    this.traceChild = false,
    this.index,
    this.content,
    this.onShown,
    this.onShow,
    this.onDismiss,
    this.onDismissed,
    required this.child,
  }) : assert(index == null || index >= 0);

  @override
  State<StatefulWidget> createState() => SpotlightAntState();
}

class SpotlightAntState extends State<SpotlightAnt> {
  /// If this ant required to be monitored ([SpotlightAnt.monitorId] has set),
  /// it might be paused to be shown.
  bool paused = false;

  Rect? _rect;

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

            // avoid edit visibility's callback collection in callback itself
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

  /// Widget position in rectangle.
  ///
  /// see: https://stackoverflow.com/a/71568630/12089368
  Rect? get rect {
    if (_rect == null || widget.traceChild) {
      final renderBox = context.findRenderObject();
      final matrix = renderBox?.getTransformTo(null);
      // getting global position of renderBox
      if (matrix != null && renderBox?.paintBounds != null) {
        final rect = MatrixUtils.transformRect(matrix, renderBox!.paintBounds);
        _rect = widget.spotlight.padding.inflateRect(rect);
      }
    }

    return _rect;
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
  List<double?>? get position {
    final r = this.rect;
    if (r == null) {
      return null;
    }

    final w = MediaQuery.of(context).size;
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
  finish;

  FutureOr<SpotlightAntAction?> meOr(FutureOr<SpotlightAntAction?> Function()? cb) async {
    return cb == null ? this : await cb();
  }
}
