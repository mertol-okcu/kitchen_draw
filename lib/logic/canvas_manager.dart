import 'package:dxf/dxf.dart';
import 'package:flutter/foundation.dart';
import 'package:kitchen_draw/enums/moving_axis.dart';
import 'package:kitchen_draw/enums/shape_type.dart';
import 'package:kitchen_draw/logic/geometry_functions.dart';
import 'package:kitchen_draw/logic/moving_info.dart';
import 'package:kitchen_draw/logic/shape.dart';
import 'package:kitchen_draw/logic/shape_geometry.dart';

class CanvasManager extends ChangeNotifier {
  final List<Shape> _shapes = [];
  List<Shape> get shapes => List.unmodifiable(_shapes);

  ShapeType _selectedShapeType = ShapeType.kitchenCountertop;
  ShapeType get selectedShapeType => _selectedShapeType;

  set selectedShapeType(ShapeType type) {
    _selectedShapeType = type;
    notifyListeners();
  }

  MovingInfo? _movingInfo;
  MovingInfo? get movingInfo => _movingInfo;

  void onPanDown({
    required double x,
    required double y,
  }) {
    final point = AcDbPoint(x: x, y: y);

    // Check if any corner pressed
    // for (var shape in _shapes) {
    //   final cornerIndex = shape.getPressedCornerIndex(point);
    //   if (cornerIndex != null) {
    //     _movingInfo = MovingInfo(
    //       shapeIndex: _shapes.indexOf(shape),
    //       knotIndexes: [cornerIndex],
    //       axis: null,
    //     );
    //     return;
    //   }
    // }

    // Check if any edge pressed
    for (var shape in _shapes) {
      final edgeStartIndex = shape.getPressedEdgeStartCornerIndex(point);
      if (edgeStartIndex != null) {
        final edgeEndIndex = (edgeStartIndex + 1) % shape.entities.length;
        final perp = getPerpendicularFromTwoPoints(
          shape.knots[edgeStartIndex],
          shape.knots[edgeEndIndex],
        );
        final axis = getMovingAxisFromVector(x: perp.x, y: perp.y);
        _movingInfo = MovingInfo(
          shapeIndex: _shapes.indexOf(shape),
          knotIndexes: [edgeEndIndex, edgeStartIndex],
          axis: axis,
        );
        return;
      }
    }

    // Check if any shape pressed
    for (var shape in _shapes) {
      if (shape.isPressedInside(x, y)) {
        _movingInfo = MovingInfo(
          shapeIndex: _shapes.indexOf(shape),
          knotIndexes: List.generate(shape.entities.length, (i) => i),
          axis: MovingAxis.free,
        );
        return;
      }
    }

    notifyListeners();
  }

  void onPanUpdate({
    required double dx,
    required double dy,
    required double x,
    required double y,
  }) {
    // If no shape pressed, create new shape on pan update
    if (_movingInfo == null) {
      final movingAxis = getMovingAxisFromVector(x: dx, y: dy);
      final AcDbPoint startPoint = movingAxis.pointFromVector(x: dx, y: dy);

      final shape = Shape(
        type: _selectedShapeType,
        startPoint: AcDbPoint(x: x - startPoint.x, y: y - startPoint.y),
        endPoint: AcDbPoint(x: x, y: y),
        width: defaultWidthForAShape[_selectedShapeType]!,
      );
      _shapes.add(shape);
      final shapeIndex = _shapes.length - 1;
      _movingInfo = MovingInfo(
        shapeIndex: shapeIndex,
        knotIndexes: [shape.entities.length - 2, shape.entities.length - 1],
        axis: movingAxis,
      );
    } else {
      for (var index in _movingInfo!.knotIndexes) {
        _shapes[_movingInfo!.shapeIndex].moveKnot(
          index: index,
          dx: _movingInfo!.axis == MovingAxis.vertical ? 0 : dx,
          dy: _movingInfo!.axis == MovingAxis.horizontal ? 0 : dy,
        );
      }
    }

    notifyListeners();
  }

  void onPanRelease() {
    _movingInfo = null;
    notifyListeners();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
