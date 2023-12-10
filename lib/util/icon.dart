import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIcon {
  static SvgPicture backArrow(double size) => SvgPicture.asset(
    'assets/icons/icon-arrow-left-small-mono.svg',
    height: size,
    width: size,
    fit: BoxFit.scaleDown,
  );

  static SvgPicture settings(double size) => SvgPicture.asset(
    'assets/icons/icon-setting-mono.svg',
    height: size,
    width: size,
    fit: BoxFit.scaleDown,
  );

  static SvgPicture pause(double size) => SvgPicture.asset(
    'assets/icons/Subtract.svg',
    height: size,
    width: size,
    fit: BoxFit.scaleDown,
  );
}