import 'package:flutter/material.dart';

class SpotlightContentLayoutConfig {
  /// Alignment of content.
  ///
  /// Setting null will auto-detected by the center position.
  final Alignment? alignment;

  /// Prefer content shown in which side.
  final ContentPreferLayout prefer;

  const SpotlightContentLayoutConfig({
    this.alignment,
    this.prefer = ContentPreferLayout.vertical,
  });
}

enum ContentPreferLayout {
  /// it will choose [Alignment.topCenter] or [Alignment.bottomCenter]
  vertical,

  /// it will choose [Alignment.centerLeft] or [Alignment.centerRight]
  horizontal,

  /// it will choose the larger ratio compare to window's ratio
  ///
  /// For example, target is at `(0.7 * window_width, 0.4 * window_height)`
  /// it will align to [Alignment.centerLeft], since
  /// `|0.7 - 0.5| > |0.4 - 0.5|`
  largerRatio,
}

extension PreferLayoutExtension on ContentPreferLayout {
  bool isPreferHorizontal(double xRatio, double yRatio) {
    switch (this) {
      case ContentPreferLayout.horizontal:
        return true;
      case ContentPreferLayout.vertical:
        return false;
      case ContentPreferLayout.largerRatio:
        return xRatio.abs() > yRatio.abs();
    }
  }
}
