import 'dart:math';

import 'package:flutter/material.dart';

class AntPosition {
  final Offset offset;
  final Size size;
  final EdgeInsets padding;

  const AntPosition(this.offset, this.size, this.padding);

  bool get isNotFound => offset == Offset.zero;

  double get left => offset.dx;
  double get top => offset.dy;
  double get width => size.width;
  double get height => size.height;

  double get leftPad => max(left - padding.left, 0);
  double get topPad => max(top - padding.top, 0);

  double get widthPad => width + padding.horizontal;
  double get heightPad => height + padding.vertical;

  double get longestPad =>
      width > height ? padding.horizontal : padding.vertical;

  Offset get center => size.center(offset);

  Alignment getAlignmentIn(Size size) {
    final c = center;

    // < 0 means ant is in left side, else right side
    final xRatio = (c.dx / size.width) - 0.5;
    // < 0 means ant is in top side, else bottom side
    final yRatio = (c.dy / size.height) - 0.5;

    // using horizontal
    if (xRatio.abs() > yRatio.abs()) {
      return xRatio < 0 ? Alignment.centerRight : Alignment.centerLeft;
    } else {
      return yRatio < 0 ? Alignment.bottomCenter : Alignment.topCenter;
    }
  }

  @override
  String toString() {
    return 'AntPosition.LTWH(${left.toStringAsFixed(1)}, ${top.toStringAsFixed(1)}, ${width.toStringAsFixed(1)}, ${height.toStringAsFixed(1)})';
  }
}
