import 'package:flutter/material.dart';
import 'package:sudoku/board/gameboard.dart';
import 'package:sudoku/state/sudoku.dart';
import 'package:sudoku/util/size.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'package:get/get.dart';

import 'gameboard_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void routeToGameBoard(BuildContext context, int clues) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => GameBoardView(clues: clues)),
      (route) => false,
    );
  }
  
  void showLevelDialog(BuildContext context) async {
    SizeConfig size = SizeConfig(context);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('난이도를 선택해주세요.'),
          content: SizedBox(
            height: size.width(100),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => routeToGameBoard(context, 51),
                  child: Text(
                    '쉬움',
                    style: TextStyle(fontSize: size.width(20)),
                  ),
                ),
                InkWell(
                  onTap: () => routeToGameBoard(context,42),
                  child: Text(
                    '조금 어려움',
                    style: TextStyle(fontSize: size.width(20)),
                  ),
                ),
                InkWell(
                  onTap: () => routeToGameBoard(context, 36),
                  child: Text(
                    '어려움',
                    style: TextStyle(fontSize: size.width(20)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig size = SizeConfig(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: TextButton(
              onPressed: () => showLevelDialog(context),
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
