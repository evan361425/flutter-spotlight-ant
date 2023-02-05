import 'package:flutter/material.dart';
import 'package:spotlight_ant/spotlight_ant.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'widgets.dart';

class MySpotlight extends StatefulWidget {
  final GlobalKey<SpotlightAntState> ant;
  final List<GlobalKey<SpotlightAntState>>? ants;
  final Widget? content;
  final Widget child;
  final bool enable;
  final VoidCallback? onFinish;

  const MySpotlight({
    Key? key,
    required this.ant,
    this.ants,
    this.content,
    this.enable = true,
    this.onFinish,
    required this.child,
  }) : super(key: key);

  @override
  State<MySpotlight> createState() => MySpotlightState();
}

class MySpotlightState extends State<MySpotlight> {
  late bool useCircle;

  @override
  Widget build(BuildContext context) {
    return SpotlightAnt(
      key: widget.ant,
      ants: widget.ants,
      enable: widget.enable,
      spotlightPadding: EdgeInsets.all(D.padding),
      zoomInDuration: Duration(milliseconds: D.zoomIn.toInt()),
      zoomOutDuration: Duration(milliseconds: D.zoomOut.toInt()),
      bumpDuration: Duration(milliseconds: D.bump.toInt()),
      contentFadeInDuration: Duration(milliseconds: D.fadeIn.toInt()),
      bumpRatio: D.bumpRatio,
      backdropSilent: D.backdropSilent,
      backdropUsingInkwell: D.backdropInkwell,
      spotlightSilent: D.spotlightSilent,
      spotlightUsingInkwell: D.spotlightInkwell,
      spotlightBuilder: useCircle
          ? const SpotlightCircularBuilder()
          : const SpotlightRectBuilder(),
      contentAlignment: D.alignment,
      actions: D.actions,
      onShow: () => _print('onShow'),
      onShown: () => _print('onShown'),
      onDismiss: () => _print('onDismiss'),
      onDismissed: () => _print('onDismissed'),
      onSkip: widget.ants == null ? null : () => _print('onSkip'),
      onFinish: widget.ants == null
          ? null
          : () {
              widget.onFinish?.call();
              _print('onFinish');
            },
      content: widget.content,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    useCircle = D.useCircle;
  }

  void show() {
    setState(() {
      useCircle = D.useCircle;
      widget.ant.currentState?.show();
    });
  }

  void _print(String event) {
    if (D.listening) {
      Fluttertoast.showToast(
        webShowClose: true,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        msg:
            '$event(${widget.ant.hashCode}) - ${DateTime.now().toString().substring(12)}',
      );
    }
  }
}

class D extends StatefulWidget {
  static double zoomIn = 600;
  static double zoomOut = 600;
  static double bump = 500;
  static double fadeIn = 300;
  static double bumpRatio = 0.1;
  static double padding = 16.0;
  static bool listening = false;
  static bool spotlightSilent = false;
  static bool spotlightInkwell = true;
  static bool backdropSilent = false;
  static bool backdropInkwell = true;
  static Alignment? alignment;
  static List<SpotlightAntAction> actions = [
    SpotlightAntAction.prev,
    SpotlightAntAction.skip,
    SpotlightAntAction.next,
  ];
  static bool useCircle = true;

  const D({Key? key}) : super(key: key);

