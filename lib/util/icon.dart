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
    'assets/icons/pause.svg',
    height: size,
    width: size,
    fit: BoxFit.scaleDown,
  );

  static SvgPicture play(double size) => SvgPicture.asset(
    'assets/icons/play.svg',
    height: size,
    width: size,
    fit: BoxFit.scaleDown,
  );

  static SvgPicture remove(double size) => SvgPicture.asset(
    'assets/icons/eraser.svg',
    height: size,
    width: size,
    fit: BoxFit.scaleDown,
  );

  static SvgPicture memoOn(double size) => SvgPicture.asset(
    'assets/icons/group-on.svg',
    height: size,
    width: size,
    fit: BoxFit.scaleDown,
  );

  static SvgPicture memoOff(double size) => SvgPicture.asset(
    'assets/icons/group-off.svg',
    height: size,
    width: size,
    fit: BoxFit.scaleDown,
  );

  static SvgPicture hintAd(double size) => SvgPicture.asset(
    'assets/icons/hint-ad.svg',
    height: size,
    width: size,
    fit: BoxFit.scaleDown,
  );

  static SvgPicture hintOne(double size) => SvgPicture.asset(
    'assets/icons/hint-one.svg',
    height: size,
    width: size,
    fit: BoxFit.scaleDown,
  );

  static SvgPicture hintTwo(double size) => SvgPicture.asset(
    'assets/icons/hint-two.svg',
    height: size,
    width: size,
    fit: BoxFit.scaleDown,
  );

  static SvgPicture hintThree(double size) => SvgPicture.asset(
    'assets/icons/hint-three.svg',
    height: size,
    width: size,
    fit: BoxFit.scaleDown,
  );

  static SvgPicture undo(double size) => SvgPicture.asset(
    'assets/icons/undo.svg',
    height: size,
    width: size,
    fit: BoxFit.scaleDown,
  );
}