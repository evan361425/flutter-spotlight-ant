# Example

You can use web app UI to see how the configuration works.

Here provide severals ways:

-   visit GitHub hosting [page](https://evan361425.github.io/flutter-spotlight-ant/).
-   clone the project and run develop mode.
-   clone the built package and host the web app.

## Develop mode

```bash
git clone --depth 1 \
  git@github.com:evan361425/flutter-spotlight-ant.git spotlight-ant \
    && cd spotlight-ant/example \
    && flutter pub get \
    && flutter run -d chrome
```

## Built package

Clone the artifacts which built from the latest tag's:

```bash
git clone \
  --depth 1 \
  -b gh-pages \
  --single-branch \
  git@github.com:evan361425/flutter-spotlight-ant.git spotlight-ant \
    && cd spotlight-ant \
    && python -m http.server 8000
```

Then open <http://localhost:8000> on your browser.

You can built it your own by:

```bash
flutter build web --release
```

## In the code

Use it by wrapping your target:

```dart
final ant1 = GlobalKey<SpotlightAntState>();
final ant2 = GlobalKey<SpotlightAntState>();

Widget build(BuildContext context) {
  return Column(children: [
    // this is the main ant with `ants`, we call it gaffer
    SpotlightAnt(
      key: ant1,
      ants: [ant1, ant2], // only gaffer can set it
      child: MyCircularButton(),
    ),
    SpotlightAnt(
      key: ant2,
      // set the ants again here will build two spotlight shows.
      spotlightBuilder: const SpotlightRectBuilder(),
      child: MyRectButton(),
    ),
  ]);
}
```