  @override
  State<D> createState() => _DState();
}

class _DState extends State<D> {
  late double zoomIn;
  late double zoomOut;
  late double bump;
  late double fadeIn;
  late double bumpRatio;
  late bool useCircle;
  late double padding;
  late bool listening;
  late bool spotlightSilent;
  late bool spotlightInkwell;
  late bool backdropSilent;
  late bool backdropInkwell;
  late Alignment? alignment;
  late List<SpotlightAntAction> actions;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
          const Center(
            child: Text(
              'Duration',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ScrollRow(children: [
            Text('Zoom In (${zoomIn.toStringAsFixed(0)})'),
            Slider(
              value: zoomIn,
              min: 50,
              max: 3000,
              onChanged: (value) => setState(() {
                D.zoomIn = zoomIn = value;
              }),
            ),
          ]),
          ScrollRow(children: [
            Text('Zoom Out (${zoomOut.toStringAsFixed(0)})'),
            Slider(
              value: zoomOut,
              min: 50,
              max: 3000,
              onChanged: (value) => setState(() {
                D.zoomOut = zoomOut = value;
              }),
            ),
          ]),
          ScrollRow(children: [
            Text('Bump (${bump.toStringAsFixed(0)})'),
            Slider(
              value: bump,
              min: 50,
              max: 3000,
              onChanged: (value) => setState(() {
                D.bump = bump = value;
              }),
            ),
          ]),
          ScrollRow(children: [
            Text('Content FadeIn (${fadeIn.toStringAsFixed(0)})'),
            Slider(
              value: fadeIn,
              min: 50,
              max: 3000,
              onChanged: (value) => setState(() {
                D.fadeIn = fadeIn = value;
              }),
            ),
          ]),
          const Divider(),
          const Center(
            child: Text(
              'Numeric Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ScrollRow(children: [
            Text('Bump Ratio (${bumpRatio.toStringAsFixed(1)})'),
            Slider(
              value: bumpRatio,
              min: 0.0,
              max: 3,
              onChanged: (value) => setState(() {
                D.bumpRatio = bumpRatio = value;
              }),
            ),
          ]),
          ScrollRow(children: [
            Text('Padding ${padding.toStringAsFixed(0)}'),
            Slider(
              value: padding,
              min: 0.0,
              max: 128,
              divisions: 128,
              onChanged: (value) => setState(() {
                D.padding = padding = value;
              }),
            ),
          ]),
          const Divider(),
          const Center(
            child: Text(
              'Spotlight Actions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
            child: Text(actions.map((e) => e.name).join(', ')),
          ),
          Wrap(spacing: 4, runSpacing: 4, children: [
            for (final v in SpotlightAntAction.values)
              ChoiceChip(
                label: Text(v.name),
                selected: actions.contains(v),
                onSelected: (value) => _selectAction(value, v),
              ),
          ]),
          const Divider(),
          const Center(
            child: Text(
              'True/False',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            value: listening,
            title: const Text('Listening events'),
            onChanged: (value) => setState(() {
              D.listening = listening = value;
            }),
          ),
          SwitchListTile(
            value: useCircle,
            title: const Text('Use circle'),
            onChanged: (value) => setState(() {
              D.useCircle = useCircle = value;
            }),
          ),
          SwitchListTile(
            value: spotlightInkwell,
            title: const Text('Spotlight inkwell'),
            onChanged: (value) => setState(() {
              D.spotlightInkwell = spotlightInkwell = value;
            }),
          ),
          SwitchListTile(
            value: backdropInkwell,
            title: const Text('Backdrop inkwell'),
            onChanged: (value) => setState(() {
              D.backdropInkwell = backdropInkwell = value;
            }),
          ),
          SwitchListTile(
            value: spotlightSilent,
            title: const Text('Disable spotlight tapping'),
            onChanged: (value) => setState(() {
              D.spotlightSilent = spotlightSilent = value;
            }),
          ),
          SwitchListTile(
            value: backdropSilent,
            title: const Text('Disable backdrop tapping'),
            onChanged: (value) => setState(() {
              D.backdropSilent = backdropSilent = value;
            }),
          ),
          const Divider(),
          const Center(
            child: Text(
              'Alignment',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Wrap(spacing: 4, runSpacing: 4, children: [
            ChoiceChip(
              label: const Text('Auto detect'),
              selected: alignment == null,
              onSelected: (value) => setState(() {
                D.alignment = alignment = null;
              }),
            ),
            for (final v in const [
              Alignment.topLeft,
              Alignment.topCenter,
              Alignment.topRight,
              Alignment.centerLeft,
              Alignment.center,
              Alignment.centerRight,
              Alignment.bottomLeft,
              Alignment.bottomCenter,
              Alignment.bottomRight,
            ])
              ChoiceChip(
                label: Text(v.toString().substring(10)),
                selected: v == alignment,
                onSelected: (value) => setState(() {
                  D.alignment = alignment = (value ? v : null);
                }),
              ),
          ]),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    zoomIn = D.zoomIn;
    zoomOut = D.zoomOut;
    bump = D.bump;
    fadeIn = D.fadeIn;
    bumpRatio = D.bumpRatio;
    useCircle = D.useCircle;
    padding = D.padding;
    listening = D.listening;
    spotlightSilent = D.spotlightSilent;
    spotlightInkwell = D.spotlightInkwell;
    backdropSilent = D.backdropSilent;
    backdropInkwell = D.backdropInkwell;
    alignment = D.alignment;
    actions = D.actions;
  }

  _selectAction(bool value, SpotlightAntAction action) {
    setState(() {
      actions.remove(action);
      if (value) {
        actions.add(action);
      }
      D.actions = actions;
    });
  }
}
