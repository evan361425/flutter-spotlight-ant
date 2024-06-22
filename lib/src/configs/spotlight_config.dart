import 'dart:async';

import 'package:flutter/material.dart';

import '../spotlight_ant.dart';
import '../spotlights/spotlight_builder.dart';
import '../spotlights/spotlight_circular_builder.dart';
import '../spotlights/spotlight_rect_builder.dart';

class SpotlightConfig {
  /// Building painter for spotlight.
  ///
  /// Default is using [SpotlightCircularBuilder].
  /// You can use [SpotlightRectBuilder] for rectangle.
  ///
  /// See also:
  ///
  ///  * [SpotlightBuilder], which provide an interface for custom painter.
  final SpotlightBuilder builder;

  /// Padding of spotlight.
  final EdgeInsets padding;

  /// Disable listen `onTap` event on the spotlight to dismiss the tutorial.
  ///
  /// Setting true will make it unable to go next when tapping the spotlight.
  final bool silent;

  /// Define the action after the spotlight tapped.
  ///
  /// Return null to do nothing.
  ///
  /// Default using: [SpotlightAntAction.next]
  final FutureOr<SpotlightAntAction?> Function()? onTap;

  /// Using [InkWell] or [GestureDetector] on spotlight.
  final bool usingInkwell;

  /// Spotlight inkwell splash color.
  ///
  /// Setting null to use default color (control by the app theme).
  ///
  /// Only useful when [silent] is false.
  final Color? splashColor;

  const SpotlightConfig({
    this.builder = const SpotlightCircularBuilder(),
    this.padding = const EdgeInsets.all(8),
    this.silent = false,
    this.onTap,
    this.usingInkwell = true,
    this.splashColor,
  });
}
