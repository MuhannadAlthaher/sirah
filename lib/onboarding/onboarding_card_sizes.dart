/// Proportional sizing for [OnboardingFeatureCard], derived entirely
/// from the card's resolved width so its layout scales for any screen
/// instead of relying on fixed pixel values.
class OnboardingCardSizes {
  const OnboardingCardSizes(this.width);

  final double width;

  // Card shell
  double get cardBorderWidth => width * 0.006;
  double get cardRadius => width * 0.06;
  double get spacing => width * 0.06;

  // Icon + blob header.
  //
  // headerHeight is deliberately shorter than the blob's own bottom
  // edge (blobSize - blobOffset), so the preview card that follows it
  // in the Column starts inside the blob's zone and overlaps it — no
  // negative padding/margin required (RenderPadding asserts padding
  // must be non-negative).
  double get blobSize => width * 0.5;
  double get blobOffset => blobSize * 0.24;
  double get headerHeight => width * 0.3;
  double get iconSize => width * 0.2;
  double get iconInset => width * 0.08;
  double get iconPadding => iconSize * 0.25;

  // Scan preview mockup card
  double get previewPadding => width * 0.05;
  double get previewGap => width * 0.03;
  double get previewRadius => width * 0.045;
  double get previewShadowBlur => width * 0.03;
  double get previewShadowOffset => width * 0.015;
  double get barHeight => width * 0.025;
  double get titleBarHeight => width * 0.04;

  // Highlighted scan row
  double get scanRowPaddingH => width * 0.03;
  double get scanRowPaddingV => width * 0.035;
  double get scanRowBorderWidth => width * 0.005;
  double get scanRowRadius => width * 0.08;
  double get scanRowInnerBarHeight => width * 0.015;
  double get scanRowInnerBarRadius => width * 0.01;

  // "ATS SCAN" badge
  double get badgePaddingH => width * 0.025;
  double get badgePaddingV => width * 0.01;
  double get badgeRadius => width * 0.05;
  double get badgeOffset => width * 0.03;
}
