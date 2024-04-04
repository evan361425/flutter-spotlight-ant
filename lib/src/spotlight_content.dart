import 'package:flutter/material.dart';

class SpotlightContent extends StatelessWidget {
  /// The child contained by the [DefaultTextStyle] and [Padding].
  final Widget child;

  /// Text color in [DefaultTextStyle].
  final Color textColor;

  /// Font size in [DefaultTextStyle].
  final double? fontSize;

  /// Padding of the content.
  ///
  /// Inset of bottom should be larger to avoid overlap with actions.
  final EdgeInsets padding;

  const SpotlightContent({
    super.key,
    required this.child,
    this.textColor = Colors.white,
    this.fontSize,
    // this.fontSize =
    this.padding = const EdgeInsets.fromLTRB(8, 8, 8, 64),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTextStyle(
        style: TextStyle(color: textColor, fontSize: fontSize),
        child: Padding(
          padding: padding,
          child: Center(
            child: SingleChildScrollView(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
