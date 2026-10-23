import 'package:flutter/material.dart';
import 'package:spotlight_ant/spotlight_ant.dart';
import 'package:spotlight_ant/src/spotlight_ant.dart';

class SpotlightActionConfig {
  /// Ordering actions by [SpotlightAntAction].
  ///
  /// send empty list for disabling default actions.
  final List<SpotlightAntAction> enabled;

  /// When enabled, action buttons can be placed freely across the screen.
  ///
  /// Users of this feature need to keep their application layout in mind when
  /// specifying the positions. The actions are placed in a `Stack`,
  /// therefore [prev], [next] and [skip] need to return a widget wrapped in a
  /// [Positioned] widget.
  final bool freeStyleLayout;

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
  ///   onPressed: () => next(),
  ///   tooltip: 'Next spotlight',
  ///   color: Colors.white,
  ///   icon: const Icon(Icons.arrow_forward_ios_sharp),
  /// );
  /// ```
  final Widget Function(VoidCallback callback)? next;

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
  final Widget Function(VoidCallback callback)? prev;

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
  final Widget Function(VoidCallback callback)? skip;

  /// Pressed the action widget will finish the spotlight show.
  ///
  /// Default using:
  /// ```dart
  /// IconButton(
  ///   onPressed: () => finish(),
  ///   tooltip: 'Finish spotlight show',
  ///   color: Colors.white,
  ///   icon: const Icon(Icons.check_sharp),
  /// );
  /// ```
  final Widget Function(VoidCallback callback)? finish;

  const SpotlightActionConfig({
    this.enabled = const [SpotlightAntAction.skip],
    this.freeStyleLayout = false,
    this.builder,
    this.next,
    this.prev,
    this.skip,
    this.finish,
  });
}
