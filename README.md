<a href="https://evan361425.github.io/flutter-spotlight-ant/">
  <h1 align="center">
    <picture>
      <img alt="SpotlightAnt" src="https://raw.githubusercontent.com/evan361425/flutter-spotlight-ant/master/docs/spotlight-ant.png">
    </picture>
  </h1>
</a>

[![codecov](https://codecov.io/gh/evan361425/flutter-spotlight-ant/branch/master/graph/badge.svg?token=kLLR8QWK9l)](https://codecov.io/gh/evan361425/flutter-spotlight-ant)
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/003d6ab544314dee887aa57631e856c9)](https://www.codacy.com/gh/evan361425/flutter-spotlight-ant/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=evan361425/flutter-spotlight-ant&amp;utm_campaign=Badge_Grade)
[![Pub Version](https://img.shields.io/pub/v/spotlight_ant)](https://pub.dev/packages/spotlight_ant)

`SpotlightAnt` help focus on specific widget with highly flexible configuration.

> This package is separated from my project [POS-System](https://github.com/evan361425/flutter-pos-system).

| Flexible | Auto Alignment | Animation |
| - | - | - |
| ![SpotlightAnt Basic DEMO](https://raw.githubusercontent.com/evan361425/flutter-spotlight-ant/master/docs/intro.gif) | ![SpotlightAnt Alignment DEMO](https://raw.githubusercontent.com/evan361425/flutter-spotlight-ant/master/docs/align.gif)| ![SpotlightAnt Animation DEMO](https://raw.githubusercontent.com/evan361425/flutter-spotlight-ant/master/docs/animate.gif) |

Play it yourself by cloning the repo:

```bash
git clone git@github.com:evan361425/flutter-spotlight-ant.git \
  && cd flutter-spotlight-ant/example \
  && flutter pub get \
  && flutter run -d chrome
```

## Installation

```bash
flutter pub add spotlight_ant
```

## Usage

```dart
final ant1 = GlobalKey<SpotlightAntState>();
final ant2 = GlobalKey<SpotlightAntState>();

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
```

It can also run by program:

```dart
TabBarView(
  controller: _controller,
  children: [
    Container(),
    SpotlightAnt(
      key: _ant,
      ants: [_ant],
      child: Text('child'),
    ),
  ],
);
// ...
final desiredIndex = 1;
_controller.addListener(() {
  if (!_controller.indexIsChanging) {
    if (desiredIndex == _controller.index) {
      _ant.show();
    }
  }
});
```

## Configuration

Every ant(no matter it is gaffer or not) share the configuration bellow:

| Name | Default | Desc. |
| - | - | - |
| key | *required* | Created by `GlobalKey<SpotlightAntState>()`. |
| enable | `true` | - |
| spotlightBuilder | `SpotlightCircularBuilder` | Allow any builder from extends from `SpotlightBuilder`. |
| spotlightPadding | `EdgeInsets.all(8)` | - |
| spotlightSilent | `false` | Disable capture spotlight tap event. |
| spotlightUsingInkwell | `true` | Use `GestureDetector` if false. |
| spotlightSplashColor | `null` | - |
| backdropSilent | `false` | - |
| backdropUsingInkwell | `true` | - |
| backdropSplashColor | `null` | - |
| actions | `[SpotlightAntAction.skip]` | Actions showing in bottom, customize it by `actionBuilder`. |
| actionBuilder | `null` | - |
| nextAction | `null` | Change `SpotlightAntAction.next` default widget |
| prevAction | `null` | - |
| skipAction | `null` | - |
| zoomInDuration | `Duration(milliseconds: 600)` | - |
| zoomOutDuration | `Duration(milliseconds: 600)` | - |
| bumpDuration | `Duration(milliseconds: 500)` | Argument for `AnimationController.repeat` |
| bumpRatio | `0.1` | How big outer area you want in bump animation. |
| content | `null` | Content beside spotlight. |
| contentAlignment | `null` | Auto-detect it or specify it. |
| contentFadeInDuration | `Duration(milliseconds: 300)` | - |
| onShown | `null` | Callback before zoom in. |
| onShow | `null` | Callback after zoom in. |
| onDismiss | `null` | Callback before zoom out. |
| onDismissed | `null` | Callback after zoom out. |
| child | *required* | The spotlight target. |

Only *gaffer* can set the configuration below:

| Name | Default | Desc. |
| - | - | - |
| ants | `null` | Set the ants for spotlight. |
| showAfterInit | `true` | If you want to fire it by program, set it to false |
| showWaitFuture | `null` | Pass the `Future` and it will wait until done and start the spotlight show. |
| onSkip | `null` | Callback after tapping `SpotlightAntAction.skip`. |
| onFinish | `null` | Callback after finish the show. |

## Customize

It can be easy to customize your painter:

```dart
class MyCustomSpotlightBuilder extends SpotlightBuilder {
  @override
  SpotlightPainter build(Rect target, double value, bool isBumping) {
    // ...
  }

  @override
  double inkwellRadius(Rect target) => 0;
}

class _Painter extends SpotlightPainter {
  @override
  /// The [size] should be the window's size
  void paint(Canvas canvas, Size size) {
    // ...
  }
}
```

Actions is also easy too:

```dart
SpotlightAnt(
  skipAction: TextButton.icon(
    onPressed: () => gaffer.skip(),
    label: const Text('MY Skip'),
    icon: const Icon(Icons.arrow_forward_ios_sharp),
  ),
  // ...
);
```
