import 'package:flutter/material.dart';

class ResponsiveApplication {
  /*
 determine des types of the device :Phone or Tablet
  */
  static String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 550 ? 'phone' : 'tablet';
  }

  /*
   apply the factor responsive to every image size
  */
  static giveTheNiceSizeForthisScreen(double size) {
    if (getDeviceType() == 'phone') {
      return size;
    }
    return size * (550 / 800);
  }

  /*
   apply the factor responsive to every image width size : la hauteur est laissé comme tel
  */
  static giveTheNiceWidthSizeBoxForthisScreen(double size) {
    if (getDeviceType() == 'phone') {
      return size;
    }
    return size / 1.25;
  }

  static giveTheNiceHeigthSizeBoxForthisScreen(double size) {
    if (getDeviceType() == 'phone') {
      return size;
    }
    return size / 0.77;
  }

  static giveTheNiceScreenImageForthisScreen(double size) {
    if (getDeviceType() == 'phone') {
      return size;
    }
    return size * 0.833333;
  }

  /*
   apply the factor responsive to every text size
  */
  static giveTheNiceSimpleTextSizeForthisScreen(double size) {
    if (getDeviceType() == 'phone') {
      return size;
    }
    return size / (0.75);
  }

  static giveTheNiceBoldTextSizeForthisScreen(double size) {
    if (getDeviceType() == 'phone') {
      return size;
    }
    return size / (0.6);
  }

  /*
   apply the factor responsive to every image size
  */
  static giveTheNiceIconeSizeForthisScreen(double size) {
    if (getDeviceType() == 'phone') {
      return size;
    }
    return size / 0.75;
  }
}
