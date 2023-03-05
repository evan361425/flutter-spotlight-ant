import 'package:flutter/material.dart';

/// Abstract class to build [SpotlightPainter]
abstract class SpotlightBuilder {
  const SpotlightBuilder();

  /// Build the desired painter by [target] and [value].
  ///
  /// [value] is current [Animation]'s value from gaffer.
  ///
  /// If is bumping, `0` means no bumping at all,
  /// `1` means bump as large as the origin width and height.
  ///
  /// If is zoom in or out, it should between 0 and 1.
  /// `1` means finish the zoom in animation or just start to zoom out,
  /// `0` means just start to zoom in or finish the zoom out animation.
  SpotlightPainter build(Rect target, double value, bool isBumping);

  /// The [Rect] inside the spotlight.
  Rect targetRect(Rect target) => target;

  /// The [InkWell]'s radius of the target.
  ///
  /// It will using [targetRect] to build [InkWell] bounds,
  /// but you can customize it border radius.
  double inkwellRadius(Rect target) => 0;
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
