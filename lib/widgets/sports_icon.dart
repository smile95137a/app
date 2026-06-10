import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

enum SportsGlyph {
  basketball,
  baseball,
  football,
  soccer,
  hockey,
  tennis,
  boxing,
  golf,
  racing,
  volleyball,
  target,
}

class SportsIcon extends StatelessWidget {
  final SportsGlyph glyph;
  final double size;
  final bool circular;

  const SportsIcon({
    super.key,
    required this.glyph,
    this.size = 56,
    this.circular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.innerCard,
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circular ? null : BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.17),
        child: CustomPaint(painter: _SportsGlyphPainter(glyph)),
      ),
    );
  }
}

class RewardGiftIcon extends StatelessWidget {
  final double size;

  const RewardGiftIcon({super.key, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: const _GiftPainter()),
    );
  }
}

class _SportsGlyphPainter extends CustomPainter {
  final SportsGlyph glyph;

  const _SportsGlyphPainter(this.glyph);

  @override
  void paint(Canvas canvas, Size size) {
    switch (glyph) {
      case SportsGlyph.basketball:
        _basketball(canvas, size);
        break;
      case SportsGlyph.baseball:
        _baseball(canvas, size);
        break;
      case SportsGlyph.football:
        _football(canvas, size);
        break;
      case SportsGlyph.soccer:
        _soccer(canvas, size);
        break;
      case SportsGlyph.hockey:
        _hockey(canvas, size);
        break;
      case SportsGlyph.tennis:
        _tennis(canvas, size);
        break;
      case SportsGlyph.boxing:
        _boxing(canvas, size);
        break;
      case SportsGlyph.golf:
        _golf(canvas, size);
        break;
      case SportsGlyph.racing:
        _racing(canvas, size);
        break;
      case SportsGlyph.volleyball:
        _volleyball(canvas, size);
        break;
      case SportsGlyph.target:
        _target(canvas, size);
        break;
    }
  }

