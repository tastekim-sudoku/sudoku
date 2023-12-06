import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/util/size.dart';
import 'package:sudoku/util/theme.dart';
import 'package:sudoku_api/sudoku_api.dart';

import '';

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConfig.blue50(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width(13.5),
              ),
              child: SizedBox(
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
            ),
          ],
        ),
      ),
    );
  }
}
