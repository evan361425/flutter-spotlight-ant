import 'dart:math';

import 'package:flutter/material.dart';
import 'spotlight_builder.dart';

class SpotlightCircularBuilder extends SpotlightBuilder {
  /// Color of the circle
  ///
  /// default using black with 0.8 opacity(0xCD000000)
  final Color color;

  /// Radius of the circle
  ///
  /// default using target longest side
  final double? radius;

  /// Border setting
  ///
  /// default using [BorderSide]'s default settings
  final BorderSide borderSide;

  const SpotlightCircularBuilder({
    this.color = const Color(0xCD000000),
    this.radius,
    this.borderSide = const BorderSide(),
  });

  @override
  SpotlightPainter build(Rect target, double value, bool isBumping) {
    return _CircularPainter(
      value: value,
      target: target,
      color: color,
      radius: radius,
      borderSide: borderSide,
      isBumping: isBumping,
    );
  }

  @override
  Rect inkWellRect(Rect target) => Rect.fromCircle(
        center: target.center,
        // `if null` precedence is higher than `math operators`
        radius: radius ?? target.size.longestSide / 2,
      );

  @override
  double inkwellRadius(Rect target) => radius ?? target.size.longestSide / 2;
}

class _CircularPainter extends SpotlightPainter {
  final Color color;
  final double? radius;
  final BorderSide borderSide;

  const _CircularPainter({
    required Rect target,
    required double value,
    required this.color,
    required this.radius,
    required this.borderSide,
    required bool isBumping,
  }) : super(target, value, isBumping);

  @override
  void paint(Canvas canvas, Size size) {
    if (target.isEmpty) return;

    final a = radius ?? (target.size.longestSide / 2);
    final r = isBumping ? a * (1 + value) : a + size.longestSide * (1 - value);
    final c = target.center;

    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(0, c.dy)
        ..circle(c, r)
        ..lineTo(0, c.dy)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, 0)
        ..close(),
      Paint()
        ..style = PaintingStyle.fill
        ..color = color,
    );

    if (borderSide.style != BorderStyle.none) {
      canvas.drawPath(
          Path()
            ..moveTo(c.dx - r, c.dy)
            ..circle(c, r)
            ..close(),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = borderSide.color
            ..strokeWidth = borderSide.width);
    }
  }
}

extension _Circle on Path {
  /// Draw circle from [center] with [radius] size.
  circle(Offset center, double radius) {
    arcTo(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      pi,
      false,
    );
    arcTo(
      Rect.fromCircle(center: center, radius: radius),
      0,
      pi,
      false,
    );
  }
}
