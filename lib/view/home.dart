import 'package:flutter/material.dart';
import 'package:sudoku/board/gameboard.dart';
import 'package:sudoku/state/sudoku.dart';
import 'package:sudoku/util/size.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SudokuState sudoku = Get.put(SudokuState());

  @override
  Widget build(BuildContext context) {
    SizeConfig size = SizeConfig(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FutureBuilder(
                        future: SudokuState().generateBoard('random'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Puzzle puzzle = snapshot.data!;
                            sudoku.newGame = puzzle;
                            return GameBoard(
                              puzzle: puzzle,
                            );
                          }
                          return CircularProgressIndicator();
                        }),
                  ),
                  (route) => false,
                );
              },
              child: Text(
                'start',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size.width(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
