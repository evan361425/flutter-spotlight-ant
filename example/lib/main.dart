import 'package:flutter/material.dart';
import 'package:flutter_test_example/my_spotlight.dart';
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

  final k = GlobalKey<MySpotlightState>();

  final gaffer = GlobalKey<SpotlightAntState>();

  final ant = GlobalKey<SpotlightAntState>();

  final ant2 = GlobalKey<SpotlightAntState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpotlightAnt Example'),
        leading: Builder(
          builder: (BuildContext context) {
            return MySpotlight(
              ant: ant,
              enable: isFirst,
              content: const SpotlightContent(
                child: Text('Configure your spotlight...'),
              ),
              child: IconButton(
                icon: const Icon(Icons.menu_sharp),
                onPressed: () => Scaffold.of(context).openDrawer(),
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
            );
          },
        ),
      ),
      drawer: const D(),
      floatingActionButton: MySpotlight(
        ant: ant2,
        enable: isFirst,
        content: const SpotlightContent(
          child: Text('and re-run the animation by pressing the button.'),
        ),
        child: FloatingActionButton(
          onPressed: () => k.currentState?.show(),
          child: const Icon(Icons.refresh_sharp),
        ),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        MySpotlight(
          key: k,
          ant: gaffer,
          ants: [gaffer, ant, ant2],
          onFinish: () => setState(() {
            isFirst = false;
          }),
          content: SpotlightContent(
            child: Column(children: [
              const CircleAvatar(
                foregroundImage: AssetImage('assets/spotlight-ant.png'),
                radius: 128,
              ),
              const Text('SpotlightAnt', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 16),
              const Text('SpotlightAnt help focus on specific widget.\n'),
              const Text('You can do many flexible configuration and \n'
                  'even make your own customized painter for the spotlight.\n'),
              const Text(
                  'You can easily setup the spotlight by using SpotlightAnt to wrap the widget.\n'
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
        ElevatedButton(
          onPressed: () => k.currentState?.show(),
          child: const Text('Run Again'),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AlignmentScreen(),
              ));
            },
            child: const Text('Alignment'),
          ),
          IconButton(
            onPressed: () => launchUrl(Uri.parse(
              'https://github.com/evan361425/flutter-spotlight-ant',
            )),
            icon: const FaIcon(IconDataBrands(0xf09b)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AnimationScreen(),
              ));
            },
            child: const Text('Animation'),
          ),
        ]),
      ]),
    );
  }
}
