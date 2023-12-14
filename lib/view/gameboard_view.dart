import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sudoku/state/sudoku.dart';
import 'package:sudoku/util/icon.dart';
import 'package:sudoku/util/size.dart';
import 'package:sudoku/util/theme.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'gameboard/feature_buttons.dart';
import 'gameboard/input_buttons.dart';

class GameBoardView extends StatefulWidget {
  const GameBoardView({
    super.key,
    required this.puzzle,
  });

  final Puzzle puzzle;

  @override
  State<GameBoardView> createState() => _GameBoardViewState();
}

class _GameBoardViewState extends State<GameBoardView> {
  SudokuState sudoku = Get.put(SudokuState());

  @override
  Widget build(BuildContext context) {
    SizeConfig size = SizeConfig(context);
    Puzzle _puzzle = widget.puzzle;
    return Scaffold(
      backgroundColor: ColorConfig.blue50(),
      appBar: AppBar(
        backgroundColor: ColorConfig.blue50(),
        centerTitle: true,
        title: Text(
          'SUDOKU',
          style: TextStyle(
            color: ColorConfig.grey700(),
            fontSize: size.width(20),
            fontWeight: FontWeight.w700,
            height: 0.07,
          ),
        ),
        leading: CustomIcon.backArrow(size.width(22)),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: size.width(13.5),
            ),
            child: CustomIcon.settings(size.width(24)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width(13.5),
        ),
        child: Column(
          children: [
            SizedBox(
              height: size.width(8),
            ),

            /// 일시정지, 시간, 오답갯수
            SizedBox(
              height: size.width(48),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: size.width(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomIcon.pause(
                            size.width(22),
                          ),
                          SizedBox(
                            width: size.width(6),
                          ),
                          Text(
                            '00 : 00',
                            style: TextStyle(
                              color: ColorConfig.grey500(),
                              fontSize: size.width(16),
                              fontWeight: FontWeight.w700,
                              height: 0.09,
                              letterSpacing: -0.18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Text(
                            '오답 갯수',
                            style: TextStyle(
                              color: ColorConfig.grey500(),
                              fontSize: size.width(14),
                              fontWeight: FontWeight.w700,
                              height: 0.11,
                              letterSpacing: -0.15,
                            ),
                          ),
                          SizedBox(
                            width: size.width(4),
                          ),
                          Text(
                            '4/5',
                            style: TextStyle(
                              color: ColorConfig.grey500(),
                              fontSize: size.width(14),
                              fontWeight: FontWeight.w700,
                              height: 0.11,
                              letterSpacing: -0.15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// 보드판
            SizedBox(
              width: size.width(348),
              height: size.width(348),
              child: MediaQuery.removePadding(
                context: context,
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, bIndex) {
                    /// 여기에 segment 를 넣으면 될 듯.

                    // 행과 열 계산
                    int bRow = bIndex ~/ 3;
                    int bColumn = bIndex % 3;

                    // getSegment 하면 될 줄 알았는데 더럽게 안되고있음
                    // getSegment 내부 로직을 가져와서 하니까 됨.
                    List<List<Cell>> matrix = _puzzle.board()!.matrix()!;
                    List<Cell> tmpSeg = [];

                    for (int rInc = 0; rInc < 3; rInc++) {
                      for (int cInc = 0; cInc < 3; cInc++) {
                        tmpSeg.add(
                            matrix![(bRow * 3) + rInc][(bColumn * 3) + cInc]);
                      }
                    }

                    return Container(
                      clipBehavior: Clip.hardEdge,
                      margin: EdgeInsets.all(size.width(1)),
                      width: size.width(112),
                      height: size.width(112),
                      decoration: BoxDecoration(
                        color: ColorConfig.blue100(),
                        borderRadius: BorderRadius.circular(size.width(4)),
                        border: Border.all(
                          width: size.width(2),
                          style: BorderStyle.solid,
                          color: ColorConfig.blue200(),
                        ),
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, sIndex) {
                          /// puzzle 의 getSegment 로 cell 나열하기
                          Cell val = tmpSeg[sIndex];

                          // 행과 열 계산
                          int row = sIndex ~/ 3;
                          int column = sIndex % 3;

                          // 선택된 셀의 행과 열 계산
                          int sRow = val.position!.index! ~/ 9;
                          int sColumn = val.position!.index! % 9;

                          // 선택된 셀의 인덱스
                          bool selectCell =
                              val.position!.index == sudoku.selectPixel.index;

                          // 선택된 셀과 같은 행과 열인지의 bool
                          bool selectGrid = sudoku.getSelectRow == sRow ||
                              sudoku.getSelectColumn == sColumn;

                          // 처음 게임이 생성될 때 있던 숫자인지 유저가 입력한 숫자인지의 bool
                          bool isPrefillNum =
                              _puzzle.board()!.cellAt(val.position!).prefill()!;
                          bool isEmptyNum = _puzzle
                                  .board()!
                                  .cellAt(val.position!)
                                  .getValue() ==
                              0;

                          // 입력된 셀의 숫자가 올바른 값인지의 bool
                          bool isCorrect = _puzzle
                                  .solvedBoard()!
                                  .cellAt(val.position!)
                                  .getValue() ==
                              _puzzle
                                  .board()!
                                  .cellAt(val.position!)
                                  .getValue();

                          // 마진 설정
                          EdgeInsets margin = EdgeInsets.all(size.width(1));
                          if (row == 0) margin = margin.copyWith(top: 0);
                          if (column == 0) margin = margin.copyWith(left: 0);
                          if (row == 2) margin = margin.copyWith(bottom: 0);
                          if (column == 2) margin = margin.copyWith(right: 0);

                          return InkWell(
                            onTap: () {
                              sudoku.clickPixel(val.getPosition()!);
                              sudoku.initLastInsertNum = 0;
                              setState(() {});
                            },
                            child: Container(
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
                                        color: selectGrid
                                            ? ColorConfig.blue50()
                                            : Colors.white,
                                      ),
                                borderRadius:
                                    BorderRadius.circular(size.width(4)),
                              ),
                              child: Text(
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
                                          : ColorConfig.grey400(),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: size.width(32),
            ),

            /// 인풋 버튼
            Center(
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: List.generate(9, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : size.width(5),
                      // 첫 번째 요소에는 왼쪽 패딩만 적용
                      right:
                          index == 8 ? 0 : size.width(5), // 마지막 요소에는 오른쪽 패딩만 적용
                    ),
                    child: InkWell(
                      onTap: () {
                        sudoku.insertNum = index + 1;
                        setState(() {});
                      },
                      child: InputButton(
                        text: '${index + 1}',
                        color: ColorConfig.blue300(),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: size.width(32),
            ),

            /// 지우기, 메모, 힌트 아이콘
            SizedBox(
              height: size.width(70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FeatureButton(
                    size: size,
                    icon: CustomIcon.remove(size.width(28)),
                    text: '지우기',
                  ),
                  SizedBox(
                    width: size.width(72),
                  ),
                  FeatureButton(
                    size: size,
                    icon: CustomIcon.memo(size.width(28)),
                    text: '메모',
                  ),
                  SizedBox(
                    width: size.width(72),
                  ),
                  FeatureButton(
                    size: size,
                    icon: CustomIcon.hint(size.width(28)),
                    text: '힌트',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
