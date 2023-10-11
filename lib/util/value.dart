enum Row {
  first,
  second,
  third,
}

enum Column {
  first,
  second,
  third,
}

Map<Row, List<int>> rowPosition = {
  Row.first: [0, 1, 2],
  Row.second: [3, 4, 5],
  Row.third: [6, 7, 8],
};

Map<Column, List<int>> columnPosition = {
  Column.first: [0, 3, 6],
  Column.second: [1, 4, 7],
  Column.third: [2, 5, 8],
};
