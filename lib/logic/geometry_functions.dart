import 'package:dxf/dxf.dart';

AcDbPoint getPerpendicularFromTwoPoints(AcDbPoint p1, AcDbPoint p2) {
  double vx = p2.x - p1.x;
  double vy = p2.y - p1.y;
  return AcDbPoint(x: -vy, y: vx);
}

bool arePolygonsOverlapping(
  List<AcDbPoint> polygon1,
  List<AcDbPoint> polygon2,
) {
  List<double> projectPolygonOnAxis(List<AcDbPoint> polygon, AcDbPoint axis) {
    double min = double.infinity;
    double max = double.negativeInfinity;
    for (var point in polygon) {
      double projection = (point.x * axis.x + point.y * axis.y) /
          (axis.x * axis.x + axis.y * axis.y);
      if (projection < min) {
        min = projection;
      }
      if (projection > max) {
        max = projection;
      }
    }
    return [min, max];
  }

  // Function to check if two projections overlap
  bool isProjectionOverlapping(
      List<double> projection1, List<double> projection2) {
    return projection1[1] >= projection2[0] && projection2[1] >= projection1[0];
  }

  // Function to get all the edges of a polygon
  List<AcDbPoint> getEdges(List<AcDbPoint> polygon) {
    List<AcDbPoint> edges = [];
    for (int i = 0; i < polygon.length; i++) {
      AcDbPoint p1 = polygon[i];
      AcDbPoint p2 = polygon[(i + 1) % polygon.length];
      edges.add(AcDbPoint(x: p2.x - p1.x, y: p2.y - p1.y));
    }
    return edges;
  }

  // Function to get the perpendicular axis of an edge
  AcDbPoint getPerpendicularAxis(AcDbPoint edge) {
    return AcDbPoint(x: -edge.y, y: edge.x);
  }

  // Check for overlap using the Separating Axis Theorem (SAT)
  List<AcDbPoint> edges1 = getEdges(polygon1);
  List<AcDbPoint> edges2 = getEdges(polygon2);

  List<AcDbPoint> axes = [];
  for (var edge in edges1) {
    axes.add(getPerpendicularAxis(edge));
  }
  for (var edge in edges2) {
    axes.add(getPerpendicularAxis(edge));
  }

  for (var axis in axes) {
    List<double> projection1 = projectPolygonOnAxis(polygon1, axis);
    List<double> projection2 = projectPolygonOnAxis(polygon2, axis);
    if (!isProjectionOverlapping(projection1, projection2)) {
      return false; // Found a separating axis, so the polygons do not overlap
    }
  }
  return true; // No separating axis found, so the polygons overlap
}
