import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

import '../../util/size.dart';
import '../../util/theme.dart';

class CellWidget extends StatefulWidget {
  const CellWidget({
    super.key,
    required this.margin,
    required this.size,
    required this.selectGrid,
    required this.selectCell,
    required this.hasMemo,
    required Puzzle puzzle,
    required this.val,
    required this.isPrefillNum,
    required this.isEmptyNum,
    required this.isCorrect,
  }) : _puzzle = puzzle;

  final EdgeInsets margin;
  final SizeConfig size;
  final bool selectGrid;
  final bool selectCell;
  final bool hasMemo;
  final Puzzle _puzzle;
  final Cell val;
  final bool isPrefillNum;
  final bool isEmptyNum;
  final bool isCorrect;

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    );
    animation = controller
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      width: widget.size.width(36),
      height: widget.size.width(36),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.selectGrid
            ? widget.selectCell
                ? Colors.white
                : ColorConfig.blue50()
            : Colors.white,
        border: widget.selectCell
            ? Border.all(
                color: ColorConfig.blue500(),
                width: widget.size.width(2),
              )
            : Border.all(
                width: 2,
                color: widget.selectGrid ? ColorConfig.blue50() : Colors.white,
              ),
        // borderRadius: BorderRadius.circular(size.width(4)),
      ),
      child: widget.hasMemo &&
              widget._puzzle.board()!.cellAt(widget.val.position!).getValue() ==
                  0
          ? Center(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return CustomPaint(
                    foregroundPainter: BorderPainter(animation.value),
                    child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: widget.size.width(4),
                          vertical: widget.size.width(3),
                        ),
                        padding: EdgeInsets.zero,
                        // width: size.width(24),
                        // height: size.width(26),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            List<int> markup = widget._puzzle
                                .board()!
                                .cellAt(widget.val.position!)
                                .getMarkup()!
                                .toList();

                            // 외각에 위치하는 인덱스를 확인
                            bool isEdge = index % 3 == 0 ||
                                index % 3 == 2 ||
                                index < 3 ||
                                index > 5;
                            debugPrint('index: $index, isEdge: $isEdge');

                            // 인덱스 3, 4, 5에만 상하 마진 적용
                            EdgeInsets margin = EdgeInsets.only(
                              // top: (index == 3 || index == 4 || index == 5) ? size.width(4) : 0,
                              // bottom: (index == 3 || index == 4 || index == 5) ? size.width(4) : 0,
                              left: isEdge ? 0 : widget.size.width(3),
                              right: isEdge ? 0 : widget.size.width(3),
                            );

                            return SizedBox(
                              // margin: margin,
                              width: widget.size.width(4),
                              height: widget.size.width(6),
                              child: Text(
                                '${index + 1}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: widget.size.width(7.5),
                                  height: 0,
                                  fontWeight: FontWeight.w500,
                                  color: markup.contains(index + 1)
                                      ? ColorConfig.grey500()
                                      : Colors.transparent,
                                ),
                              ),
                            );
                          },
                        )),
                  );
                },
              ),
            )
          :

          /// 숫자
          Text(
              '${widget.val.getValue() == 0 ? '' : widget.val.getValue()}',
              style: TextStyle(
                fontSize: widget.size.width(24),
                fontWeight: FontWeight.w500,
                height: 0,
                color: !widget.isPrefillNum && !widget.isEmptyNum
                    ? widget.isCorrect
                        ? ColorConfig.grey700()
                        : ColorConfig.red()
                    : widget.selectCell
                        ? ColorConfig.blue500()
                        : ColorConfig.grey500(),
              ),
            ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final double controller;

  BorderPainter(this.controller);

  @override
  void paint(Canvas canvas, Size size) {
    double _sh = size.height; // For path shortage
    double _sw = size.width; // For path shortage
    double _line = 30.0; // Length of the animated line
    double _c1 = controller * 2; // Controller value for top and left border.
    double _c2 = controller >= 0.5
        ? (controller - 0.5) * 2
        : 0; // Controller value for bottom and right border.

    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    Path _top = Path()
      ..moveTo(_sw * _c1 > _sw ? _sw : _sw * _c1, 0)
      ..lineTo(_sw * _c1 + _line >= _sw ? _sw : _sw * _c1 + _line, 0);

    Path _left = Path()
      ..moveTo(0, _sh * _c1 > _sh ? _sh : _sh * _c1)
      ..lineTo(0, _sh * _c1 + _line >= _sh ? _sh : _sh * _c1 + _line);

    Path _right = Path()
      ..moveTo(_sw, _sh * _c2)
      ..lineTo(
          _sw,
          _sh * _c2 + _line > _sh
              ? _sh
              : _sw * _c1 + _line >= _sw
                  ? _sw * _c1 + _line - _sw
                  : _sh * _c2);

    Path _bottom = Path()
      ..moveTo(_sw * _c2, _sh)
      ..lineTo(
          _sw * _c2 + _line > _sw
              ? _sw
              : _sh * _c1 + _line >= _sh
                  ? _sh * _c1 + _line - _sh
                  : _sw * _c2,
          _sh);

    canvas.drawPath(_top, paint);
    canvas.drawPath(_left, paint);
    canvas.drawPath(_right, paint);
    canvas.drawPath(_bottom, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
