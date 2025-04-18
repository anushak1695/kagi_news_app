import 'package:flutter/material.dart';

class AdaptiveSize {
  static late double screenWidth;
  static late double screenHeight;
  static late double devicePixelRatio;
  static late double baseHeight;
  static late double baseWidth;

  /// Initialize the screen dimensions
  static void init(
    BuildContext context, {
    double baseHeightValue = 926.0,
    double baseWidthValue = 428.0,
  }) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    devicePixelRatio = mediaQuery.devicePixelRatio;
    baseHeight = baseHeightValue; // Default base height for scaling
    baseWidth = baseWidthValue;
  }

  /// Convert a height value to adaptive height
  static double h(double heightPx) {
    return heightPx * (screenHeight / baseHeight);
  }

  /// Convert a width value to adaptive width
  static double w(double widthPx) {
    return widthPx * (screenWidth / baseWidth);
  }

  /// Convert a pixel value to adaptive sp
  static double sp(double fontSizePx) {
    return fontSizePx * (screenHeight / baseHeight);
  }
}
