import 'package:flutter/material.dart';
import 'spotlight_builder.dart';

class SpotlightBackDropBuilder extends SpotlightBuilder {
  /// Color of the backdrop.
  ///
  /// default using black with 0.8 opacity(0xCD000000)
  final Color color;

  const SpotlightBackDropBuilder({
    this.color = const Color(0xCD000000),
  });

  @override
  SpotlightPainter build(Rect target, double value, bool isBumping) {
    return _BackdropPainter(
      value: value,
      target: target,
      color: color,
      isBumping: isBumping,
    );
  }
}

class _BackdropPainter extends SpotlightPainter {
  final Color color;

  const _BackdropPainter({
    required Rect target,
    required double value,
    required this.color,
    required bool isBumping,
  }) : super(target, value, isBumping);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Paint()
        ..style = PaintingStyle.fill
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant SpotlightPainter oldDelegate) => false;
}
