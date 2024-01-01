import 'package:flutter/material.dart';
import 'package:sudoku/state/sudoku.dart';
import 'package:sudoku/view/home.dart';
import 'package:get/get.dart';

void main() {
  Get.put(SudokuState());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Pretendard',
      ),
      home: Home(),
    );
  }
}