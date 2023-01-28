import 'package:flutter/material.dart';

/// Abstract class to build [SpotlightPainter]
abstract class SpotlightBuilder {
  const SpotlightBuilder();

  /// Build the desired painter by [target] and [value].
  ///
  /// [value] is current [Animation]'s value from gaffer and
  /// it should between 0 and 1.
  ///
  /// 1 means size of target, 0 means window size.
  SpotlightPainter build(Rect target, double value, bool isBumping);

  /// The [InkWell]'s [Rect] inside the spotlight.
  Rect inkWellRect(Rect target) => target;

  /// The [InkWell]'s radius inside the spotlight.
  double inkwellRadius(Rect target);
}

/// Abstract class to paint the desired spotlight's shape
///
/// The canvas size should be the whole window.
abstract class SpotlightPainter extends CustomPainter {
  /// Target of the spotlight
  final Rect target;

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
