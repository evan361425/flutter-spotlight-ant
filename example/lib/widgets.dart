import 'package:flutter/material.dart';

class ScrollRow extends StatelessWidget {
  final List<Widget> children;

  const ScrollRow({Key? key, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}
