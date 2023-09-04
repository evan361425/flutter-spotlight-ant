class SpotlightDurationConfig {
  /// Duration for zoom in the spotlight (start).
  final Duration zoomIn;

  /// Duration for zoom out the spotlight (finish).

  final Duration zoomOut;

  /// Duration for bump forward and reverse.
  ///
  /// One cycle of bumping(forward + reverse) will cost 2 * [bump].
  final Duration bump;

  /// Duration of fading in the content after zoom-in.
  final Duration contentFadeIn;

  const SpotlightDurationConfig({
    this.zoomIn = const Duration(milliseconds: 600),
    this.zoomOut = const Duration(milliseconds: 600),
    this.bump = const Duration(milliseconds: 500),
    this.contentFadeIn = const Duration(milliseconds: 200),
  });

  // All zero, let it easy to test.
  static const SpotlightDurationConfig zero = SpotlightDurationConfig(
    zoomIn: Duration.zero,
    zoomOut: Duration.zero,
    bump: Duration(milliseconds: 500),
    contentFadeIn: Duration.zero,
  );
}
