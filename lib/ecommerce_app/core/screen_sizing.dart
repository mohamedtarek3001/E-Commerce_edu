import 'dart:math';
import 'package:flutter/widgets.dart';

class ScreenSizing {
  static late double width;
  static late double height;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;

  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;
  static late double widthMultiplier;

  static bool isMobile = false;
  static bool isTablet = false;

  // Figma reference design dimensions
  static late double _figmaWidth;
  static late double _figmaHeight;

  static void init(BuildContext context, {required double figmaWidth, required double figmaHeight}) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;

    _figmaWidth = figmaWidth;
    _figmaHeight = figmaHeight;

    blockSizeHorizontal = width / 100;
    blockSizeVertical = height / 100;

    double screenRatio = sqrt(width * height) / 100;

    textMultiplier = screenRatio;
    imageSizeMultiplier = blockSizeHorizontal;
    heightMultiplier = blockSizeVertical;
    widthMultiplier = blockSizeHorizontal;

    isMobile = width < 600;
    isTablet = width >= 600 && width < 1200;
  }

  /// Get responsive width based on screen size
  static double getResponsiveWidth(double percentage) {
    return width * (percentage / 100);
  }

  /// Get responsive height based on screen size
  static double getResponsiveHeight(double percentage) {
    return height * (percentage / 100);
  }

  /// Get responsive font size using screen ratio
  static double getResponsiveFontSize(double fontSize) {
    return fontSize * textMultiplier;
  }

  /// Get width scaled from Figma to current device
  static double fromFigmaWidth(double figmaWidth) {
    return (figmaWidth / _figmaWidth) * width;
  }

  /// Get height scaled from Figma to current device
  static double fromFigmaHeight(double figmaHeight) {
    return (figmaHeight / _figmaHeight) * height;
  }

  /// Get font size scaled from Figma font size
  static double fromFigmaFont(double figmaFontSize) {
    return figmaFontSize * (sqrt(width * height) / sqrt(_figmaWidth * _figmaHeight));
  }
}
