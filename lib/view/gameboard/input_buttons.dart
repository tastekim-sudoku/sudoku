import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/util/size.dart';

class InputButton extends StatefulWidget {
  final String text;
  final Color color;

  @override
  State<InputButton> createState() => _InputButtonsState();

  const InputButton({super.key, required this.text, required this.color});
}

class _InputButtonsState extends State<InputButton> {
  @override
  Widget build(context) {
    SizeConfig size = SizeConfig(context);
    return Container(
      width: size.width(52),
      height: size.width(52),
      padding: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: widget.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            size.width(64),
          ),
        ),
      ),
      child: Center(
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width(24),
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
