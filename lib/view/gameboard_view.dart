import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/util/icon.dart';
import 'package:sudoku/util/size.dart';
import 'package:sudoku/util/theme.dart';
import 'package:sudoku_api/sudoku_api.dart';

import '';
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
                  itemBuilder: (context, index) {
                    /// 여기에 segment 를 넣으면 될 듯.
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
                        itemBuilder: (context, index) {
                          /// puzzle 의 getSegment 로 cell 나열하기
                          // 행과 열 계산
                          int row = index ~/ 3;
                          int column = index % 3;

                          // 마진 설정
                          EdgeInsets margin = EdgeInsets.all(size.width(1));
                          if (row == 0) margin = margin.copyWith(top: 0);
                          if (column == 0) margin = margin.copyWith(left: 0);
                          if (row == 2) margin = margin.copyWith(bottom: 0);
                          if (column == 2) margin = margin.copyWith(right: 0);

                          return Container(
                            margin: margin,
                            width: size.width(36),
                            height: size.width(36),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(size.width(4)),
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
            Center(
              child: Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: List.generate(9, (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 0 : size.width(5), // 첫 번째 요소에는 왼쪽 패딩만 적용
                      right: index == 8 ? 0 : size.width(5), // 마지막 요소에는 오른쪽 패딩만 적용
                    ),
                    child: InputButton(
                      text: '${index + 1}',
                      color: ColorConfig.blue300(),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: size.width(32),
            ),
            /// 지우기, 메모, 힌트 아이콘
          ],
        ),
      ),
    );
  }
}
