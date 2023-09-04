import 'package:flutter/material.dart';
import 'package:spotlight_ant/src/spotlight_ant.dart';

class SpotlightActionConfig {
  /// Ordering actions by [SpotlightAntAction].
  ///
  /// send empty list for disabling default actions.
  final List<SpotlightAntAction> enabled;

  /// Build the actions wrapper.
  ///
  /// Default using:
  /// ```dart
  /// Positioned(
  ///   bottom: 16,
  ///   left: 16,
  ///   right: 16,
  ///   child: Row(
  ///     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  ///     children: actions.toList(),
  ///   ),
  /// );
  /// ```
  final Widget Function(BuildContext context, Iterable<Widget> actions)? builder;

  /// Pressed the action widget will go to next spotlight.
  ///
  /// Default using:
  /// ```dart
  /// IconButton(
  ///   onPressed: () => prev(),
  ///   tooltip: 'Next spotlight',
  ///   color: Colors.white,
  ///   icon: const Icon(Icons.arrow_forward_ios_sharp),
  /// );
  /// ```
  final Widget? next;

  /// Pressed the action widget will go to previous spotlight.
  ///
  /// Default using:
  /// ```dart
  /// IconButton(
  ///   onPressed: () => prev(),
  ///   tooltip: 'Previous spotlight',
  ///   color: Colors.white,
  ///   icon: const Icon(Icons.arrow_back_ios_sharp),
  /// );
  /// ```
  final Widget? prev;

  /// Pressed the action widget will skip all spotlights.
  ///
  /// Default using:
  /// ```dart
  /// IconButton(
  ///   onPressed: () => skip(),
  ///   tooltip: 'Skip spotlight show',
  ///   color: Colors.white,
  ///   icon: const Icon(Icons.close_sharp),
  /// );
  /// ```
  final Widget? skip;

  const SpotlightActionConfig({
    this.enabled = const [SpotlightAntAction.skip],
    this.builder,
    this.next,
    this.prev,
    this.skip,
  });
}
