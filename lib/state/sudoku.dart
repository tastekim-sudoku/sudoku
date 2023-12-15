import 'package:get/get.dart';
import 'package:sudoku_api/sudoku_api.dart';

/// sudoku_api 내용
/// pristine: 게임보드 생성 시 미리 채워진 cell 인지 bool. true 면 빈 cell, false 면 미리 채워진 cell.
/// violated: 해당 cell 의 값이 위반되는 값인지 검사.
/// prefill: 해당 cell 에 값이 이미 존재하는지 bool.
/// markup: 해당 cell 에 메모된 값. get, set, remove, lastMarkupRemove, clear 등 있음.

class SudokuState extends GetxController {
  Rx<Position> isSelectPixel = Position(row: 4, column: 4).obs;
  RxInt selectIndex = 81.obs;
  RxInt selectRow = 9.obs;
  RxInt selectColumn = 9.obs;
  RxInt lastInsertNum = 0.obs;
  RxBool isWrongNum = false.obs;
  RxInt wrongCount = 0.obs;
  Rx<Puzzle> _puzzle = Puzzle(PuzzleOptions()).obs;

  get selectPixel => isSelectPixel.value;
  get getPuzzle => _puzzle.value;
  get getWrongCount => wrongCount.value;
  get getWrongSelect => isWrongNum.value;
  get getLastInsertNum => lastInsertNum.value;
  get getSelectRow => selectRow.value;
  get getSelectColumn => selectColumn.value;

  set initLastInsertNum (int num) {
    lastInsertNum.value = 0;
  }
  
  /// cell 에 숫자 입력하기
  set insertNum(int num) {
    bool isSelectedCell = selectPixel.grid.x == -2 && selectPixel.grid.y == -2;
    // 아직 선택되지 않은 상태
    if (isSelectedCell) {
      return;
    }

    // 같은 숫자를 연속으로 누르면 기존 값 삭제
    if (getLastInsertNum == num) {
      lastInsertNum.value = 0;
      removeNum();
      return;
    }

    lastInsertNum.value = num;

    // 이 칸에 채울 수 있는지 검증
    bool isPrefill = _puzzle.value.board()!.cellAt(selectPixel).prefill()!;
    if (isPrefill) {
      print('already fill: ${_puzzle.value.board()!.cellAt(selectPixel).getValue()}');
      return;
    }

    // _puzzle.value.board()!.cellAt(position).addMarkup(num); <- 마크업 기능 (set type)
    
    _puzzle.value.board()!.cellAt(selectPixel).setValue(num);

    // 유효성 검사. true이면 위반, false이면 유효한 값
    bool isRowViolated = _puzzle.value.board()!.isRowViolated(selectPixel);
    bool isColViolated = _puzzle.value.board()!.isColumnViolated(selectPixel);
    bool isSegViolated = _puzzle.value.board()!.isSegmentViolated(selectPixel);

    if (isRowViolated || isColViolated || isSegViolated) {
      isWrongNum.value = true;
      wrongCount.value += 1;
    } else {
      isWrongNum.value = false;
    }
  }

  /// cell 에 숫자 제거하기
  void removeNum() {
    bool isSelectedCell = selectPixel.grid.x == -2 && selectPixel.grid.y == -2;
    bool isPrefill = _puzzle.value.board()!.cellAt(selectPixel).prefill()!;

    if (isSelectedCell || isPrefill) {
      return;
    } else {
      _puzzle.value.board()!.cellAt(selectPixel).setValue(0);
      lastInsertNum.value = 0;
    }
  }

  /// 스도쿠 보드 state set
  set newGame(Puzzle puz) {
    _puzzle.value = puz;
  }

  /// 클릭한 픽셀 업데이트
  void clickPixel(Position position) {
    if (position.index == isSelectPixel.value.index) {
      isSelectPixel.value = Position(row: -2, column: -2);
      selectIndex.value = 81;
      selectRow.value = 9;
      selectColumn.value = 9;
    } else {
      isSelectPixel.value = position;
      selectIndex.value = position.index!;
      selectRow.value = position.index! ~/ 9;
      selectColumn.value = position.index! % 9;
    }
  }

  /// 스도쿠 생성
  Future<Puzzle> generateBoard(String type) async {
    PuzzleOptions puzzleOptions = PuzzleOptions(
      patternName: type,
      clues: 38,
    );

    Puzzle puzz = Puzzle(puzzleOptions);
    await puzz.generate();

    return puzz;
  }
}