import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sudoku_api/sudoku_api.dart';

/// sudoku_api 내용
/// pristine: 게임보드 생성 시 미리 채워진 cell 인지 bool. true 면 빈 cell, false 면 미리 채워진 cell.
/// violated: 해당 cell 의 값이 위반되는 값인지 검사.
/// prefill: 해당 cell 에 값이 이미 존재하는지 bool.
/// markup: 해당 cell 에 메모된 값. get, set, remove, lastMarkupRemove, clear 등 있음.

class SudokuState extends GetxController {
  Rx<Position> isSelectPixel = Position(row: 4, column: 4).obs; // 선택된 셀 포지션
  RxInt selectIndex = 81.obs; // 선택된 셀 인덱스
  RxInt selectRow = 9.obs; // 선택된 셀 행
  RxInt selectColumn = 9.obs; // 선택된 셀 열
  RxBool isMemo = false.obs; // 메모 모드인지
  RxInt lastInsertNum = 0.obs; // 마지막으로 입력한 숫자
  RxBool isWrongNum = false.obs;
  RxInt wrongCount = 0.obs; // 오답 갯수
  RxInt leftHint = 3.obs; // 남은 힌트 갯수
  RxBool isHint = false.obs; // 힌트 사용 여부
  Rx<Puzzle> puzzle = Puzzle(PuzzleOptions()).obs;

  @override
  void onInit() async {
    super.onInit();
    puzzle.value = await generateBoard('random', 80);
    debugPrint('puzzle controller init');
  }

  get selectPixel => isSelectPixel.value;
  get getPuzzle => puzzle.value;
  get getWrongCount => wrongCount.value;
  get getWrongSelect => isWrongNum.value;
  get getLastInsertNum => lastInsertNum.value;
  get getSelectRow => selectRow.value;
  get getSelectColumn => selectColumn.value;
  get getMemoMode => isMemo.value;
  get getHintCount => leftHint.value;

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
    bool isPrefill = puzzle.value.board()!.cellAt(selectPixel).prefill()!;
    if (isPrefill) {
      print('already fill: ${puzzle.value.board()!.cellAt(selectPixel).getValue()}');
      return;
    }

    // _puzzle.value.board()!.cellAt(position).addMarkup(num); <- 마크업 기능 (set type)
    
    puzzle.value.board()!.cellAt(selectPixel).setValue(num);

    // 유효성 검사. true이면 위반, false이면 유효한 값
    bool isRowViolated = puzzle.value.board()!.isRowViolated(selectPixel);
    bool isColViolated = puzzle.value.board()!.isColumnViolated(selectPixel);
    bool isSegViolated = puzzle.value.board()!.isSegmentViolated(selectPixel);

    if (isRowViolated || isColViolated || isSegViolated) {
      isWrongNum.value = true;
      wrongCount.value += 1;
    } else {
      isWrongNum.value = false;
    }
  }

  /// 스도쿠 보드 state set
  set newGame(Puzzle puz) {
    puzzle.value = puz;
  }

  /// cell 에 숫자 제거하기
  void removeNum() {
    bool isSelectedCell = selectPixel.grid.x == -2 && selectPixel.grid.y == -2;
    bool isPrefill = puzzle.value.board()!.cellAt(selectPixel).prefill()!;

    if (isSelectedCell || isPrefill) {
      return;
    } else {
      puzzle.value.board()!.cellAt(selectPixel).setValue(0);
      lastInsertNum.value = 0;
    }
  }

  /// 메모 기능 활성화/비활성화
  void memoMode() {
    isMemo.value = !isMemo.value;
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

  /// 힌트 사용하기
  void useHint() {
    bool isSelectedCell = selectPixel.grid.x == -2 && selectPixel.grid.y == -2;
    // 아직 선택되지 않은 상태
    if (isSelectedCell) {
      debugPrint('선택된 셀이 없음');
      return;
    }

    // 이 칸에 채울 수 있는지 검증
    bool isPrefill = puzzle.value.board()!.cellAt(selectPixel).prefill()!;
    if (isPrefill) {
      debugPrint('이미 채워진 칸');
      return;
    }

    if (leftHint.value == 0) {
      debugPrint('힌트 없음');
      return;
    }

    int hintNum = puzzle.value.solvedBoard()!.cellAt(selectPixel).getValue()!;
    insertNum = hintNum;
    leftHint.value -= 1;
  }

  /// 스도쿠 생성
  Future<Puzzle> generateBoard(String type, int clues) async {
    PuzzleOptions puzzleOptions = PuzzleOptions(
      patternName: type,
      clues: clues,
    );

    Puzzle puzz = Puzzle(puzzleOptions);
    await puzz.generate();
    puzzle.value = puzz;

    /// 나중에 이렇게 바꿔야 할 듯?
    // puzz.board()!.startListening();
    // puzz.onBoardChange((value) {
    //
    // });

    return puzzle.value;
  }
}