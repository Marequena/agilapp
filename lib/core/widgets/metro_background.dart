import 'package:flutter/material.dart';

class MetroBackground extends StatelessWidget {
  const MetroBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _MetroBgPainter(),
      ),
    );
  }
}

class _MetroBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = const LinearGradient(colors: [Color(0xFFE8F1FF), Color(0xFFF7F9FC)], begin: Alignment.topLeft, end: Alignment.bottomRight)
          .createShader(rect);
    canvas.drawRect(rect, paint);

    final block = Paint()..color = const Color(0xFF7E57C2).withAlpha(44);
    final r = Rect.fromLTWH(size.width * 0.6, size.height * 0.05, size.width * 0.35, size.height * 0.28);
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(12)), block);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
