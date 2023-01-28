import 'package:flutter/material.dart';
import 'package:spotlight_ant/src/ant_position.dart';

/// Abstract class to build [SpotlightPainter]
abstract class SpotlightBuilder {
  const SpotlightBuilder();

  /// Build the desired painter by [target] and [value].
  ///
  /// [value] is current [Animation]'s value from gaffer and
  /// it should between 0 and 1.
  ///
  /// 1 means size of target, 0 means window size.
  SpotlightPainter build(AntPosition target, double value, bool isBumping);

  /// The [InkWell]'s [Rect] inside the spotlight.
  Rect inkWellRect(AntPosition target) => Rect.fromLTWH(
        target.leftPad,
        target.topPad,
        target.widthPad,
        target.heightPad,
      );

  /// The [InkWell]'s radius inside the spotlight.
  double inkwellRadius(AntPosition target) => 0;
}

/// Abstract class to paint the desired spotlight's shape
///
/// The canvas size should be the whole window.
abstract class SpotlightPainter extends CustomPainter {
  /// Target for the spotlight
  final AntPosition target;

  /// Current [Animation]'s value from gaffer and
  /// it should between 0 and 1.
  ///
  /// 1 means size of target, 0 means window size.
  final double value;

  /// Painting bumping animation or zoom.
  final bool isBumping;

  const SpotlightPainter(this.target, this.value, this.isBumping);

  @override
  bool shouldRepaint(SpotlightPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
