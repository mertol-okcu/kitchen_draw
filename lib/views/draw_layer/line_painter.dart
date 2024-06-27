part of 'draw_layer.dart';

class _LinePainter extends CustomPainter {
  final List<Shape> shapes;
  final List<int> overlappingIndexes;

  _LinePainter({
    required this.shapes,
    required this.overlappingIndexes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var shape in shapes) {
      final isOverlapping = overlappingIndexes.contains(shapes.indexOf(shape));

      final strokePaint = Paint()
        ..color = isOverlapping ? Colors.red : colorForAShape[shape.type]!
        ..strokeWidth = 2;

      for (var entity in shape.entities) {
        final start = entity.startPoint;
        final end = entity.endPoint;
        canvas.drawLine(
          Offset(start.x, start.y),
          Offset(end.x, end.y),
          strokePaint,
        );
      }

      final fillPaint = Paint()
        ..color = colorForAShape[shape.type]!.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      final path = Path()
        ..addPolygon(
          shape.knots.map((k) => Offset(k.x, k.y)).toList(),
          true,
        );

      // Draw the polygon
      canvas.drawPath(path, fillPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
