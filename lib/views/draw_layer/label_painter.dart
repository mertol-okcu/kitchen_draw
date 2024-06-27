part of 'draw_layer.dart';

class _LabelPainter extends CustomPainter {
  final List<Shape> shapes;

  _LabelPainter({
    required this.shapes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
    );

    for (var shape in shapes) {
      for (var entity in shape.entities) {
        final pos = entity.getLabelPoint();
        final text = entity.length.toStringAsPrecision(3);
        final textSpan = TextSpan(
          text: text,
          style: textStyle,
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );
        textPainter.layout(
          minWidth: 0,
          maxWidth: size.width,
        );
        final offset = Offset(
          pos.x - textPainter.width / 2,
          pos.y - textPainter.height / 2,
        );

        textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
