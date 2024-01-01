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
  });

  final SizeConfig size;
  final String text;
  final SvgPicture icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width(42),
      height: size.width(52),
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
              color: ColorConfig.grey400(),
              height: 0.12,
              letterSpacing: -0.13,
            ),
          ),
        ],
      ),
    );
  }
}