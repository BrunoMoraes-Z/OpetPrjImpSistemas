import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double defaultSize;
  static Orientation orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }

  static double getProportionateScreenHeight(double input) {
    double height = SizeConfig.screenHeight;
    return (input / 812) * height;
  }

  static double getProportionateScreenWidth(double input) {
    double width = SizeConfig.screenWidth;
    return (input / 375) * width;
  }
}
