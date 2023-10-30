import 'package:flutter/material.dart';
import 'package:sudoku/util/size.dart';
import 'package:sudoku_api/sudoku_api.dart';

import '../state/sudoku.dart';
import '../view/input_button.dart';
import '../view/sudoku_board.dart';
import 'package:get/get.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key, required this.puzzle});

  final Puzzle puzzle;

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  SudokuState sudokuState = Get.put(SudokuState());
  int wrongCount = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig size = SizeConfig(context);
    Get.find<SudokuState>();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: size.width(20),
            horizontal: size.width(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SudokuBoard(
                size: size,
                puzzle: widget.puzzle,
              ),
              SizedBox(
                height: size.width(50),
              ),
              InputButton(
                size: size,
              ),
              Center(
                child: Obx(() => Text('${sudokuState.getWrongCount}')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
