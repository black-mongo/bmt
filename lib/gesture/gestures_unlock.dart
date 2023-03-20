import 'dart:async';
import 'dart:ui';

import 'package:bmt/gesture/coordinate.dart';
import 'package:bmt/gesture/unlock_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GesturesUnlock extends StatefulWidget {
  final String textSuccessShow;
  final String textErrorShow;
  final Color colorError;
  final String textPrepareShow;
  final Function(String) onCheckPassword;
  const GesturesUnlock(
      {Key? key,
      this.textSuccessShow = "密码正确",
      this.textErrorShow = "密码错误,请重新输入",
      this.textPrepareShow = "请输入手势密码",
      required this.onCheckPassword,
      this.colorError = Colors.red})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GesturesUnlockState createState() => _GesturesUnlockState();
}

class _GesturesUnlockState extends State<GesturesUnlock>
    with SingleTickerProviderStateMixin {
  final UnlockController _unlockController = UnlockController();
  List<PassWord> centerOffset = <PassWord>[];
  double size = 300;

  // ignore: prefer_final_fields
  late AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  late CurvedAnimation curvedAnimation =
      CurvedAnimation(curve: Curves.easeIn, parent: _animationController);
  late Animation<double> animation =
      Tween(begin: 0.0, end: 10.0).animate(curvedAnimation)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _animationController.reset();
          }
        });

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    text = widget.textPrepareShow;
    // 上面
    centerOffset.add(PassWord(1, Offset(-size / 3, -size / 3)));
    centerOffset.add(PassWord(2, Offset(-size / 3 + size / 3, -size / 3)));
    centerOffset.add(PassWord(3, Offset(-size / 3 + size / 3 * 2, -size / 3)));

    // 中间
    centerOffset.add(PassWord(4, Offset(-size / 3, 0)));
    centerOffset.add(PassWord(5, Offset(-size / 3 + size / 3, 0)));
    centerOffset.add(PassWord(6, Offset(-size / 3 + size / 3 * 2, 0)));

    // 上面
    centerOffset.add(PassWord(7, Offset(-size / 3, size / 3)));
    centerOffset.add(PassWord(8, Offset(-size / 3 + size / 3, size / 3)));
    centerOffset.add(PassWord(9, Offset(-size / 3 + size / 3 * 2, size / 3)));
  }

  Color textColor = Colors.black87;
  String text = "";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
                animation: animation,
                builder: (ctx, child) {
                  return Container(
                    margin: EdgeInsetsDirectional.only(
                        bottom: 20,
                        start: _errorPwd() * 20,
                        end: animation.value),
                    child: Text(
                      text,
                      style: TextStyle(fontSize: 20, color: textColor),
                    ),
                  );
                }),
            GestureDetector(
              child: CustomPaint(
                size: Size(size, size),
                painter:
                    _GesturesUnlockPainter(_unlockController, centerOffset),
              ),
              onPanDown: (d) {
                // 手指按下
                judgeZone(d.localPosition);
              },
              onPanUpdate: (d) {
                // 移动
                judgeZone(d.localPosition);
                if (_unlockController.points.isNotEmpty) {
                  _unlockController.currentOffset =
                      d.localPosition.translate(-size / 2, -size / 2);
                }
              },
              onPanEnd: (d) {
                String pwd = "";
                for (int i = 0; i < _unlockController.points.length; i++) {
                  pwd += _unlockController.points[i].num.toString();
                }
                if (!widget.onCheckPassword(pwd)) {
                  _unlockController.color = widget.colorError;
                  Timer(const Duration(milliseconds: 500), () {
                    _unlockController.clearAllPoint();
                    _unlockController.currentOffset = null;
                    _unlockController.resetColor();
                  });
                  // 密码错误 触发交互
                  _animationController.forward();
                  textColor = widget.colorError;
                  text = widget.textErrorShow;
                } else {
                  _unlockController.clearAllPoint();
                  _unlockController.currentOffset = null;
                  setState(() {
                    textColor = Colors.black87;
                    text = widget.textSuccessShow;
                  });
                }
              },
            )
          ],
        ));
  }

  double _errorPwd() {
    double x = animation.value; // 变化速度 0-10,
    double d = x - x.truncate(); // 获取这个数字的小数部分
    double? y;
    if (d <= 0.5) {
      y = 2 * d;
    } else {
      y = 1 - 2 * (d - 0.5);
    }
    return y;
  }

  ///手指按下触发
  void judgeZone(Offset src) {
    /// 循环所有的点
    for (int i = 0; i < centerOffset.length; i++) {
      var srcTranslate = src.translate(-size / 2, -size / 2);
      // 判断手指按的位置是否在点的区域
      if (judgeCircleArea(srcTranslate, centerOffset[i].offset, 30)) {
        // 有点 判断是否已添加过
        for (int j = 0; j < _unlockController.points.length; j++) {
          if (_unlockController.points[j] == centerOffset[i]) {
            // 已添加过
            return;
          }
        }
        // 未添加过
        _unlockController.addPoint(centerOffset[i]);
        return;
      }
    }
    // 无点
  }

  ///判断出是否在某点的半径为r圆范围内
  bool judgeCircleArea(Offset src, Offset dst, double r) =>
      (src - dst).distance <= r;
}

