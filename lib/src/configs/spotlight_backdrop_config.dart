import 'package:flutter/material.dart';

class SpotlightBackdropConfig {
  /// Set to false will not build backdrop.
  ///
  /// Backdrop is use to close the spotlight when tapping anywhere.
  final bool silent;

  /// Using [InkWell] or [GestureDetector] on backdrop.
  final bool usingInkwell;

  /// Backdrop inkwell splash color.
  ///
  /// Setting null to use default color (control by the app theme).
  ///
  /// Only useful when [silent] is false.
  final Color? splashColor;

  const SpotlightBackdropConfig({
    this.silent = false,
    this.usingInkwell = true,
    this.splashColor,
  });
}
