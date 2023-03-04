import 'package:flutter/material.dart';
import 'package:spotlight_ant/spotlight_ant.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MySpotlight extends StatefulWidget {
  final Widget? content;
  final Widget child;
  final bool enable;

  const MySpotlight({
    Key? key,
    this.content,
    this.enable = true,
    required this.child,
  }) : super(key: key);

  @override
  State<MySpotlight> createState() => _MySpotlightState();
}

class _MySpotlightState extends SpotlightState<MySpotlight> {
  @override
  Widget build(BuildContext context) {
    return SpotlightAnt(
      enable: widget.enable,
      spotlightPadding: EdgeInsets.all(padding),
      zoomInDuration: Duration(milliseconds: zoomIn.toInt()),
      zoomOutDuration: Duration(milliseconds: zoomOut.toInt()),
      bumpDuration: Duration(milliseconds: bump.toInt()),
      contentFadeInDuration: Duration(milliseconds: fadeIn.toInt()),
      bumpRatio: bumpRatio,
      backdropSilent: backdropSilent,
      backdropUsingInkwell: backdropInkwell,
      spotlightSilent: spotlightSilent,
      spotlightUsingInkwell: spotlightInkwell,
      spotlightBuilder: useCircle ? const SpotlightCircularBuilder() : const SpotlightRectBuilder(),
      contentAlignment: alignment,
      actions: actions,
      onShow: () => _MyDriver.print('onShow'),
      onShown: () => _MyDriver.print('onShown'),
      onDismiss: () => _MyDriver.print('onDismiss'),
      onDismissed: () => _MyDriver.print('onDismissed'),
      content: widget.content,
      child: widget.child,
    );
  }
}

class MyScaffold extends StatelessWidget {
  final AppBar? appBar;

  final WidgetBuilder? bodyBuilder;

  final Widget? body;

  final VoidCallback? onFinish;

  final Widget Function(Widget widget)? floatingActionButtonWrapper;

  const MyScaffold({
    Key? key,
    this.onFinish,
    this.appBar,
    this.bodyBuilder,
    this.body,
    this.floatingActionButtonWrapper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpotlightShow(
      onFinish: () {
        _MyDriver.print('onFinish');
        onFinish?.call();
      },
      onSkip: () => _MyDriver.print('onSkip'),
      child: Builder(builder: (context) {
        final btn = FloatingActionButton(
          onPressed: () => SpotlightShow.of(context).start(),
          child: const Icon(Icons.refresh_sharp),
        );

        return Scaffold(
          appBar: appBar,
          drawer: const _MyDriver(),
          floatingActionButton: floatingActionButtonWrapper?.call(btn) ?? btn,
          body: bodyBuilder?.call(context) ?? body,
        );
      }),
    );
  }
}

class _MyDriver extends StatefulWidget {
  static ValueNotifier<double> zoomIn = ValueNotifier<double>(600);
  static ValueNotifier<double> zoomOut = ValueNotifier(600);
  static ValueNotifier<double> bump = ValueNotifier(500);
  static ValueNotifier<double> fadeIn = ValueNotifier(300);
  static ValueNotifier<double> bumpRatio = ValueNotifier(0.1);
  static ValueNotifier<double> padding = ValueNotifier(16.0);
  static ValueNotifier<bool> listening = ValueNotifier(false);
  static ValueNotifier<bool> spotlightSilent = ValueNotifier(false);
  static ValueNotifier<bool> spotlightInkwell = ValueNotifier(true);
  static ValueNotifier<bool> backdropSilent = ValueNotifier(false);
  static ValueNotifier<bool> backdropInkwell = ValueNotifier(true);
  static ValueNotifier<Alignment?> alignment = ValueNotifier(null);
  static ValueNotifier<String> actions = ValueNotifier('prev,skip,next');
  static ValueNotifier<bool> useCircle = ValueNotifier(true);

  static print(String eventName) {
    if (listening.value) {
      Fluttertoast.showToast(
        webShowClose: true,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        msg: '$eventName - ${DateTime.now().toString().substring(12)}',
      );
    }
  }

