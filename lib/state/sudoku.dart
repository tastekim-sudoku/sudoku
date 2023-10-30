import 'package:get/get.dart';
import 'package:sudoku_api/sudoku_api.dart';

/// sudoku_api 내용
/// pristine: 게임보드 생성 시 미리 채워진 cell 인지 bool. true 면 빈 cell, false 면 미리 채워진 cell.
/// violated: 해당 cell 의 값이 위반되는 값인지 검사.
/// prefill: 해당 cell 에 값이 이미 존재하는지 bool.
/// markup: 해당 cell 에 메모된 값. get, set, remove, lastMarkupRemove, clear 등 있음.

class SudokuState extends GetxController {
  RxInt isSelectPixel = 81.obs;
  RxInt lastInsertNum = 0.obs;
  RxInt wrongCount = 0.obs;
  Rx<Puzzle> _puzzle = Puzzle(PuzzleOptions()).obs;

  get selectPixel => isSelectPixel.value;
  get getPuzzle => _puzzle.value;
  get getWrongCount => wrongCount.value;

  /// cell 에 숫자 입력하기
  set insertNum(int num) {
    if (selectPixel == 81) {
      return;
    }
    lastInsertNum.value = num;
    Position position = Position(index: selectPixel);

    /// 이 칸에 채울 수 있는지 검증
    bool isPrefill = _puzzle.value.board()!.cellAt(position).prefill()!;
    if (isPrefill) {
      print('already fill: ${_puzzle.value.board()!.cellAt(position).getValue()}');
      return;
    }

    // _puzzle.value.board()!.cellAt(position).addMarkup(num); <- 마크업 기능 (set type)
    
    /// 이 칸에 유효한 숫자인지 검증

    
    _puzzle.value.board()!.cellAt(position).setValue(num);

    // 유효성 검사. true이면 위반, false이면 유효한 값
    bool isRowViolated = _puzzle.value.board()!.isRowViolated(position);
    bool isColViolated = _puzzle.value.board()!.isColumnViolated(position);
    bool isSegViolated = _puzzle.value.board()!.isSegmentViolated(position);

    if (isRowViolated || isColViolated || isSegViolated) {
      wrongCount.value += 1;
    }
    // _puzzle.value.board()!.cellAt(position).setValue(num);
  }

  /// cell 에 숫자 제거하기
  void removeNum() {
    Position position = Position(index: selectPixel);
    bool isPrefill = _puzzle.value.board()!.cellAt(position).prefill()!;

    if (selectPixel == 81 || isPrefill) {
      return;
    } else {
      Position position = Position(index: selectPixel);
      _puzzle.value.board()!.cellAt(position).setValue(0);
    }
  }

  /// 스도쿠 보드 state set
  set newGame(Puzzle puz) {
    _puzzle.value = puz;
  }

  /// 클릭한 픽셀 업데이트
  void clickPixel(int index) {
    if (index == isSelectPixel.value) {
      isSelectPixel.value = 82;
    } else {
      isSelectPixel.value = index;
    }
  }

  /// 숫자 입력
  void inputNumber(int number) {
    if (selectPixel != 81) {
      print('row: ${selectPixel ~/ 9}');
      print('col: ${selectPixel % 9}');

      Position position = Position(index: selectPixel);
      print(position.grid!.x);
      print(position.grid!.y);

      var mm = _puzzle.value.board()?.toMap();
      print(mm);

      var cell = _puzzle.value?.fillCell(position, number);
      print(cell);
    }
  }

  /// 스도쿠 생성
  Future<Puzzle> generateBoard(String type) async {
    PuzzleOptions puzzleOptions = PuzzleOptions(
      patternName: type,
      clues: 60,
    );

    Puzzle puzz = Puzzle(puzzleOptions);
    await puzz.generate();
    puzz.board()!.change;

    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        // gameMap.value[i]?[j] = puzz.board()!.getRow(i)[j].getValue()!;
        /// 각 cell 별 좌표와 값
        print('${puzz.board()!.getRow(i)[j].getPosition()!.grid} : ${puzz.board()!.getRow(i)[j].getValue()!} -> ${puzz.board()!.cellAt(Position(row: i, column: j)).isPristine}');
      }
    }
    //
    // for (int i = 0; i < 9; i++) {
    //   for (int j = 0; j < 9; j++) {
    //     gameSolveMap.value[i]?[j] = puzz.solvedBoard()!.getRow(i)[j].getValue()!;
    //   }
    // }

    return puzz;
  }
}