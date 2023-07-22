import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotlight_ant/spotlight_ant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_strategy/url_strategy.dart';

import 'my_spotlight.dart';
import 'delay_screen.dart' deferred as delay;
import 'random_screen.dart' deferred as random;
import 'alignment_screen.dart' deferred as alignment;
import 'animation_screen.dart' deferred as animation;

void main() {
  setPathUrlStrategy();
  runApp(MaterialApp(
    title: 'SpotlightAnt',
    onGenerateTitle: (context) => 'SpotlightAnt',
    navigatorObservers: [MyScaffold.observer],
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.red),
    home: const StartPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      onFinish: () => setState(() => isFirst = false),
      appBar: AppBar(
        title: const Text('SpotlightAnt Example'),
        leading: Builder(
          builder: (context) => SpotlightAnt(
            enable: isFirst,
            content: const SpotlightContent(
              fontSize: 26,
              child: Text('Configure your spotlight...'),
            ),
            actions: const [SpotlightAntAction.prev, SpotlightAntAction.next],
            bumpDuration: const Duration(milliseconds: 200),
            zoomInDuration: const Duration(milliseconds: 300),
            zoomOutDuration: const Duration(milliseconds: 300),
            bumpRatio: 1.0,
            child: IconButton(
              icon: const Icon(Icons.menu_sharp),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ),
      ),
      floatingActionButtonWrapper: (btn) => SpotlightAnt(
        enable: isFirst,
        spotlightBuilder: const SpotlightRectBuilder(borderRadius: 20),
        actions: const [SpotlightAntAction.prev],
        spotlightPadding: EdgeInsets.zero,
        content: const SpotlightContent(
          fontSize: 26,
          child: Text('and re-run the animation by pressing the button.'),
        ),
        child: btn,
      ),
      bodyBuilder: (context) => Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          MySpotlight(
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
          OutlinedButton(
            onPressed: () => SpotlightShow.of(context).start(),
            child: const Text('Run Again'),
          ),
          Wrap(spacing: 8.0, runSpacing: 8.0, children: [
            ElevatedButton(
              onPressed: () async {
                await alignment.loadLibrary();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => alignment.AlignmentScreen(),
                ));
              },
              child: const Text('Alignment'),
            ),
            ElevatedButton(
              onPressed: () async {
                await animation.loadLibrary();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => animation.AnimationScreen(),
                ));
              },
              child: const Text('Animation'),
            ),
            ElevatedButton(
              onPressed: () async {
                await random.loadLibrary();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => random.RandomScreen(),
                ));
              },
              child: const Text('Random Index'),
            ),
            ElevatedButton(
              onPressed: () async {
                await delay.loadLibrary();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => delay.DelayScreen(),
                ));
              },
              child: const Text('Delay'),
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
