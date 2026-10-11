import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class DeviceConfig {
  static double? screenHeight;
  static double? screenWidth;

  static void init(BuildContext context) {
    if (screenHeight == null || screenWidth == null) {
      screenHeight = MediaQuery.of(context).size.height;
      screenWidth = MediaQuery.of(context).size.width;
    }
  }

  static bool get isSmallPhone => screenHeight != null && screenHeight! < 640;
  static bool get isNormalPhone => screenHeight != null && screenHeight! >= 640 && screenHeight! < 800;
  static bool get isLargePhone => screenHeight != null && screenHeight! >= 800 && screenHeight! < 900;
  static bool get isMediumTablet => screenHeight != null && screenHeight! >= 900 && screenHeight! <= 1100;
  static bool get isLargeTablet => screenHeight != null && screenHeight! > 1100;
}

class AppSizes {
  static double boxHeight() {
    if (DeviceConfig.isSmallPhone) return 40;
    if (DeviceConfig.isNormalPhone) return 40;
    if (DeviceConfig.isLargePhone) return 50;
    if (DeviceConfig.isMediumTablet) return 60;
    return 70; // Large tablets
  }

  static double buttonHeight() {
    if (DeviceConfig.isSmallPhone) return 40;
    if (DeviceConfig.isNormalPhone) return 40;
    if (DeviceConfig.isLargePhone) return 45;
    if (DeviceConfig.isMediumTablet) return 50;
    return 55;
  }

  static double fontSmallSize() {
    if (DeviceConfig.isSmallPhone) return 10;
    if (DeviceConfig.isNormalPhone) return 10;
    if (DeviceConfig.isLargePhone) return 12;
    if (DeviceConfig.isMediumTablet) return 14;
    return 16;
  }

  static double fontSize() {
    if (DeviceConfig.isSmallPhone) return 13;
    if (DeviceConfig.isNormalPhone) return 14;
    if (DeviceConfig.isLargePhone) return 16;
    if (DeviceConfig.isMediumTablet) return 18;
    return 20;
  }

  static double fontHeadingSize() {
    if (DeviceConfig.isSmallPhone) return 13;
    if (DeviceConfig.isNormalPhone) return 16;
    if (DeviceConfig.isLargePhone) return 18;
    if (DeviceConfig.isMediumTablet) return 20;
    return 22;
  }

  static double fontHeadingSize2() {
    if (DeviceConfig.isSmallPhone) return 16;
    if (DeviceConfig.isNormalPhone) return 18;
    if (DeviceConfig.isLargePhone) return 20;
    if (DeviceConfig.isMediumTablet) return 22;
    return 24;
  }

  static double buttonFontSize() {
    if (DeviceConfig.isSmallPhone) return 13;
    if (DeviceConfig.isNormalPhone) return 14;
    if (DeviceConfig.isLargePhone) return 16;
    if (DeviceConfig.isMediumTablet) return 18;
    return 20;
  }

  static double fontHeaderSize() {
    if (DeviceConfig.isSmallPhone) return 20;
    if (DeviceConfig.isNormalPhone) return 22;
    if (DeviceConfig.isLargePhone) return 25;
    if (DeviceConfig.isMediumTablet) return 28;
    return 32;
  }

  static double buttonCornerRadius() {
    if (DeviceConfig.isSmallPhone) return 13;
    if (DeviceConfig.isNormalPhone) return 15;
    if (DeviceConfig.isLargePhone) return 15;
    if (DeviceConfig.isMediumTablet) return 15;
    return 22;
  }

  static double boxCornerRadius() {
    if (DeviceConfig.isSmallPhone) return 13;
    if (DeviceConfig.isNormalPhone) return 15;
    if (DeviceConfig.isLargePhone) return 15;
    if (DeviceConfig.isMediumTablet) return 15;
    return 15;
  }

  // --- Layout dividers and proportions ---

  static double assemblyInCardSizeWidth() {
    if (DeviceConfig.isSmallPhone) return 0.08;
    if (DeviceConfig.isNormalPhone) return 0.08;
    if (DeviceConfig.isLargePhone) return 0.09;
    if (DeviceConfig.isMediumTablet) return 0.10;
    return 0.12;
  }
  static double assemblyInCardSizeHeight() {
    if (DeviceConfig.isSmallPhone) return 0.10;
    if (DeviceConfig.isNormalPhone) return 0.10;
    if (DeviceConfig.isLargePhone) return 0.09;
    if (DeviceConfig.isMediumTablet) return 0.10;
    return 0.12;
  }
  static double searchCardSize(BuildContext context) {
    DeviceConfig.init(context);
    if (DeviceConfig.isSmallPhone) return 0.01;
    if (DeviceConfig.isNormalPhone) return 0.1;
    if (DeviceConfig.isLargePhone) return 0.1;
    if (DeviceConfig.isMediumTablet) return 0.10;
    return 0.12;
  }
  static double parkReparkPageBodyDivide() {
    if (DeviceConfig.isSmallPhone) return 0.75;
    if (DeviceConfig.isNormalPhone) return 0.65;
    if (DeviceConfig.isLargePhone) return 0.80;
    if (DeviceConfig.isMediumTablet) return 0.75;
    return 0.48;
  }
  static double navigatePageBodyDivide() {
    if (DeviceConfig.isSmallPhone) return 0.35;
    if (DeviceConfig.isNormalPhone) return 0.35;
    if (DeviceConfig.isLargePhone) return 0.25;
    if (DeviceConfig.isMediumTablet) return 0.25;
    return 0.35;
  }
  static double adminSettingPageDivide() {
    if (DeviceConfig.isSmallPhone) return  0.27;
    if (DeviceConfig.isNormalPhone) return  0.27;
    if (DeviceConfig.isLargePhone) return 0.20;
    if (DeviceConfig.isMediumTablet) return 0.20;
    return 0.12;
  }

  // --- Specific sizing for the Login Screen Form Fields ---

  static double loginFieldWidth(BuildContext context) {
    // Uses 85% of screen width for modern phones to stay adaptive across 360-430px bounds
    double width = MediaQuery.of(context).size.width;
    if (DeviceConfig.isMediumTablet || DeviceConfig.isLargeTablet) {
      return 400; // Cap at 400px for tablets so it doesn't stretch too wide
    }
    return width * 0.85;
  }

  static double loginFieldHeight() {
    if (DeviceConfig.isSmallPhone) return 40;
    if (DeviceConfig.isNormalPhone) return 45;
    if (DeviceConfig.isLargePhone) return 48;
    if (DeviceConfig.isMediumTablet) return 55;
    return 60;
  }

  static double loginButtonHeight() {
    if (DeviceConfig.isSmallPhone) return 45;
    if (DeviceConfig.isNormalPhone) return 50;
    if (DeviceConfig.isLargePhone) return 53;
    if (DeviceConfig.isMediumTablet) return 60;
    return 65;
  }
}