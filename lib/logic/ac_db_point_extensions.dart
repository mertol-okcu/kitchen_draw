import 'dart:math';

import 'package:dxf/dxf.dart';

extension AcDbPointExtensions on AcDbPoint {
  AcDbPoint get normalized {
    double magnitude = sqrt(x * x + y * y);
    return AcDbPoint(x: x / magnitude, y: y / magnitude);
  }
}
