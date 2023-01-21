import 'package:flutter/material.dart';

class SpotlightContent extends StatelessWidget {
  /// The children contained by the [Column].
  final List<Widget> children;

  /// Text color in [DefaultTextStyle].
  final Color textColor;

  /// Padding of the content.
  final EdgeInsets padding;

  /// [Column]'s property.
  final MainAxisAlignment mainAxisAlignment;

  /// [Column]'s property.
  final MainAxisSize mainAxisSize;

  /// [Column]'s property.
  final CrossAxisAlignment crossAxisAlignment;

  /// [Column]'s property.
  final TextDirection? textDirection;

  /// [Column]'s property.
  final VerticalDirection verticalDirection;

  /// [Column]'s property.
  final TextBaseline? textBaseline;

  const SpotlightContent({
    Key? key,
    required this.children,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.all(8),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: textColor),
      child: Padding(
        padding: padding,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            textBaseline: textBaseline,
            children: children,
          ),
        ),
      ),
    );
  }
}
