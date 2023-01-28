import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spotlight_ant/src/spotlights/spotlight_builder.dart';
import 'package:spotlight_ant/src/ant_position.dart';

class SpotlightRectBuilder extends SpotlightBuilder {
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

  const SpotlightRectBuilder({
    this.color = const Color(0xCD000000),
    this.radius = 0,
    this.borderSide = const BorderSide(),
  });

  @override
  SpotlightPainter build(AntPosition target, double value, bool isBumping) {
    return _RectPainter(
      value: value,
      target: target,
      color: color,
      radius: radius,
      borderSide: borderSide,
      isBumping: isBumping,
    );
  }

  @override
  double inkwellRadius(AntPosition target) => radius;
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
    required bool isBumping,
  }) : super(target, value, isBumping);

  @override
  void paint(Canvas canvas, Size size) {
    if (target.isNotFound) return;

    final rect = isBumping
        ? Rect.fromCenter(
            center: target.center,
            width: target.widthPad * (1 + value),
            height: target.heightPad * (1 + value),
          )
        : Rect.fromCenter(
            center: target.center,

            /// Two times larger for corner object
            /// without timing 2 will be like:
            /// ┌──┬───┐
            /// │  │  x│
            /// │  │   │
            /// │  └───┤
            /// │      │
            /// └──────┘
            width: size.width * (1 - value) * 2 + target.widthPad,
            height: size.height * (1 - value) * 2 + target.heightPad,
          );

    canvas.drawPath(
      _drawRRect(size, rect, radius),
      Paint()
        ..style = PaintingStyle.fill
        ..color = color
        ..strokeWidth = 4,
    );

    if (borderSide.style != BorderStyle.none) {
      canvas.drawPath(
        _drawRBorder(rect, radius),
        Paint()
          ..style = PaintingStyle.stroke
          ..color = borderSide.color
          ..strokeWidth = borderSide.width,
      );
    }
  }
}

Path _drawRRect(Size size, Rect rect, double radius) {
  return Path()
    ..moveTo(0, 0)
    ..lineTo(0, rect.top + radius)
    ..rRect(rect, radius)
    ..lineTo(0, rect.top + radius)
    ..lineTo(0, size.height)
    ..lineTo(size.width, size.height)
    ..lineTo(size.width, 0)
    ..close();
}

Path _drawRBorder(Rect rect, double radius) {
  return Path()
    ..moveTo(rect.left, rect.top + radius)
    ..rRect(rect, radius)
    ..close();
}

extension _Rect on Path {
  void rRect(Rect rect, double radius) {
    final d = radius * 2;
    arcTo(
      Rect.fromLTWH(rect.left, rect.top, d, d),
      pi,
      pi / 2,
      false,
    );
    arcTo(
      Rect.fromLTWH(rect.right - d, rect.top, d, d),
      3 * pi / 2,
      pi / 2,
      false,
    );
    arcTo(
      Rect.fromLTWH(rect.right - d, rect.bottom - d, d, d),
      0,
      pi / 2,
      false,
    );
    arcTo(
      Rect.fromLTWH(rect.left, rect.bottom - d, d, d),
      pi / 2,
      pi / 2,
      false,
    );
    lineTo(rect.left, rect.top + radius);
  }
}
