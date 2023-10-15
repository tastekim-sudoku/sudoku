import 'package:get/get.dart';
import 'package:sudoku_api/sudoku_api.dart';

class GameState extends GetxController {

  void generateBoard(String type) async {
    PuzzleOptions puzzleOptions = PuzzleOptions(
      patternName: type,
      clues: 25,
    );

    Puzzle puzzle = Puzzle(puzzleOptions);
    await puzzle.generate();

    List<Cell> row0 = puzzle.board()!.getRow(0);
    List<Cell> row1 = puzzle.board()!.getRow(1);
    List<Cell> row2 = puzzle.board()!.getRow(2);
    List<Cell> row3 = puzzle.board()!.getRow(3);
    List<Cell> row4 = puzzle.board()!.getRow(4);
    List<Cell> row5 = puzzle.board()!.getRow(5);
    List<Cell> row6 = puzzle.board()!.getRow(6);
    List<Cell> row7 = puzzle.board()!.getRow(7);
    List<Cell> row8 = puzzle.board()!.getRow(8);
  }
}