  const _MyDriver({Key? key}) : super(key: key);

  @override
  State<_MyDriver> createState() => _MyDriverState();
}

class _MyDriverState extends SpotlightState<_MyDriver> {
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
          _ScrollRow(children: [
            Text('Zoom In (${zoomIn.toStringAsFixed(0)})'),
            Slider(
              value: zoomIn,
              min: 50,
              max: 3000,
              onChanged: (value) => _MyDriver.zoomIn.value = value,
            ),
          ]),
          _ScrollRow(children: [
            Text('Zoom Out (${zoomOut.toStringAsFixed(0)})'),
            Slider(
              value: zoomOut,
              min: 50,
              max: 3000,
              onChanged: (value) => _MyDriver.zoomOut.value = value,
            ),
          ]),
          _ScrollRow(children: [
            Text('Bump (${bump.toStringAsFixed(0)})'),
            Slider(
              value: bump,
              min: 50,
              max: 3000,
              onChanged: (value) => _MyDriver.bump.value = value,
            ),
          ]),
          _ScrollRow(children: [
            Text('Content FadeIn (${fadeIn.toStringAsFixed(0)})'),
            Slider(
              value: fadeIn,
              min: 50,
              max: 3000,
              onChanged: (value) => _MyDriver.fadeIn.value = value,
            ),
          ]),
          const Divider(),
          const Center(
            child: Text(
              'Numeric Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          _ScrollRow(children: [
            Text('Bump Ratio (${bumpRatio.toStringAsFixed(1)})'),
            Slider(
              value: bumpRatio,
              min: 0.0,
              max: 3,
              onChanged: (value) => _MyDriver.bumpRatio.value = value,
            ),
          ]),
          _ScrollRow(children: [
            Text('Padding ${padding.toStringAsFixed(0)}'),
            Slider(
              value: padding,
              min: 0.0,
              max: 128.0,
              divisions: 128,
              onChanged: (value) => _MyDriver.padding.value = value,
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
                onSelected: (value) {
                  actions.remove(v);
                  if (value) {
                    actions.add(v);
                  }
                  _MyDriver.actions.value = actions.map((e) => e.name).join(',');
                },
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
            onChanged: (value) => _MyDriver.listening.value = value,
          ),
          SwitchListTile(
            value: useCircle,
            title: const Text('Use circle'),
            onChanged: (value) => _MyDriver.useCircle.value = value,
          ),
          SwitchListTile(
            value: spotlightInkwell,
            title: const Text('Spotlight inkwell'),
            onChanged: (value) => _MyDriver.spotlightInkwell.value = value,
          ),
          SwitchListTile(
            value: backdropInkwell,
            title: const Text('Backdrop inkwell'),
            onChanged: (value) => _MyDriver.backdropInkwell.value = value,
          ),
          SwitchListTile(
            value: spotlightSilent,
            title: const Text('Disable spotlight tapping'),
            onChanged: (value) => _MyDriver.spotlightSilent.value = value,
          ),
          SwitchListTile(
            value: backdropSilent,
            title: const Text('Disable backdrop tapping'),
            onChanged: (value) => _MyDriver.backdropSilent.value = value,
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
              onSelected: (value) => _MyDriver.alignment.value = null,
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
                onSelected: (value) => _MyDriver.alignment.value = (value ? v : null),
              ),
          ]),
        ],
      ),
    );
  }
}

class _ScrollRow extends StatelessWidget {
  final List<Widget> children;

  const _ScrollRow({Key? key, required this.children}) : super(key: key);

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

abstract class SpotlightState<T extends StatefulWidget> extends State<T> {
  double zoomIn = _MyDriver.zoomIn.value;
  double zoomOut = _MyDriver.zoomOut.value;
  double bump = _MyDriver.bump.value;
  double fadeIn = _MyDriver.fadeIn.value;
  double bumpRatio = _MyDriver.bumpRatio.value;
  bool useCircle = _MyDriver.useCircle.value;
  double padding = _MyDriver.padding.value;
  bool listening = _MyDriver.listening.value;
  bool spotlightSilent = _MyDriver.spotlightSilent.value;
  bool spotlightInkwell = _MyDriver.spotlightInkwell.value;
  bool backdropSilent = _MyDriver.backdropSilent.value;
  bool backdropInkwell = _MyDriver.backdropInkwell.value;
  Alignment? alignment = _MyDriver.alignment.value;
  List<SpotlightAntAction> actions = _MyDriver.actions.value
      .split(',')
      .where((e) => e != '')
      .map((e) => SpotlightAntAction.values.firstWhere((action) => action.name == e))
      .toList();

