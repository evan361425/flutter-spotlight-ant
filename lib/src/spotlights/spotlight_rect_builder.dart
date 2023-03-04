import 'package:flutter/material.dart';
import 'package:spotlight_ant/src/spotlights/spotlight_builder.dart';

class SpotlightRectBuilder extends SpotlightBuilder {
  /// Color of the rectangle
  ///
  /// default using black with 0.8 opacity(0xCD000000)
  final Color color;

  /// Radius of the border
  ///
  /// disable by passing it 0
  final double borderRadius;

  /// Border setting
  ///
  /// default using [BorderSide]'s default settings
  final BorderSide borderSide;

  const SpotlightRectBuilder({
    this.color = const Color(0xCD000000),
    this.borderRadius = 0,
    this.borderSide = const BorderSide(),
  });

  @override
  SpotlightPainter build(Rect target, double value, bool isBumping) {
    return _RectPainter(
      value: value,
      target: target,
      color: color,
      borderRadius: borderRadius,
      borderSide: borderSide,
      isBumping: isBumping,
    );
  }

  @override
  double inkwellRadius(Rect target) => borderRadius;
}

class _RectPainter extends SpotlightPainter {
  final Color color;
  final double borderRadius;
  final BorderSide borderSide;

  const _RectPainter({
    required Rect target,
    required double value,
    required this.color,
    required this.borderRadius,
    required this.borderSide,
    required bool isBumping,
  }) : super(target, value, isBumping);

  @override
  void paint(Canvas canvas, Size size) {
    if (target.isEmpty) return;

    final rect = isBumping
        ? Rect.fromCenter(
            center: target.center,
            width: target.width + target.shortestSide * value,
            height: target.height + target.shortestSide * value,
          )
        : Rect.fromCenter(
            center: target.center,
            // Two times larger for corner object
            // without timing 2 will be like:
            // ┌──┬───┐
            // │  │  x│
            // │  │   │
            // │  └───┤
            // │      │
            // └──────┘
            width: size.longestSide * (1 - value) * 2 + target.width,
            height: size.longestSide * (1 - value) * 2 + target.height,
          );
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    canvas.drawPath(
      Path()
        ..addRRect(rRect)
        ..moveTo(0, 0)
        // ..lineTo(0, rect.top)
        // ..lineTo(rect.left, rect.top)
        // ..moveTo(rect.left, rect.top)
        // ..lineTo(0, rect.top)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, 0)
        // ..lineTo(0, 0)
        ..close(),
      Paint()
        ..style = PaintingStyle.fill
        ..color = color,
    );

    if (borderSide.style != BorderStyle.none) {
      canvas.drawPath(
        Path()..addRRect(rRect),
        borderSide.toPaint(),
      );
    }
  }
}
