import 'package:flutter/material.dart';
import 'package:sudoku/core/generator.dart';
import 'package:sudoku/util/size.dart';
import 'package:sudoku/util/value.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  bool isStart = false;
  RowType? sRowType;
  ColumnType? sColumnType;
  RowType? bRowType;
  ColumnType? bColumnType;

  // clicked block
  int? clickedSmallBlock;
  int? clickedBigBlock;

  List<int>? connectedBlock;

  @override
  void initState() {
    Generator().generatePuzzle();
    super.initState();
  }

  /// 선택된 블럭의 row 와 column 을 기록
  void updateClickBlock(int sIndex, bIndex) {
    setState(() {
      // sRowType
      if (rowPosition[RowType.first]!.contains(sIndex)) {
        sRowType = RowType.first;
      } else if (rowPosition[RowType.second]!.contains(sIndex)) {
        sRowType = RowType.second;
      } else {
        sRowType = RowType.third;
      }
      // bRowType
      if (rowPosition[RowType.first]!.contains(bIndex)) {
        bRowType = RowType.first;
      } else if (rowPosition[RowType.second]!.contains(bIndex)) {
        bRowType = RowType.second;
      } else {
        bRowType = RowType.third;
      }

      // sColumnType
      if (columnPosition[ColumnType.first]!.contains(sIndex)) {
        sColumnType = ColumnType.first;
      } else if (columnPosition[ColumnType.second]!.contains(sIndex)) {
        sColumnType = ColumnType.second;
      } else {
        sColumnType = ColumnType.third;
      }
      // bColumnType
      if (columnPosition[ColumnType.first]!.contains(bIndex)) {
        bColumnType = ColumnType.first;
      } else if (columnPosition[ColumnType.second]!.contains(bIndex)) {
        bColumnType = ColumnType.second;
      } else {
        bColumnType = ColumnType.third;
      }
    });
  }

  /// 블럭 칼라 정의하기
  Color defSelectColor(int sIndex, bIndex) {
    if (!isStart) {
      return Colors.green;
    }

    // small row color
    if (rowPosition[sRowType]!.contains(sIndex) &&
        rowPosition[bRowType]!.contains(bIndex)) {
      return Colors.orange;
    }

    // small column color
    if (columnPosition[sColumnType]!.contains(sIndex) &&
        columnPosition[bColumnType]!.contains(bIndex)) {
      return Colors.orange;
    }

    // big row color
    if (connectedBlock != null && connectedBlock!.contains(bIndex)) {
      return Colors.lightBlueAccent;
    }

    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig size = SizeConfig(context);

    return Scaffold(
      body: Center(
        child: SizedBox(
          height: size.width(450),
          child: GridView.builder(
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, bIndex) {
              /// big block
              /// 큰 블럭의 좌표값은 x = index ~/ 3(몫), y = index % 3(나머지)
              return Container(
                width: size.width(100),
                height: size.width(100),
                margin: EdgeInsets.all(size.width(1)),
                color: Colors.amber,
                child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, sIndex) {
                    /// small block
                    return GestureDetector(
                      onTap: () {
                        print('big block : ${bIndex ~/ 3}, ${bIndex % 3}');
                        // print('small index: $sIndex');
                        updateClickBlock(sIndex, bIndex);

                        setState(() {
                          isStart = true;
                          clickedSmallBlock = sIndex;
                          clickedBigBlock = bIndex;
                          connectedBlock = connectedBigBlock[bIndex];
                        });
                      },
                      child: Container(
                        // width: size.width(100),
                        // height: size.width(100),
                        margin: EdgeInsets.all(size.width(1)),
                        color: defSelectColor(sIndex, bIndex),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
