import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spotlight_ant/src/spotlights/spotlight_painter.dart';
import 'package:spotlight_ant/src/ant_position.dart';

class RectPainterBuilder extends SpotlightBuilder {
  /// Color of the rectangle
  ///
  /// default using black with 0.8 opacity(0xCD000000)
  final Color color;

  /// Radius of the border
  ///
  /// disable by passing it 0
  final double radius;

  /// Border setting
  ///
  /// default using [BorderSide]'s default settings
  final BorderSide borderSide;

  const RectPainterBuilder({
    this.color = const Color(0xCD000000),
    this.radius = 0,
    this.borderSide = const BorderSide(),
  });

  @override
  SpotlightPainter build(AntPosition target, double value) {
    return _RectPainter(
      value: value,
      target: target,
      color: color,
      radius: radius,
      borderSide: borderSide,
    );
  }

  @override
  double inkWellRadius(AntPosition target) => radius;
}

class _RectPainter extends SpotlightPainter {
  final Color color;
  final double radius;
  final BorderSide borderSide;

  const _RectPainter({
    required AntPosition target,
    required double value,
    required this.color,
    required this.radius,
    required this.borderSide,
  }) : super(target, value);

  @override
  void paint(Canvas canvas, Size size) {
    if (target.isNotFound) return;

    final side = (size.longestSide + target.size.longestSide) * (1 - value);

    final x = target.leftPad - side / 2;
    final y = target.topPad - side / 2;
    final w = target.widthPad + side;
    final h = target.heightPad + side;

    canvas.drawPath(
      _drawRRect(size, x, y, w, h, radius),
      Paint()
        ..style = PaintingStyle.fill
        ..color = color
        ..strokeWidth = 4,
    );

    if (borderSide.style != BorderStyle.none) {
      canvas.drawPath(
        _drawRBorder(x, y, w, h, radius),
        Paint()
          ..style = PaintingStyle.stroke
          ..color = borderSide.color
          ..strokeWidth = borderSide.width,
      );
    }
  }
}

Path _drawRRect(
  Size size,
  double x,
  double y,
  double w,
  double h,
  double radius,
) {
  return Path()
    ..moveTo(0, 0)
    ..lineTo(0, y + radius)
    ..rRect(x, y, w, h, radius)
    ..lineTo(0, y + radius)
    ..lineTo(0, size.height)
    ..lineTo(size.width, size.height)
    ..lineTo(size.width, 0)
    ..close();
}

Path _drawRBorder(double x, double y, double w, double h, double radius) {
  return Path()
    ..moveTo(x, y + radius)
    ..rRect(x, y, w, h, radius)
    ..close();
}

extension _Rect on Path {
  void rRect(double x, double y, double w, double h, double radius) {
    double diameter = radius * 2;
    arcTo(
      Rect.fromLTWH(x, y, diameter, diameter),
      pi,
      pi / 2,
      false,
    );
    arcTo(
      Rect.fromLTWH(x + w - diameter, y, diameter, diameter),
      3 * pi / 2,
      pi / 2,
      false,
    );
    arcTo(
      Rect.fromLTWH(x + w - diameter, y + h - diameter, diameter, diameter),
      0,
      pi / 2,
      false,
    );
    arcTo(
      Rect.fromLTWH(x, y + h - diameter, diameter, diameter),
      pi / 2,
      pi / 2,
      false,
    );
    lineTo(x, y + radius);
  }
}
