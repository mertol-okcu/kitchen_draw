import 'dart:math';
import 'package:dxf/dxf.dart';
import 'package:kitchen_draw/logic/shape.dart';

extension ShapeGeometry on Shape {
  static const _touchMargin = 15;

  bool isPressedInside(double x, double y) {
    int n = knots.length;
    bool inside = false;

    if (n < 3) {
      return false;
    }

    AcDbPoint p1 = knots[0];
    for (int i = 1; i <= n; i++) {
      AcDbPoint p2 = knots[i % n];
      if (y > min(p1.y, p2.y)) {
        if (y <= max(p1.y, p2.y)) {
          if (x <= max(p1.x, p2.x)) {
            if (p1.y != p2.y) {
              double xinters =
                  (y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y) + p1.x;
              if (p1.x == p2.x || x <= xinters) {
                inside = !inside;
              }
            }
          }
        }
      }
      p1 = p2;
    }

    return inside;
  }

  int? getPressedCornerIndex(AcDbPoint point) {
    for (AcDbPoint k in knots) {
      if (_distance(point, k) <= _touchMargin) {
        return knots.indexOf(k);
      }
    }
    return null;
  }

  int? getPressedEdgeStartCornerIndex(AcDbPoint point) {
    for (int i = 0; i < knots.length; i++) {
      AcDbPoint p1 = knots[i];
      AcDbPoint p2 = knots[(i + 1) % knots.length];
      double distance = _pointToSegmentDistance(point, p1, p2);
      if (distance <= _touchMargin) {
        return i;
      }
    }
    return null;
  }

  double _pointToSegmentDistance(AcDbPoint p, AcDbPoint v, AcDbPoint w) {
    final l2 = (w.x - v.x) * (w.x - v.x) + (w.y - v.y) * (w.y - v.y);
    if (l2 == 0.0) return _distance(p, v); // v == w case
    double t = ((p.x - v.x) * (w.x - v.x) + (p.y - v.y) * (w.y - v.y)) / l2;
    t = max(0, min(1, t));
    final projection = AcDbPoint(
      x: v.x + t * (w.x - v.x),
      y: v.y + t * (w.y - v.y),
    );
    return _distance(p, projection);
  }

  double _distance(AcDbPoint p1, AcDbPoint p2) {
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
  }
}
