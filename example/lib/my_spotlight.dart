import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotlight_ant/spotlight_ant.dart';

class Spotlight extends StatefulWidget {
  final bool enable;
  final bool traceChild;
  final String? monitorId;
  final int? index;

  final Widget? content;
  final Widget child;

  static final config = Config();

  const Spotlight({
    super.key,
    this.content,
    this.index,
    this.monitorId,
    this.enable = true,
    this.traceChild = false,
    required this.child,
  });

  @override
  State<Spotlight> createState() => _SpotlightState();
}

class _SpotlightState extends State<Spotlight> {
  @override
  Widget build(BuildContext context) {
    final c = Spotlight.config;
    return ListenableBuilder(
        listenable: c,
        builder: (context, _) {
          return SpotlightAnt(
            enable: widget.enable,
            index: widget.index,
            monitorId: widget.monitorId,
            traceChild: widget.traceChild,
            spotlight: SpotlightConfig(
              padding: EdgeInsets.all(c.padding.value),
              builder: c.useCircle.value ? const SpotlightCircularBuilder() : const SpotlightRectBuilder(),
              silent: c.spotlightSilent.value,
              usingInkwell: c.spotlightInkwell.value,
            ),
            duration: SpotlightDurationConfig(
              zoomIn: Duration(milliseconds: c.zoomIn.value.toInt()),
              zoomOut: Duration(milliseconds: c.zoomOut.value.toInt()),
              bump: Duration(milliseconds: c.bump.value.toInt()),
              contentFadeIn: Duration(milliseconds: c.fadeIn.value.toInt()),
            ),
            bumpRatio: c.bumpRatio.value,
            backdrop: SpotlightBackdropConfig(
              silent: c.backdropSilent.value,
              usingInkwell: c.backdropInkwell.value,
            ),
            contentLayout: SpotlightContentLayoutConfig(
              alignment: c.alignment.value,
            ),
            action: SpotlightActionConfig(enabled: c.antActions),
            onShow: () => c.handleEvent('onShow'),
            onShown: () => c.handleEvent('onShown'),
            onDismiss: () => c.handleEvent('onDismiss'),
            onDismissed: () => c.handleEvent('onDismissed'),
            content: widget.content,
            child: widget.child,
          );
        });
  }
}

class MyScaffold extends StatelessWidget {
  final AppBar? appBar;

  final Widget body;

  final VoidCallback? onFinish;

  final Widget Function(BuildContext context, Widget widget)? floatingActionButtonWrapper;

  const MyScaffold({
    super.key,
    this.onFinish,
    this.appBar,
    required this.body,
    this.floatingActionButtonWrapper,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SpotlightShow(
        onFinish: () {
          Spotlight.config.handleEvent('onFinish');
          onFinish?.call();
        },
        onSkip: () => Spotlight.config.handleEvent('onSkip'),
        child: Builder(builder: (context) {
          final btn = ElevatedButton(
            style: const ButtonStyle(
              minimumSize: WidgetStatePropertyAll(Size(double.infinity, 48)),
            ),
            onPressed: () => SpotlightShow.of(context).start(),
            child: const Text('Re-run the spotlight show!'),
          );

          return Scaffold(
            appBar: appBar,
            drawer: const _MyDriver(),
            persistentFooterButtons: [floatingActionButtonWrapper?.call(context, btn) ?? btn],
            body: body,
          );
        }),
      ),
    );
  }
}

class _MyDriver extends StatefulWidget {
  const _MyDriver();

  @override
  State<_MyDriver> createState() => _MyDriverState();
}

