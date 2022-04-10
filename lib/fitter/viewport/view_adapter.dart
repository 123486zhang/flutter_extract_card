import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';

const double SCREEN_WIDTH = 375;

class ViewAdapter {

  static double screenWidth = SCREEN_WIDTH;

  static double getAdapterRatio() {
    return window.physicalSize.width / screenWidth;
  }

  static Size getScreenAdapterSize() {
    return Size(SCREEN_WIDTH, window.physicalSize.height / getAdapterRatio());
  }

  static MediaQueryData coposeMediaQueryData(WidgetsBinding instance) {
    var deviceRatio = getAdapterRatio();
    return MediaQueryData(
      size: instance.window.physicalSize / deviceRatio,
      devicePixelRatio: deviceRatio,
      textScaleFactor: instance.window.textScaleFactor,
      platformBrightness: instance.window.platformBrightness,
      padding: EdgeInsets.fromWindowPadding(instance.window.padding, deviceRatio),
      viewInsets: EdgeInsets.fromWindowPadding(instance.window.viewInsets, deviceRatio),
      accessibleNavigation: instance.window.accessibilityFeatures.accessibleNavigation,
      invertColors: instance.window.accessibilityFeatures.invertColors,
      disableAnimations: instance.window.accessibilityFeatures.disableAnimations,
      boldText: instance.window.accessibilityFeatures.boldText,
      alwaysUse24HourFormat: instance.window.alwaysUse24HourFormat);
  }
}