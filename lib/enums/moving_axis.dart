import 'package:dxf/dxf.dart';

enum MovingAxis {
  horizontal,
  vertical,
  free,
}

MovingAxis getMovingAxisFromVector({
  required double x,
  required double y,
}) {
  return x * x > y * y ? MovingAxis.horizontal : MovingAxis.vertical;
}

extension MovingAxisExtension on MovingAxis {
  AcDbPoint pointFromVector({
    required double x,
    required double y,
  }) {
    return AcDbPoint(
      x: this == MovingAxis.horizontal ? x : 0,
      y: this == MovingAxis.horizontal ? 0 : y,
    );
  }
}
