import 'package:flutter/material.dart';

import 'my_spotlight.dart';

class ObscureScreen extends StatefulWidget {
  const ObscureScreen({super.key});

  @override
  State<ObscureScreen> createState() => ObscureScreenState();
}

class ObscureScreenState extends State<ObscureScreen> {
  bool isShown = false;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      appBar: AppBar(
        title: const Text('Obscure Example'),
        actions: const [BackButton()],
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_outlined),
                  ),
                ),
                body: TextButton(
                  onPressed: () {
                    setState(() {
                      isShown = true;
                    });
                  },
                  child: const Text('Tap to add trailing icon on below page'),
                ),
              );
            }));
          },
          child: const Text('show page above this one'),
        ),
        ListTile(
          title: const Text('Trailing icon can be trigger on next page'),
          subtitle: const Text('press this tile to hide'),
          onTap: () {
            setState(() {
              isShown = false;
            });
          },
          trailing: isShown
              ? const Spotlight(
                  monitorId: 'obscure-test',
                  child: Icon(Icons.star),
                )
              : null,
        ),
      ]),
    );
  }
}
