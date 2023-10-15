import 'package:sudoku_api/sudoku_api.dart';

class Generator {
  void generatePuzzle() async {
    PuzzleOptions puzzleOptions = PuzzleOptions(
      patternName: "random",
      clues: 40,
    );

    Puzzle puzzle = Puzzle(puzzleOptions);

    await puzzle.generate();
    print(puzzle.board()?.getRow(0));
    print(puzzle.board()?.getColumn(1).first.getValue());
    print(puzzle.board()?.getColumn(2).first.getValue());
    print(puzzle.board()?.getColumn(3).first.getValue());
    print(puzzle.board()?.getColumn(4).first.getValue());

    print("=====================================");
    print("Your puzzle, fresh off the press:");
    print("-------------------------------------");
    printGrid(puzzle.board());
    print("=====================================");
    print("Give up? Here's your puzzle solution:");
    print("-------------------------------------");
    printGrid(puzzle.solvedBoard());
    print("=====================================");
  }
}

class GridMaker {

}