class _MyDriverState extends State<_MyDriver> {
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
          ListenableBuilder(listenable: Spotlight.config, builder: _buildToggler),
        ],
      ),
    );
  }

  Widget _buildToggler(BuildContext context, Widget? _) {
    final c = Spotlight.config;
    final actions = c.antActions;
    return Column(children: [
      _row(
        Text('Zoom In (${c.zoomIn.value.toStringAsFixed(0)})'),
        Slider(
          value: c.zoomIn.value,
          min: 50,
          max: 3000,
          onChanged: (value) => c.zoomIn.value = value,
        ),
      ),
      _row(
        Text('Zoom Out (${c.zoomOut.value.toStringAsFixed(0)})'),
        Slider(
          value: c.zoomOut.value,
          min: 50,
          max: 3000,
          onChanged: (value) => c.zoomOut.value = value,
        ),
      ),
      _row(
        Text('Bump (${c.bump.value.toStringAsFixed(0)})'),
        Slider(
          value: c.bump.value,
          min: 50,
          max: 3000,
          onChanged: (value) => c.bump.value = value,
        ),
      ),
      _row(
        Text('Content FadeIn (${c.fadeIn.value.toStringAsFixed(0)})'),
        Slider(
          value: c.fadeIn.value,
          min: 50,
          max: 3000,
          onChanged: (value) => c.fadeIn.value = value,
        ),
      ),
      const Divider(),
      const Center(
        child: Text(
          'Numeric Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      _row(
        Text('Bump Ratio (${c.bumpRatio.value.toStringAsFixed(1)})'),
        Slider(
          value: c.bumpRatio.value,
          min: 0.0,
          max: 3,
          onChanged: (value) => c.bumpRatio.value = value,
        ),
      ),
      _row(
        Text('Padding ${c.padding.value.toStringAsFixed(0)}'),
        Slider(
          value: c.padding.value,
          min: 0.0,
          max: 128.0,
          divisions: 128,
          onChanged: (value) => c.padding.value = value,
        ),
      ),
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
              c.actions.value = actions.map((e) => e.name).join(',');
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
        value: c.listening.value,
        title: const Text('Listening events'),
        onChanged: (value) => c.listening.value = value,
      ),
      SwitchListTile(
        value: c.useCircle.value,
        title: const Text('Use circle'),
        onChanged: (value) => c.useCircle.value = value,
      ),
      SwitchListTile(
        value: c.spotlightInkwell.value,
        title: const Text('Spotlight inkwell'),
        onChanged: (value) => c.spotlightInkwell.value = value,
      ),
      SwitchListTile(
        value: c.backdropInkwell.value,
        title: const Text('Backdrop inkwell'),
        onChanged: (value) => c.backdropInkwell.value = value,
      ),
      SwitchListTile(
        value: c.spotlightSilent.value,
        title: const Text('Disable spotlight tapping'),
        onChanged: (value) => c.spotlightSilent.value = value,
      ),
      SwitchListTile(
        value: c.backdropSilent.value,
        title: const Text('Disable backdrop tapping'),
        onChanged: (value) => c.backdropSilent.value = value,
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
          selected: c.alignment.value == null,
          onSelected: (value) => c.alignment.value = null,
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
            selected: v == c.alignment.value,
            onSelected: (value) => c.alignment.value = (value ? v : null),
          ),
      ]),
    ]);
  }

  Widget _row(Widget w1, Widget w2) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [w1, w2],
      ),
    );
  }
}

class Config extends ChangeNotifier {
  final ValueNotifier<double> zoomIn = ValueNotifier<double>(600);
  final ValueNotifier<double> zoomOut = ValueNotifier(600);
  final ValueNotifier<double> bump = ValueNotifier(500);
  final ValueNotifier<double> fadeIn = ValueNotifier(300);
  final ValueNotifier<double> bumpRatio = ValueNotifier(0.1);
  final ValueNotifier<double> padding = ValueNotifier(16.0);
  final ValueNotifier<bool> listening = ValueNotifier(false);
  final ValueNotifier<bool> spotlightSilent = ValueNotifier(false);
  final ValueNotifier<bool> spotlightInkwell = ValueNotifier(true);
  final ValueNotifier<bool> backdropSilent = ValueNotifier(false);
  final ValueNotifier<bool> backdropInkwell = ValueNotifier(true);
  final ValueNotifier<Alignment?> alignment = ValueNotifier(null);
  final ValueNotifier<bool> useCircle = ValueNotifier(true);
  final ValueNotifier<String> actions = ValueNotifier('prev,skip,next');

  Config() {
    zoomIn.addListener(notifyListeners);
    zoomOut.addListener(notifyListeners);
    bump.addListener(notifyListeners);
    fadeIn.addListener(notifyListeners);
    bumpRatio.addListener(notifyListeners);
    padding.addListener(notifyListeners);
    listening.addListener(notifyListeners);
    spotlightSilent.addListener(notifyListeners);
    spotlightInkwell.addListener(notifyListeners);
    backdropSilent.addListener(notifyListeners);
    backdropInkwell.addListener(notifyListeners);
    alignment.addListener(notifyListeners);
    useCircle.addListener(notifyListeners);
    actions.addListener(notifyListeners);
  }

  List<SpotlightAntAction> get antActions => actions.value
      .split(',')
      .where((e) => e != '')
      .map((e) => SpotlightAntAction.values.firstWhere((action) => action.name == e))
      .toList();

  void handleEvent(String eventName) {
    if (listening.value) {
      Fluttertoast.showToast(
        webShowClose: true,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 5,
        msg: '$eventName - ${DateTime.now().toString().substring(12)}',
      );
    }
  }
}
