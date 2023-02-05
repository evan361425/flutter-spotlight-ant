import 'package:flutter/material.dart';

class SpotlightContent extends StatelessWidget {
  /// The child contained by the [DefaultTextStyle] and [Padding].
  final Widget child;

  /// Text color in [DefaultTextStyle].
  final Color textColor;

  /// Padding of the content.
  ///
  /// Inset of bottom should be larger to avoid overlap with actions.
  final EdgeInsets padding;

  const SpotlightContent({
    Key? key,
    required this.child,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.fromLTRB(8, 8, 8, 64),
  }) : super(key: key); // coverage:ignore-line

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DefaultTextStyle(
        style: TextStyle(color: textColor),
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
