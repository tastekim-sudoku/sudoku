enum RowType {
  first,
  second,
  third,
}

enum ColumnType {
  first,
  second,
  third,
}

Map<RowType, List<int>> rowPosition = {
  RowType.first: [0, 1, 2],
  RowType.second: [3, 4, 5],
  RowType.third: [6, 7, 8],
};

Map<ColumnType, List<int>> columnPosition = {
  ColumnType.first: [0, 3, 6],
  ColumnType.second: [1, 4, 7],
  ColumnType.third: [2, 5, 8],
};

Map<int, List<int>> connectedBigBlock = {
  0: [0, 1, 2, 3, 6],
  1: [0, 1, 2, 4, 7],
  2: [0, 1, 2, 5, 8],
  3: [0, 3, 4, 5, 6],
  4: [1, 3, 4, 5, 7],
  5: [2, 3, 4, 5, 8],
  6: [0, 3, 6, 7, 8],
  7: [1, 4, 6, 7, 8],
  8: [2, 5, 6, 7, 8],
};