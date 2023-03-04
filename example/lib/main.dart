import 'package:flutter/material.dart';
import 'package:flutter_test_example/delay_screen.dart';
import 'package:flutter_test_example/my_spotlight.dart';
import 'package:flutter_test_example/random_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spotlight_ant/spotlight_ant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_strategy/url_strategy.dart';

import 'alignment_screen.dart';
import 'animation_screen.dart';

void main() {
  setPathUrlStrategy();
  final observer = RouteObserver<ModalRoute<void>>();

  runApp(MaterialApp(
    title: 'SpotlightAnt',
    onGenerateTitle: (context) => 'SpotlightAnt',
    navigatorObservers: [observer],
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
        spotlightBuilder: const SpotlightRectBuilder(),
        actions: const [SpotlightAntAction.prev],
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
                  child: Row(mainAxisSize: MainAxisSize.min, children: const [
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
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AlignmentScreen(),
                ));
              },
              child: const Text('Alignment'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AnimationScreen(),
                ));
              },
              child: const Text('Animation'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const RandomScreen(),
                ));
              },
              child: const Text('Random Index'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DelayScreen(),
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
