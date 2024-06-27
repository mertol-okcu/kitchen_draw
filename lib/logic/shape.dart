import 'dart:math';

import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_draw/enums/shape_type.dart';
import 'package:kitchen_draw/logic/ac_db_entity_extensions.dart';

class Shape {
  final ShapeType type;

  final List<AcDbEntity> _entities = [];
  List<AcDbEntity> get entities => List.unmodifiable(_entities);

  final List<AcDbPoint> _knots = [];
  List<AcDbPoint> get knots => List.unmodifiable(_knots);

  Shape({
    required this.type,
    required AcDbPoint startPoint,
    required AcDbPoint endPoint,
    required double width,
  }) {
    final corners = getRectCornersFromTwoPoints(
      startPoint: startPoint,
      endPoint: endPoint,
      width: width,
    );

    for (int i = 0; i < corners.length; i++) {
      final start = corners[i];
      final end = corners[(i + 1) % corners.length];
      final edge = AcDbLine(x: start.x, y: start.y, x1: end.x, y1: end.y);
      insertEntity(entity: edge, index: i);
    }
  }

  void moveKnot({
    required int index,
    required double dx,
    required double dy,
  }) {
    final oldKnot = _entities[index].startPoint;
    final newKnot = AcDbPoint(
      x: oldKnot.x + dx,
      y: oldKnot.y + dy,
    );

    final prevIndex = (index - 1 + _entities.length) % _entities.length;
    _entities[prevIndex].setEndPoint(
      x: newKnot.x,
      y: newKnot.y,
    );

    _entities[index].setStartPoint(
      x: newKnot.x,
      y: newKnot.y,
    );

    _knots[index] = newKnot;
  }

  void insertEntity({
    required int index,
    required AcDbEntity entity,
  }) {
    if (index > _entities.length) {
      throw ErrorDescription('"index" is more than length!');
    }
    _entities.insert(index, entity);
    _knots.insert(index, entity.startPoint);
  }

  void removeEntity({
    required int index,
  }) {
    if (index >= _entities.length) {
      throw ErrorDescription('"index" does not found!');
    }
    _entities.removeAt(index);
    _knots.removeAt(index);
  }

  List<AcDbPoint> getRectCornersFromTwoPoints({
    required AcDbPoint startPoint,
    required AcDbPoint endPoint,
    required double width,
  }) {
    // Calculate the direction of the line
    double dx = endPoint.x - startPoint.x;
    double dy = endPoint.y - startPoint.y;
    double length = sqrt(dx * dx + dy * dy);

    // Calculate the perpendicular vector to the line direction
    double perpX = -dy / length;
    double perpY = dx / length;

    // Calculate the half-width offset
    double halfWidth = width / 2;

    // Calculate the corners of the rectangle
    final corner1 = AcDbPoint(
      x: startPoint.x - halfWidth * perpX,
      y: startPoint.y - halfWidth * perpY,
    );
    final corner2 = AcDbPoint(
      x: startPoint.x + halfWidth * perpX,
      y: startPoint.y + halfWidth * perpY,
    );
    final corner3 = AcDbPoint(
      x: endPoint.x + halfWidth * perpX,
      y: endPoint.y + halfWidth * perpY,
    );
    final corner4 = AcDbPoint(
      x: endPoint.x - halfWidth * perpX,
      y: endPoint.y - halfWidth * perpY,
    );

    return [corner1, corner2, corner3, corner4];
  }
}
