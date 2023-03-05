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
      radius: inkwellRadius(target),
      borderSide: borderSide,
      isBumping: isBumping,
    );
  }

  @override
  Rect targetRect(Rect target) => Rect.fromCircle(
        center: target.center,
        radius: inkwellRadius(target),
      );

  @override
  // `if null` precedence is higher than `math operators`
  double inkwellRadius(Rect target) => radius ?? target.size.longestSide / 2;
}

class _CircularPainter extends SpotlightPainter {
  final Color color;
  final double radius;
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

    final r = isBumping ? radius * (1 + value) : radius + size.longestSide * (1 - value);
    final rect = Rect.fromCircle(center: target.center, radius: r);

    canvas.drawPath(
      Path()
        ..addArc(rect, pi, 2 * pi)
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, 0)
        ..close(),
      Paint()
        ..style = PaintingStyle.fill
        ..color = color,
    );

    if (borderSide.style != BorderStyle.none) {
      canvas.drawPath(Path()..addArc(rect, 0, 2 * pi), borderSide.toPaint());
    }
  }
}