  void _basketball(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    final ball = Paint()..color = const Color(0xFFFF6B1A);
    final line = Paint()
      ..color = const Color(0xFF181818)
      ..strokeWidth = size.width * 0.055
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(c, r, ball);
    canvas.drawLine(Offset(c.dx, 0), Offset(c.dx, size.height), line);
    canvas.drawLine(Offset(0, c.dy), Offset(size.width, c.dy), line);
    canvas.drawArc(
        Rect.fromCircle(center: Offset(-r * 0.1, c.dy), radius: r * 0.95),
        -math.pi / 2,
        math.pi,
        false,
        line);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width + r * 0.1, c.dy), radius: r * 0.95),
        math.pi / 2,
        math.pi,
        false,
        line);
  }

  void _baseball(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    final ball = Paint()..color = const Color(0xFFF8F8F8);
    final seam = Paint()
      ..color = const Color(0xFFE44B36)
      ..strokeWidth = size.width * 0.06
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final stitch = Paint()
      ..color = const Color(0xFFE44B36)
      ..strokeWidth = size.width * 0.035
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(c, r, ball);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(c.dx - r * 1.25, c.dy), radius: r * 1.35),
        -0.55,
        1.1,
        false,
        seam);
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(c.dx + r * 1.25, c.dy), radius: r * 1.35),
        math.pi - 0.55,
        1.1,
        false,
        seam);
    for (var i = 0; i < 5; i++) {
      final y = r * 0.22 + i * r * 0.36;
      canvas.drawLine(
          Offset(r * 0.43, y), Offset(r * 0.62, y + r * 0.12), stitch);
      canvas.drawLine(Offset(size.width - r * 0.43, y),
          Offset(size.width - r * 0.62, y + r * 0.12), stitch);
    }
  }

  void _football(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(size.width * 0.05, size.height * 0.2,
        size.width * 0.9, size.height * 0.6);
    final path = Path()
      ..addOval(rect)
      ..close();
    final ball = Paint()..color = const Color(0xFF9B4B2F);
    final white = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.055
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-0.78);
    canvas.translate(-size.width / 2, -size.height / 2);
    canvas.drawPath(path, ball);
    canvas.drawLine(Offset(size.width * 0.35, size.height * 0.5),
        Offset(size.width * 0.65, size.height * 0.5), white);
    for (final x in [0.43, 0.50, 0.57]) {
      canvas.drawLine(Offset(size.width * x, size.height * 0.4),
          Offset(size.width * x, size.height * 0.6), white);
    }
    canvas.restore();
  }

  void _soccer(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    final white = Paint()..color = const Color(0xFFF2F2F2);
    final dark = Paint()..color = const Color(0xFF2A2A2A);
    final line = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..strokeWidth = size.width * 0.04
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(c, r, white);
    _regularPolygon(canvas, c, r * 0.35, 5, -math.pi / 2, dark);
    for (var i = 0; i < 5; i++) {
      final a = -math.pi / 2 + i * math.pi * 2 / 5;
      final p = c + Offset(math.cos(a), math.sin(a)) * r * 0.82;
      _regularPolygon(canvas, p, r * 0.18, 5, a, dark);
      canvas.drawLine(c + Offset(math.cos(a), math.sin(a)) * r * 0.34, p, line);
    }
  }

  void _hockey(Canvas canvas, Size size) {
    final stick = Paint()
      ..color = const Color(0xFFFF7A1A)
      ..strokeWidth = size.width * 0.08
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final blade = Paint()
      ..color = const Color(0xFFBDBDBD)
      ..strokeWidth = size.width * 0.08
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final puck = Paint()..color = const Color(0xFF6F6F6F);

    canvas.drawLine(Offset(size.width * 0.68, size.height * 0.08),
        Offset(size.width * 0.34, size.height * 0.78), stick);
    canvas.drawLine(Offset(size.width * 0.34, size.height * 0.78),
        Offset(size.width * 0.78, size.height * 0.78), blade);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.82, size.height * 0.85),
            width: size.width * 0.25,
            height: size.height * 0.12),
        puck);
  }

  void _tennis(Canvas canvas, Size size) {
    final racket = Paint()
      ..color = const Color(0xFF4C70D8)
      ..strokeWidth = size.width * 0.055
      ..style = PaintingStyle.stroke;
    final grip = Paint()
      ..color = const Color(0xFFBDBDBD)
      ..strokeWidth = size.width * 0.06
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final ball = Paint()..color = const Color(0xFFD8F035);

    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.42, size.height * 0.42),
            width: size.width * 0.62,
            height: size.height * 0.74),
        racket);
    canvas.drawLine(Offset(size.width * 0.62, size.height * 0.67),
        Offset(size.width * 0.9, size.height * 0.95), grip);
    canvas.drawLine(Offset(size.width * 0.25, size.height * 0.2),
        Offset(size.width * 0.56, size.height * 0.62), racket);
    canvas.drawLine(Offset(size.width * 0.52, size.height * 0.16),
        Offset(size.width * 0.24, size.height * 0.63), racket);
    canvas.drawCircle(
        Offset(size.width * 0.18, size.height * 0.12), size.width * 0.12, ball);
  }

  void _boxing(Canvas canvas, Size size) {
    final red = Paint()..color = const Color(0xFFFF1F2D);
    final cuff = Paint()..color = const Color(0xFFFF8B1F);
    final path = Path()
      ..moveTo(size.width * 0.31, size.height * 0.22)
      ..quadraticBezierTo(size.width * 0.61, size.height * 0.0,
          size.width * 0.79, size.height * 0.25)
      ..quadraticBezierTo(size.width * 0.98, size.height * 0.54,
          size.width * 0.68, size.height * 0.7)
      ..lineTo(size.width * 0.43, size.height * 0.7)
      ..quadraticBezierTo(size.width * 0.17, size.height * 0.63,
          size.width * 0.2, size.height * 0.38)
      ..close();
    canvas.drawPath(path, red);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(size.width * 0.35, size.height * 0.66,
              size.width * 0.35, size.height * 0.18),
          Radius.circular(size.width * 0.06),
        ),
        cuff);
  }

  void _golf(Canvas canvas, Size size) {
    final green = Paint()..color = const Color(0xFF5BD64A);
    final pole = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.055
      ..style = PaintingStyle.stroke;
    final ball = Paint()..color = Colors.white;
    canvas.drawLine(Offset(size.width * 0.45, size.height * 0.16),
        Offset(size.width * 0.45, size.height * 0.82), pole);
    canvas.drawPath(
        Path()
          ..moveTo(size.width * 0.45, size.height * 0.18)
          ..lineTo(size.width * 0.76, size.height * 0.28)
          ..lineTo(size.width * 0.45, size.height * 0.38)
          ..close(),
        green);
    canvas.drawCircle(
        Offset(size.width * 0.25, size.height * 0.82), size.width * 0.09, ball);
  }

  void _racing(Canvas canvas, Size size) {
    final dark = Paint()..color = const Color(0xFF1E1E1E);
    final white = Paint()..color = Colors.white;
    final red = Paint()..color = const Color(0xFFFF4B3E);
    final path = Path()
      ..moveTo(size.width * 0.16, size.height * 0.7)
      ..lineTo(size.width * 0.3, size.height * 0.35)
      ..lineTo(size.width * 0.72, size.height * 0.35)
      ..lineTo(size.width * 0.86, size.height * 0.7)
      ..close();
    canvas.drawPath(path, red);
    canvas.drawCircle(
        Offset(size.width * 0.32, size.height * 0.72), size.width * 0.11, dark);
    canvas.drawCircle(
        Offset(size.width * 0.7, size.height * 0.72), size.width * 0.11, dark);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.43, size.height * 0.18, size.width * 0.13,
            size.height * 0.18),
        white);
  }

  void _volleyball(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    final ball = Paint()..color = const Color(0xFFF3F3F3);
    final line = Paint()
      ..color = const Color(0xFFBDBDBD)
      ..strokeWidth = size.width * 0.055
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(c, r, ball);
    for (var i = 0; i < 3; i++) {
      final angle = -math.pi / 2 + i * math.pi * 2 / 3;
      canvas.drawArc(
          Rect.fromCircle(
              center: c + Offset(math.cos(angle), math.sin(angle)) * r * 0.28,
              radius: r * 0.7),
          angle,
          math.pi * 0.95,
          false,
          line);
    }
  }

  void _target(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    for (final item in [
      (r: 0.50, c: const Color(0xFFEFEFEF)),
      (r: 0.38, c: const Color(0xFFFF3B30)),
      (r: 0.25, c: const Color(0xFFEFEFEF)),
      (r: 0.13, c: const Color(0xFFFF3B30)),
    ]) {
      canvas.drawCircle(c, size.shortestSide * item.r, Paint()..color = item.c);
    }
    final arrow = Paint()
      ..color = const Color(0xFF48D848)
      ..strokeWidth = size.width * 0.05
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width * 0.18, size.height * 0.82),
        Offset(size.width * 0.76, size.height * 0.25), arrow);
  }

  void _regularPolygon(Canvas canvas, Offset center, double radius, int sides,
      double startAngle, Paint paint) {
    final path = Path();
    for (var i = 0; i < sides; i++) {
      final a = startAngle + i * math.pi * 2 / sides;
      final p = center + Offset(math.cos(a), math.sin(a)) * radius;
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SportsGlyphPainter oldDelegate) =>
      oldDelegate.glyph != glyph;
}

class _GiftPainter extends CustomPainter {
  const _GiftPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final red = Paint()..color = const Color(0xFFFF2D2D);
    final orange = Paint()..color = const Color(0xFFFF9A19);
    const yellow = Color(0xFFFFD43B);
    final ribbon = Paint()
      ..color = yellow
      ..strokeWidth = size.width * 0.08
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.12, size.height * 0.38, size.width * 0.76,
            size.height * 0.5),
        Radius.circular(size.width * 0.08),
      ),
      red,
    );
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.45, size.height * 0.38, size.width * 0.1,
            size.height * 0.5),
        orange);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.08, size.height * 0.3, size.width * 0.84,
            size.height * 0.14),
        orange);
    canvas.drawCircle(
        Offset(size.width * 0.38, size.height * 0.24), size.width * 0.13, red);
    canvas.drawCircle(
        Offset(size.width * 0.62, size.height * 0.24), size.width * 0.13, red);
    canvas.drawLine(Offset(size.width * 0.5, size.height * 0.2),
        Offset(size.width * 0.5, size.height * 0.88), ribbon);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
