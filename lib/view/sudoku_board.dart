import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:sudoku/util/value.dart';
import 'package:sudoku_api/sudoku_api.dart';

import '../state/game.dart';
import '../state/sudoku.dart';
import '../util/size.dart';

class SudokuBoard extends StatefulWidget {
  const SudokuBoard({
    super.key,
    required this.size,
    required this.puzzle,
  });

  final SizeConfig size;
  final Puzzle puzzle;

  @override
  State<SudokuBoard> createState() => _SudokuBoardState();
}

class _SudokuBoardState extends State<SudokuBoard> {
  SudokuState sudokuState = Get.put(SudokuState());
  GameState gameState = Get.put(GameState());

  @override
  void initState() {
    super.initState();
  }

  bool isReverse = false;

  // int isSelectPixel = 82;
  int? isSelectRow;
  int? isSelectCol;

  LineType isRowType = LineType.none;
  LineType isColType = LineType.none;

  /// 블럭 칼라 정의하기
  Color getColor(int index) {
    if (index % 3 == 0) {
      isReverse = !isReverse;
    }
    if (index % 9 == 0) {
      isReverse = !isReverse;
    }

    // 선택된 픽셀의 row & col 칠하기
    if ((isSelectRow != null && isSelectCol != null) &&
        (index ~/ 9 == isSelectRow || index % 9 == isSelectCol)) {
      return const Color(0xfffaedcd);
    }

    // 선택된 큰 픽셀 칠하기
    // if ((isRowType != LineType.none &&
    //     isColType != LineType.none) &&
    //     (linePosition[isRowType]!.contains(index ~/ 9) &&
    //         linePosition[isColType]!.contains(index % 9))) {
    //   return const Color(0xff606c38);
    // }

    // row(3, 4, 5)는 반전으로 칠해야 함
    if (index ~/ 9 == 3 || index ~/ 9 == 4 || index ~/ 9 == 5) {
      return !isReverse ? const Color(0xffccd5ae) : const Color(0xffe9edc9);
    }
    return isReverse ? const Color(0xffccd5ae) : const Color(0xffe9edc9);
  }

  void updateSelectPixel(int index) {
    setState(() {
      if (index == sudokuState.selectPixel) {
        isSelectRow = null;
        isSelectCol = null;
        isRowType = LineType.none;
        isColType = LineType.none;
      } else {
        isSelectRow = index ~/ 9;
        isSelectCol = index % 9;
        isRowType = LineType.values.singleWhere(
          (type) => linePosition[type]!.contains(index ~/ 9),
        );
        isColType = LineType.values.singleWhere(
          (type) => linePosition[type]!.contains(index % 9),
        );
      }
      sudokuState.clickPixel(index);
    });
  }

  Color cellColor(int index) {
    Puzzle puzzle = sudokuState.getPuzzle;
    Position position = Position(index: index);

    bool isPristine = puzzle.board()!.cellAt(position).prefill()!;
    int cellNum = puzzle.board()!.cellAt(position).getValue()!;

    /// 잘못된 숫자 입력 시 같은 값을 가진 셀의 글씨 표시
    int selectedNum = sudokuState.getLastInsertNum;
    if (sudokuState.getWrongSelect && cellNum == selectedNum) {
      return Colors.redAccent;
    }

    /// 처음 초기화된 값들은 검정색으로 표시
    if (isPristine) {
      // bool isSegViolated = puzzle.board()!.isSegmentViolated(position);
      // bool isRowViolated = puzzle.board()!.isRowViolated(position);
      // bool isColViolated = puzzle.board()!.isColumnViolated(position);
      //
      // if (isSegViolated || isRowViolated || isColViolated) {
      //   return Colors.redAccent;
      // }

      return Colors.black;
    }

    // bool isSegViolated = puzzle.board()!.isSegmentViolated(position);
    // bool isRowViolated = puzzle.board()!.isRowViolated(position);
    // bool isColViolated = puzzle.board()!.isColumnViolated(position);
    int answer = puzzle.solvedBoard()!.cellAt(position).getValue()!;
    int userAnswer = puzzle.board()!.cellAt(position).getValue()!;


    /// 정답지랑 비교
    if (userAnswer != 0 && userAnswer != answer) {
      return Colors.redAccent;
    } else {
      return Colors.blueAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put(GameState());
    Get.put(SudokuState());

    SizeConfig size = SizeConfig(context);
    return SizedBox(
      width: widget.size.width(350),
      height: widget.size.width(350),
      child: StreamBuilder(
        stream: widget.puzzle.board()!.change,
        builder: (context, snapshot) {
          return MediaQuery.removePadding(
            context: context,
            child: GridView.builder(
              itemCount: 81,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 9,
              ),
              itemBuilder: (context, index) {
                /// 기본 픽셀 칼라
                Color color = getColor(index);

                int val = widget.puzzle
                    .board()!
                    .getRow(index ~/ 9)[index % 9]
                    .getValue()!;

                return GestureDetector(
                  onTap: () {
                    updateSelectPixel(index);
                  },
                  child: Container(
                    margin: EdgeInsets.all(widget.size.width(1)),
                    decoration: BoxDecoration(
                      border: index == sudokuState.selectPixel
                          ? Border.all(
                              width: size.width(1),
                              color: Colors.black,
                            )
                          : Border.all(
                              width: 0,
                              color: Colors.transparent,
                            ),
                      color: index == sudokuState.selectPixel
                          ? const Color(0xffd4a373)
                          : color,
                    ),
                    child: Center(
                      child: Text(
                        '${val == 0 ? '' : val}',
                        style: TextStyle(
                          color: cellColor(index),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
