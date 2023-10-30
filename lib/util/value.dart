enum LineType {
  first,
  second,
  third,
  none,
}

Map<LineType, List<int>> linePosition = {
  LineType.first: [0, 1, 2],
  LineType.second: [3, 4, 5],
  LineType.third: [6, 7, 8],
  LineType.none: [],
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