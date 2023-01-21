import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spotlight_ant/src/spotlights/spotlight_painter.dart';
import 'package:spotlight_ant/src/ant_position.dart';

class CircularPainterBuilder extends SpotlightBuilder {
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

  const CircularPainterBuilder({
    this.color = const Color(0xCD000000),
    this.radius,
    this.borderSide = const BorderSide(),
  });

  @override
  SpotlightPainter build(AntPosition target, double value) {
    return _CircularPainter(
      value: value,
      target: target,
      color: color,
      radius: radius,
      borderSide: borderSide,
    );
  }

  @override
  Rect inkWellRect(AntPosition target) => Rect.fromCircle(
        center: target.center,
        // if null precedence is higher than math operators
        radius: radius ?? (target.size.longestSide + target.longestPad) / 2,
      );

  @override
  double inkWellRadius(AntPosition target) =>
      radius ?? (target.size.longestSide + target.longestPad) / 2;
}

class _CircularPainter extends SpotlightPainter {
  final Color color;
  final double? radius;
  final BorderSide borderSide;

  const _CircularPainter({
    required AntPosition target,
    required double value,
    required this.color,
    required this.radius,
    required this.borderSide,
  }) : super(target, value);

  @override
  void paint(Canvas canvas, Size size) {
    if (target.isNotFound) return;

    final r = size.longestSide * (1 - value) +
        (radius ?? (target.size.longestSide + target.longestPad) / 2);
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
