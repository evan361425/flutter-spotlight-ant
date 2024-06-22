import 'dart:async';

import 'package:flutter/material.dart';

import '../spotlight_ant.dart';

class SpotlightBackdropConfig {
  /// Set to true will skip building the backdrop.
  ///
  /// Backdrop is use to close the spotlight when tapping anywhere.
  final bool silent;

  /// Define the action after the backdrop tapped.
  ///
  /// Return null to do nothing.
  ///
  /// Default using: [SpotlightAntAction.next]
  final FutureOr<SpotlightAntAction?> Function()? onTap;

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
    this.onTap,
  });
}
