import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/gage_model.dart';

class DrawTriangle extends CustomPainter {
  WidgetRef ref;
  DrawTriangle(this.ref);

  @override
  void paint(Canvas canvas, Size size) {
    final gage = ref.watch(GageProvider).gage;
    final grey = Color.fromARGB(255, 154, 143, 154);
    final pink = Color.fromARGB(255, 225, 132, 225);
    var color1 = (gage < 1) ? grey : pink;
    var color2 = (gage < 2) ? grey : pink;
    var color3 = (gage < 3) ? grey : pink;
    var paint1 = Paint()
      ..color = color1
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    var paint2 = Paint()
      ..color = color2
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    var paint3 = Paint()
      ..color = color3
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    var path1 = Path();
    var path2 = Path();
    var path3 = Path();
    path3.moveTo(size.width / 2, 0);
    path3.lineTo(0, size.height);
    path2.moveTo(0, size.height);
    path2.lineTo(size.height, size.width);
    path1.moveTo(size.height, size.width);
    path1.lineTo(size.width / 2, 0);
    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);
    canvas.drawPath(path3, paint3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