  @override
  void initState() {
    super.initState();
    _MyDriver.zoomIn.addListener(_zoomInCb);
    _MyDriver.zoomOut.addListener(_zoomOutCb);
    _MyDriver.bump.addListener(_bumpCb);
    _MyDriver.fadeIn.addListener(_fadeInCb);
    _MyDriver.bumpRatio.addListener(_bumpRatioCb);
    _MyDriver.useCircle.addListener(_useCircleCb);
    _MyDriver.padding.addListener(_paddingCb);
    _MyDriver.listening.addListener(_listeningCb);
    _MyDriver.spotlightSilent.addListener(_spotlightSilentCb);
    _MyDriver.spotlightInkwell.addListener(_spotlightInkwellCb);
    _MyDriver.backdropSilent.addListener(_backdropSilentCb);
    _MyDriver.backdropInkwell.addListener(_backdropInkwellCb);
    _MyDriver.alignment.addListener(_alignmentCb);
    _MyDriver.actions.addListener(_actionsCb);
  }

  void _zoomInCb() => setState(() => zoomIn = _MyDriver.zoomIn.value);
  void _zoomOutCb() => setState(() => zoomOut = _MyDriver.zoomOut.value);
  void _bumpCb() => setState(() => bump = _MyDriver.bump.value);
  void _fadeInCb() => setState(() => fadeIn = _MyDriver.fadeIn.value);
  void _bumpRatioCb() => setState(() => bumpRatio = _MyDriver.bumpRatio.value);
  void _useCircleCb() => setState(() => useCircle = _MyDriver.useCircle.value);
  void _paddingCb() => setState(() => padding = _MyDriver.padding.value);
  void _listeningCb() => setState(() => listening = _MyDriver.listening.value);
  void _spotlightSilentCb() => setState(() => spotlightSilent = _MyDriver.spotlightSilent.value);
  void _spotlightInkwellCb() => setState(() => spotlightInkwell = _MyDriver.spotlightInkwell.value);
  void _backdropSilentCb() => setState(() => backdropSilent = _MyDriver.backdropSilent.value);
  void _backdropInkwellCb() => setState(() => backdropInkwell = _MyDriver.backdropInkwell.value);
  void _alignmentCb() => setState(() => alignment = _MyDriver.alignment.value);
  void _actionsCb() => setState(() {
        actions = _MyDriver.actions.value
            .split(',')
            .where((e) => e != '')
            .map((e) => SpotlightAntAction.values.firstWhere((action) => action.name == e))
            .toList();
      });

  @override
  void dispose() {
    _MyDriver.zoomIn.removeListener(_zoomInCb);
    _MyDriver.zoomOut.removeListener(_zoomOutCb);
    _MyDriver.bump.removeListener(_bumpCb);
    _MyDriver.fadeIn.removeListener(_fadeInCb);
    _MyDriver.bumpRatio.removeListener(_bumpRatioCb);
    _MyDriver.useCircle.removeListener(_useCircleCb);
    _MyDriver.padding.removeListener(_paddingCb);
    _MyDriver.listening.removeListener(_listeningCb);
    _MyDriver.spotlightSilent.removeListener(_spotlightSilentCb);
    _MyDriver.spotlightInkwell.removeListener(_spotlightInkwellCb);
    _MyDriver.backdropSilent.removeListener(_backdropSilentCb);
    _MyDriver.backdropInkwell.removeListener(_backdropInkwellCb);
    _MyDriver.alignment.removeListener(_alignmentCb);
    _MyDriver.actions.removeListener(_actionsCb);
    super.dispose();
  }
}
