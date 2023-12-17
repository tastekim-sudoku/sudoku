import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../util/size.dart';
import '../../util/theme.dart';

class FeatureButton extends StatelessWidget {
  const FeatureButton({
    super.key,
    required this.size,
    required this.text,
    required this.icon,
    required this.color,
  });

  final SizeConfig size;
  final String text;
  final SvgPicture icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width(31),
      height: size.width(50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          SizedBox(
            height: size.width(4),
          ),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.width(12),
              color: color,
              height: 0.12,
              letterSpacing: -0.13,
            ),
          ),
        ],
      ),
    );
  }
}