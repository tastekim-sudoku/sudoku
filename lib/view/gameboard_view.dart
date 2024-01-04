import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sudoku/state/sudoku.dart';
import 'package:sudoku/util/icon.dart';
import 'package:sudoku/util/size.dart';
import 'package:sudoku/util/theme.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'gameboard/cell_widget.dart';
import 'gameboard/feature_buttons.dart';
import 'gameboard/input_buttons.dart';

class GameBoardView extends StatefulWidget {
  const GameBoardView({
    super.key,
    required this.clues,
    // required this.puzzle,
  });

  // final Puzzle puzzle;
  final int clues;

  @override
  State<GameBoardView> createState() => _GameBoardViewState();
}

class _GameBoardViewState extends State<GameBoardView> {
  SudokuState sudoku = Get.find<SudokuState>();
  Future<Puzzle>? generateBoard;
  int _seconds = 0;
  bool _isRunning = false;
  late Timer _timer;
  bool _isHover = false;
  int _selectedInputIndex = 10;

  @override
  void initState() {
    super.initState();
    generateBoard = _generateBoard();
    _startTimer();
    // sudoku.generateBoard('random');
  }

  void _startTimer() {
    if (_isRunning) {
      _pauseTimer();
    } else {
      _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        setState(() {
          _seconds++;
        });
      });
      setState(() {
        _isRunning = true;
      });
    }
  }

  void _pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
      setState(() {
        _isRunning = false;
      });
    }
  }

  String _formatTime(int seconds) {
    int minute = seconds ~/ 60;
    int second = seconds % 60;
    return '${minute.toString().padLeft(2, '0')} : ${second.toString().padLeft(2, '0')}';
  }

  Future<Puzzle> _generateBoard() async {
    return await sudoku.generateBoard('random', widget.clues);
  }

  List<Cell> getSegment(int index) {
    // List<List<Cell>> matrix = widget.puzzle.board()!.matrix()!;
    final puzzle = sudoku.getPuzzle;
    List<List<Cell>> matrix = puzzle.board()!.matrix()!;
    List<Cell> tmpSeg = [];

    // 행과 열 계산
    int bRow = index ~/ 3;
    int bColumn = index % 3;

    for (int rInc = 0; rInc < 3; rInc++) {
      for (int cInc = 0; cInc < 3; cInc++) {
        tmpSeg.add(matrix![(bRow * 3) + rInc][(bColumn * 3) + cInc]);
      }
    }

    return tmpSeg;
  }

  SvgPicture getHintIcon(double size) {
    final hint = sudoku.getHintCount;
    if (hint == 3) {
      return CustomIcon.hintThree(size);
    }
    if (hint == 2) {
      return CustomIcon.hintTwo(size);
    }
    if (hint == 1) {
      return CustomIcon.hintOne(size);
    }
    return CustomIcon.hintAd(size);
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  Color getButtonColor(int index) {
    Puzzle puzzle = sudoku.getPuzzle;
    if (sudoku.getMemoMode) {
      return puzzle
              .board()!
              .cellAt(sudoku.selectPixel)
              .getMarkup()!
              .contains(index + 1)
          ? ColorConfig.grey200()
          : ColorConfig.blue300();
    } else {
      return sudoku.selectIndex.value != 81 &&
              puzzle.board()!.cellAt(sudoku.selectPixel).getValue() == index + 1
          ? ColorConfig.grey200()
          : ColorConfig.blue300();
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig size = SizeConfig(context);
    return FutureBuilder(
        future: generateBoard,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Puzzle _puzzle = sudoku.getPuzzle;
            Puzzle _puzzle = snapshot.data!;

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
                                  InkWell(
                                    onTap: () {
                                      if (_isRunning) {
                                        _pauseTimer();
                                      } else {
                                        _startTimer();
                                      }
                                    },
                                    child: _isRunning
                                        ? CustomIcon.pause(
                                            size.width(22),
                                          )
                                        : CustomIcon.play(
                                            size.width(22),
                                          ),
                                  ),
                                  SizedBox(
                                    width: size.width(6),
                                  ),
                                  Text(
                                    _formatTime(_seconds),
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
                                    '${sudoku.getWrongCount}/5',
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
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: 9,
                          itemBuilder: (context, bIndex) {
                            List<Cell> tmpSeg = getSegment(bIndex);

                            return Container(
                              clipBehavior: Clip.hardEdge,
                              margin: EdgeInsets.all(size.width(1)),
                              width: size.width(112),
                              height: size.width(112),
                              decoration: BoxDecoration(
                                color: ColorConfig.blue100(),
                                // borderRadius: BorderRadius.circular(size.width(4)),
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
                                  bool selectCell = val.position!.index ==
                                      sudoku.selectPixel.index;

                                  // 선택된 셀과 같은 행과 열인지의 bool
                                  bool selectGrid =
                                      sudoku.getSelectRow == sRow ||
                                          sudoku.getSelectColumn == sColumn;

                                  // 처음 게임이 생성될 때 있던 숫자인지 유저가 입력한 숫자인지의 bool
                                  bool isPrefillNum = _puzzle
                                      .board()!
                                      .cellAt(val.position!)
                                      .prefill()!;
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

                                  // 메모가 있는 셀인지의 bool
                                  bool hasMemo = _puzzle
                                      .board()!
                                      .cellAt(val.position!)
                                      .markup();

                                  // 마진 설정
                                  EdgeInsets margin =
                                      EdgeInsets.all(size.width(1));
                                  if (row == 0)
                                    margin = margin.copyWith(top: 0);
                                  if (column == 0)
                                    margin = margin.copyWith(left: 0);
                                  if (row == 2)
                                    margin = margin.copyWith(bottom: 0);
                                  if (column == 2)
                                    margin = margin.copyWith(right: 0);

                                  return InkWell(
                                    onTap: () {
                                      sudoku.clickPixel(val.getPosition()!);
                                      sudoku.initLastInsertNum = 0;
                                      setState(() {});
                                    },
                                    child: CellWidget(
                                      margin: margin,
                                      size: size,
                                      selectGrid: selectGrid,
                                      selectCell: selectCell,
                                      hasMemo: hasMemo,
                                      puzzle: _puzzle,
                                      val: val,
                                      isPrefillNum: isPrefillNum,
                                      isEmptyNum: isEmptyNum,
                                      isCorrect: isCorrect,
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
                              right: index == 8
                                  ? 0
                                  : size.width(5), // 마지막 요소에는 오른쪽 패딩만 적용
                            ),
                            child: InkWell(
                              onTapDown: (value) {
                                setState(() {
                                  _selectedInputIndex = index;
                                  _isHover = true;
                                });
                              },
                              onTapUp: (value) {
                                if (sudoku.getMemoMode) {
                                  Set<int> markup = _puzzle
                                      .board()!
                                      .cellAt(sudoku.selectPixel)
                                      .getMarkup()!;
                                  bool isPrefilled = _puzzle
                                      .board()!
                                      .cellAt(sudoku.selectPixel)
                                      .prefill()!;
                                  bool hasNum = markup.contains(index + 1);

                                  if (isPrefilled) {
                                    return;
                                  }

                                  if (hasNum) {
                                    _puzzle
                                        .board()!
                                        .cellAt(sudoku.selectPixel)
                                        .removeMarkup(index + 1);
                                  } else {
                                    _puzzle
                                        .board()!
                                        .cellAt(sudoku.selectPixel)
                                        .addMarkup(index + 1);
                                  }
                                } else {
                                  sudoku.insertNum = index + 1;
                                }
                                _isHover = false;
                                _selectedInputIndex = 10;
                                setState(() {});
                              },
                              borderRadius:
                                  BorderRadius.circular(size.width(64)),
                              child: InputButton(
                                text: '${index + 1}',
                                color: _isHover && _selectedInputIndex == index
                                    ? ColorConfig.blue200()
                                    : ColorConfig.blue300(),
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
                      width: size.width(295),
                      height: size.width(52),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              sudoku.removeNum();
                              setState(() {});
                            },
                            child: FeatureButton(
                              size: size,
                              icon: CustomIcon.undo(size.width(30)),
                              text: '되돌리기',
                            ),
                          ),
                          SizedBox(
                            width: size.width(42),
                          ),
                          InkWell(
                            onTap: () {
                              sudoku.removeNum();
                              setState(() {});
                            },
                            child: FeatureButton(
                              size: size,
                              icon: CustomIcon.remove(size.width(30)),
                              text: '지우기',
                            ),
                          ),
                          SizedBox(
                            width: size.width(42),
                          ),
                          InkWell(
                            onTap: () {
                              sudoku.memoMode();
                              setState(() {});
                            },
                            child: FeatureButton(
                              size: size,
                              icon: sudoku.getMemoMode
                                  ? CustomIcon.memoOn(size.width(30))
                                  : CustomIcon.memoOff(size.width(30)),
                              text: '메모',
                            ),
                          ),
                          SizedBox(
                            width: size.width(42),
                          ),
                          InkWell(
                            onTap: () {
                              sudoku.useHint();
                              setState(() {});
                            },
                            child: FeatureButton(
                              size: size,
                              icon: getHintIcon(size.width(30)),
                              text: '힌트',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
