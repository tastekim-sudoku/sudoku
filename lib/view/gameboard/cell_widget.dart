import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

import '../../util/size.dart';
import '../../util/theme.dart';

class CellWidget extends StatelessWidget {
  const CellWidget({
    super.key,
    required this.margin,
    required this.size,
    required this.selectGrid,
    required this.selectCell,
    required this.hasMemo,
    required Puzzle puzzle,
    required this.val,
    required this.isPrefillNum,
    required this.isEmptyNum,
    required this.isCorrect,
  }) : _puzzle = puzzle;

  final EdgeInsets margin;
  final SizeConfig size;
  final bool selectGrid;
  final bool selectCell;
  final bool hasMemo;
  final Puzzle _puzzle;
  final Cell val;
  final bool isPrefillNum;
  final bool isEmptyNum;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: size.width(36),
      height: size.width(36),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selectGrid
            ? selectCell
                ? Colors.white
                : ColorConfig.blue50()
            : Colors.white,
        border: selectCell
            ? Border.all(
                color: ColorConfig.blue500(),
                width: size.width(2),
              )
            : Border.all(
                width: 2,
                color: selectGrid ? ColorConfig.blue50() : Colors.white,
              ),
        // borderRadius: BorderRadius.circular(size.width(4)),
      ),
      child: hasMemo && _puzzle.board()!.cellAt(val.position!).getValue() == 0
          ? Center(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: size.width(4),
                  vertical: size.width(3),
                ),
                padding: EdgeInsets.zero,
                // width: size.width(24),
                // height: size.width(26),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    List<int> markup = _puzzle
                        .board()!
                        .cellAt(val.position!)
                        .getMarkup()!
                        .toList();

                    // 외각에 위치하는 인덱스를 확인
                    bool isEdge = index % 3 == 0 || index % 3 == 2 || index < 3 || index > 5;
                    debugPrint('index: $index, isEdge: $isEdge');

                    // 인덱스 3, 4, 5에만 상하 마진 적용
                    EdgeInsets margin = EdgeInsets.only(
                      // top: (index == 3 || index == 4 || index == 5) ? size.width(4) : 0,
                      // bottom: (index == 3 || index == 4 || index == 5) ? size.width(4) : 0,
                      left: isEdge ? 0 : size.width(3),
                      right: isEdge ? 0 : size.width(3),
                    );

                    return Container(
                      // margin: margin,
                      width: size.width(4),
                      height: size.width(6),
                      child: Text(
                        '${index + 1}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width(7),
                          height: 0,
                          fontWeight: FontWeight.w500,
                          color: markup.contains(index + 1)
                              ? ColorConfig.grey500()
                              : Colors.transparent,
                        ),
                      ),
                    );
                  },
                )

              ),
            )
          :

          /// 숫자
          Text(
              '${val.getValue() == 0 ? '' : val.getValue()}',
              style: TextStyle(
                fontSize: size.width(24),
                fontWeight: FontWeight.w500,
                height: 0,
                color: !isPrefillNum && !isEmptyNum
                    ? isCorrect
                        ? ColorConfig.grey700()
                        : ColorConfig.red()
                    : selectCell
                        ? ColorConfig.blue500()
                        : ColorConfig.grey500(),
              ),
            ),
    );
  }
}
