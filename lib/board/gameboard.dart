import 'package:flutter/material.dart';
import 'package:sudoku/util/size.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {


  @override
  Widget build(BuildContext context) {
    SizeConfig size = SizeConfig(context);
    
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: size.width(450),
          child: GridView.builder(
            itemCount: 9,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, bIndex) {
              /// big block
              /// 큰 블럭의 좌표값은 x = index ~/ 3(몫), y = index % 3(나머지)
              return Container(
                width: size.width(100),
                height: size.width(100),
                margin: EdgeInsets.all(1),
                color: Colors.amber,
                child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, sIndex) {
                    /// small block
                    return GestureDetector(
                      onTap: () {
                        print('big block : ${bIndex ~/ 3}, ${bIndex % 3}');
                        print('small index: $sIndex');
                      },
                      child: Container(
                        // width: size.width(100),
                        // height: size.width(100),
                        margin: EdgeInsets.all(1),
                        color: Colors.green,
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
