import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudoku/util/size.dart';
import 'package:sudoku_api/sudoku_api.dart';

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
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width(20),
              ),
              child: SizedBox(
                width: size.width(350),
                height: size.width(350),
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
                        width: size.width(150),
                        height: size.width(150),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(size.width(20)),
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
                            return Container(
                              margin: EdgeInsets.all(size.width(1)),
                              width: size.width(150),
                              height: size.width(150),
                              decoration: BoxDecoration(
                                color: Colors.black,
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