Coordinate coordinate = Coordinate(setP: 20);

class _GesturesUnlockPainter extends CustomPainter {
  final UnlockController unlockController;
  final List<PassWord> centerOffset;

  _GesturesUnlockPainter(
    this.unlockController,
    this.centerOffset,
  ) : super(repaint: unlockController);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    // coordinate.paintT(canvas, size);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = const Color.fromARGB(221, 83, 197, 197);
    // canvas.drawRect(
    //     Rect.fromCenter(center: Offset.zero, width: 300, height: 300), paint);
    // 绘制辅助区域
    // _drawHelpRect(canvas, size, paint);
    // 绘制圆
    _drawCirCle(canvas, size, paint);

    // 绘制辅助点
    // canvas.drawPoints(
    //     PointMode.points,
    //     centerOffset,
    //     paint
    //       ..strokeWidth = 5
    //       ..color = Colors.black87
    //       ..strokeCap = StrokeCap.round);
    var offsets = unlockController.points.map((e) => e.offset).toList();
    // 绘制按压点
    canvas.drawPoints(
        PointMode.points,
        offsets,
        paint
          ..strokeWidth = 20
          ..strokeCap = StrokeCap.round
          ..color = unlockController.color);

    // 绘制当前手势线

    // 绘制密码
    Path path = Path();
    if (unlockController.points.isNotEmpty) {
      path.moveTo(unlockController.points[0].offset.dx,
          unlockController.points[0].offset.dy);
      if (unlockController.currentOffset != null) {
        canvas.drawLine(unlockController.points.last.offset,
            unlockController.currentOffset!, paint..strokeWidth = 4);
      }
    }
    for (int i = 1; i < unlockController.points.length; i++) {
      path.lineTo(unlockController.points[i].offset.dx,
          unlockController.points[i].offset.dy);
    }
    canvas.drawPath(path, paint..strokeWidth = 4);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  // ignore: unused_element
  void _drawHelpRect(Canvas canvas, Size size, Paint paint) {
    for (int i = 0; i < centerOffset.length; i++) {
      canvas.drawRect(
          Rect.fromCenter(
              center: centerOffset[i].offset, width: 100, height: 100),
          paint);
    }
  }

  void _drawCirCle(Canvas canvas, Size size, Paint paint) {
    for (int i = 0; i < centerOffset.length; i++) {
      canvas.drawCircle(centerOffset[i].offset, 30,
          paint..color = const Color.fromARGB(221, 75, 73, 73));
    }
    for (int j = 0; j < unlockController.points.length; j++) {
      canvas.drawCircle(unlockController.points[j].offset, 30,
          paint..color = unlockController.color);
    }
  }
}
