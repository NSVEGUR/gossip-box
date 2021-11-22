import 'package:flutter/material.dart';
import 'dart:ui' as ui;

//custom painter

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffE5E5E5).withOpacity(1.0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint_0_fill);

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Colors.black.withOpacity(1.0);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height * 1.167358), paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(0, 0);
    path_2.lineTo(size.width, 0);
    path_2.lineTo(size.width, size.height);
    path_2.lineTo(0, size.height);
    path_2.lineTo(0, 0);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xff0E0C4D).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.6538462, size.height * 0.01244813),
        Offset(size.width * 1.206410, size.height * 0.4273859), [
      Color(0xff0D0B49).withOpacity(1),
      Color(0xff00327C).withOpacity(1),
      Color(0xff6155E8).withOpacity(1),
      Color(0xff745FF5).withOpacity(1),
      Color(0xffBFB3A4).withOpacity(1),
      Color(0xffFCF662).withOpacity(1)
    ], [
      0,
      0.0001,
      0.380208,
      0.526782,
      0.71875,
      0.873044
    ]);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.8397436, size.height * 0.2040111),
            width: size.width * 0.6794872,
            height: size.height * 0.3831259),
        paint_4_fill);

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.shader = ui.Gradient.linear(
        Offset(size.width * -0.6717949, size.height * 1.167358),
        Offset(size.width * 1.039449, size.height * 0.6736763), [
      Color(0xff1A2875).withOpacity(1),
      Color(0xff162B96).withOpacity(1),
      Color(0xff111C86).withOpacity(1),
      Color(0xff134DA6).withOpacity(1),
      Color(0xff1C34AF).withOpacity(1),
      Color(0xffFC9362).withOpacity(1)
    ], [
      0,
      0,
      0.0001,
      0.364583,
      0.553665,
      0.873044
    ]);

    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.09615410, size.height * 0.6773970),
            width: size.width * 0.6794872,
            height: size.height * 0.3831259),
        paint_5_fill);

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.6717949, size.height * 0.8167358),
        Offset(size.width * 1.039449, size.height * 0.6736763), [
      Color(0xff1A2875).withOpacity(1),
      Color(0xff162B96).withOpacity(1),
      Color(0xff111C86).withOpacity(1),
      Color(0xff134DA6).withOpacity(1),
      Color(0xff1C34AF).withOpacity(1),
      Color(0xffFC9362).withOpacity(1)
    ], [
      0,
      0,
      0.0001,
      0.364583,
      0.553665,
      0.873044
    ]);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.8410256, size.height * 0.7752420),
            width: size.width * 0.3384615,
            height: size.height * 0.1950207),
        paint_6_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}