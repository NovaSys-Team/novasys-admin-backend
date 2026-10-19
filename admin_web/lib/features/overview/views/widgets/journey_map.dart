import 'package:flutter/material.dart';

/// A local schematic, deliberately separate from any live location service.
class JourneyMap extends StatelessWidget {
  const JourneyMap({super.key});
  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: 'Illustrative route from Nugegoda to Royal College. Sample location, not live tracking.',
    child: const CustomPaint(painter: _JourneyMapPainter()),
  );
}

class _JourneyMapPainter extends CustomPainter {
  const _JourneyMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.scale(size.width / 700, size.height / 310);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 700, 310),
      Paint()..color = const Color(0xFFEBEEE5),
    );
    final water = Path()
      ..moveTo(0, 0)
      ..lineTo(70, 0)
      ..cubicTo(40, 110, 100, 210, 65, 310)
      ..lineTo(0, 310)
      ..close();
    canvas.drawPath(water, Paint()..color = const Color(0xFFCCDDE0));
    final blockPaint = Paint()..color = const Color(0xFFDCE4D4);
    for (final rect in [
      const Rect.fromLTWH(115, 15, 90, 55),
      const Rect.fromLTWH(235, 20, 100, 55),
      const Rect.fromLTWH(350, 30, 80, 75),
      const Rect.fromLTWH(490, 180, 120, 60),
      const Rect.fromLTWH(270, 245, 80, 70),
      const Rect.fromLTWH(570, 40, 95, 85),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        blockPaint,
      );
    }
    final roads = [
      [const Offset(90, -30), const Offset(200, 340)],
      [const Offset(260, -30), const Offset(335, 340)],
      [const Offset(455, -30), const Offset(475, 340)],
      [const Offset(615, -30), const Offset(585, 340)],
      [const Offset(70, 80), const Offset(720, 110)],
      [const Offset(60, 220), const Offset(720, 260)],
      [const Offset(130, 155), const Offset(710, 165)],
      [const Offset(140, 340), const Offset(520, -20)],
    ];
    for (final road in roads) {
      canvas.drawLine(
        road.first,
        road.last,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 14,
      );
      canvas.drawLine(
        road.first,
        road.last,
        Paint()
          ..color = const Color(0xFFD8DFD4)
          ..strokeWidth = 1,
      );
    }
    _label(canvas, 'BAMBALAPITIYA', const Offset(123, 40));
    _label(canvas, 'CINNAMON GARDENS', const Offset(465, 56));
    _label(canvas, 'HAVELOCK TOWN', const Offset(356, 286));
    _label(canvas, 'Park', const Offset(510, 200));
    final route = Path()
      ..moveTo(183, 272)
      ..lineTo(168, 220)
      ..lineTo(290, 227)
      ..lineTo(276, 156)
      ..lineTo(373, 159)
      ..lineTo(430, 98)
      ..lineTo(472, 99);
    canvas.drawPath(
      route,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 13
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      route,
      Paint()
        ..color = const Color(0xFF218474)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeJoin = StrokeJoin.round,
    );
    for (final stop in [
      const Offset(183, 272),
      const Offset(276, 156),
      const Offset(472, 99),
    ]) {
      canvas.drawCircle(stop, 8, Paint()..color = const Color(0xFF218474));
      canvas.drawCircle(stop, 5, Paint()..color = Colors.white);
    }
    canvas.drawCircle(
      const Offset(340, 159),
      26,
      Paint()..color = const Color(0x22208371),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(324, 143, 32, 32),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFF163E39),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(333, 150, 14, 16),
        const Radius.circular(3),
      ),
      Paint()..color = Colors.white,
    );
    canvas.drawRect(
      const Rect.fromLTWH(335, 152, 10, 7),
      Paint()..color = const Color(0xFF163E39),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(392, 110, 145, 28),
        const Radius.circular(7),
      ),
      Paint()..color = Colors.white,
    );
    _label(
      canvas,
      'Royal College • 7 min',
      const Offset(403, 118),
      color: const Color(0xFF33574A),
      fontSize: 11,
    );
    canvas.restore();
  }

  void _label(
    Canvas canvas,
    String text,
    Offset offset, {
    Color color = const Color(0xFF87968A),
    double fontSize = 10,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Segoe UI',
          fontSize: fontSize,
          color: color,
          letterSpacing: .6,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _JourneyMapPainter oldDelegate) => false;
}
