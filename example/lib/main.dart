import 'package:flutter/material.dart';
import 'package:flutter_test_example/alignment_screen.dart';
import 'package:flutter_test_example/animation_screen.dart';
import 'package:flutter_test_example/delay_screen.dart';
import 'package:flutter_test_example/obscure_screen.dart';
import 'package:flutter_test_example/random_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:spotlight_ant/spotlight_ant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_strategy/url_strategy.dart';

import 'my_spotlight.dart';

void main() {
  setPathUrlStrategy();
  runApp(App(GoRouter(
    initialLocation: '/flutter-spotlight-ant',
    routes: [
      GoRoute(
        name: 'home',
        path: '/flutter-spotlight-ant',
        builder: (ctx, state) => const StartPage(),
        routes: [
          GoRoute(
            path: 'alignment',
            name: 'alignment',
            builder: (ctx, state) => const AlignmentScreen(),
          ),
          GoRoute(
            path: 'animation',
            name: 'animation',
            builder: (ctx, state) => const AnimationScreen(),
          ),
          GoRoute(
            path: 'random',
            name: 'random',
            builder: (ctx, state) => const RandomScreen(),
          ),
          GoRoute(
            path: 'delay',
            name: 'delay',
            builder: (ctx, state) => const DelayScreen(),
          ),
          GoRoute(
            path: 'obscure',
            name: 'obscure',
            builder: (ctx, state) => const ObscureScreen(),
          ),
        ],
      ),
    ],
  )));
}

class App extends StatelessWidget {
  final GoRouter router;

  const App(this.router, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SpotlightAnt',
      routerConfig: router,
      onGenerateTitle: (context) => 'SpotlightAnt',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  ValueNotifier<bool> isFirst = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      onFinish: () => isFirst.value = false,
      appBar: AppBar(
        title: const Text('SpotlightAnt Example'),
        leading: ListenableBuilder(
          listenable: isFirst,
          builder: (context, _) => SpotlightAnt(
            enable: isFirst.value,
            content: const SpotlightContent(
              fontSize: 26,
              child: Text('Configure your spotlight...'),
            ),
            action: const SpotlightActionConfig(
              enabled: [SpotlightAntAction.prev, SpotlightAntAction.next],
            ),
            duration: const SpotlightDurationConfig(
              bump: Duration(milliseconds: 200),
              zoomIn: Duration(milliseconds: 300),
              zoomOut: Duration(milliseconds: 300),
            ),
            bumpRatio: 1.0,
            child: IconButton(
              icon: const Icon(Icons.menu_sharp),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ),
      ),
      floatingActionButtonWrapper: (ctx, btn) => ListenableBuilder(
        listenable: isFirst,
        builder: (context, _) => SpotlightAnt(
          enable: isFirst.value,
          spotlight: const SpotlightConfig(
            builder: SpotlightRectBuilder(borderRadius: 20),
            padding: EdgeInsets.zero,
          ),
          action: const SpotlightActionConfig(
            enabled: [SpotlightAntAction.prev],
          ),
          content: const SpotlightContent(
            fontSize: 26,
            child: Text('and re-run the animation by pressing the button.'),
          ),
          child: btn,
        ),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Spotlight(
            content: SpotlightContent(
              child: Column(children: [
                const CircleAvatar(
                  foregroundImage: AssetImage('assets/spotlight-ant.png'),
                  radius: 64,
                ),
                const Text('SpotlightAnt', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 16),
                const Text('SpotlightAnt help focus on specific widget.\n'),
                const Text('You can do many flexible configuration and \n'
                    'even make your own customized painter for the spotlight.\n'),
                const Text('You can easily setup the spotlight by using SpotlightAnt to wrap the widget.\n'
                    'See the details in the GitHub README\n'),
                ElevatedButton(
                  onPressed: () => launchUrl(Uri.parse(
                    'https://github.com/evan361425/flutter-spotlight-ant',
                  )),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('Go to GitHub '),
                    Icon(Icons.open_in_new_sharp),
                  ]),
                ),
              ]),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              padding: const EdgeInsets.all(8.0),
              child: const Text('Welcome !', style: TextStyle(fontSize: 32)),
            ),
          ),
          Builder(
            builder: (context) => OutlinedButton(
              onPressed: () => SpotlightShow.of(context).start(),
              child: const Text('Run Again'),
            ),
          ),
          Wrap(spacing: 8.0, runSpacing: 8.0, children: [
            ElevatedButton(
              onPressed: () => context.pushNamed('alignment'),
              child: const Text('Alignment'),
            ),
            ElevatedButton(
              onPressed: () => context.pushNamed('animation'),
              child: const Text('Animation'),
            ),
            ElevatedButton(
              onPressed: () => context.pushNamed('random'),
              child: const Text('Random Index'),
            ),
            ElevatedButton(
              onPressed: () => context.pushNamed('delay'),
              child: const Text('Delay'),
            ),
            ElevatedButton(
              onPressed: () => context.pushNamed('obscure'),
              child: const Text('Obscure'),
            ),
          ]),
          IconButton(
            onPressed: () => launchUrl(Uri.parse(
              'https://github.com/evan361425/flutter-spotlight-ant',
            )),
            icon: const FaIcon(IconDataBrands(0xf09b)),
          ),
        ]),
      ),
    );
  }
}
