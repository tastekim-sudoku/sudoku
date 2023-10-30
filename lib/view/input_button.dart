import 'package:flutter/material.dart';
import 'package:sudoku/state/sudoku.dart';
import 'package:get/get.dart';
import 'package:sudoku_api/sudoku_api.dart';

import '../util/size.dart';

class InputButton extends StatefulWidget {
  const InputButton({
    super.key,
    required this.size,
  });

  final SizeConfig size;

  @override
  State<InputButton> createState() => _InputButtonState();
}

class _InputButtonState extends State<InputButton> {
  SudokuState sudokuState = Get.put(SudokuState());

  @override
  Widget build(BuildContext context) {
    SizeConfig size = SizeConfig(context);

    return SizedBox(
      width: widget.size.width(350),
      height: widget.size.width(200),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GridView.builder(
          itemCount: 10,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (sudokuState.selectPixel != 81) {
                  if (index == 9) {
                    sudokuState.removeNum();
                  } else {
                    sudokuState.insertNum = index + 1;
                  }
                } else {
                  return;
                }
              },
              child: Container(
                margin: EdgeInsets.all(
                  widget.size.width(1),
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                ),
                child: Center(
                  child: index + 1 == 10
                      ? const Icon(Icons.arrow_back)
                      : Text(
                          (index + 1).toString(),
                    style: TextStyle(
                      fontSize: size.width(16),
                      fontWeight: FontWeight.w600,
                    ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
