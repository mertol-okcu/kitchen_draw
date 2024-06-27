import 'dart:math';

import 'package:dxf/dxf.dart';
import 'package:flutter/material.dart';
import 'package:kitchen_draw/logic/ac_db_point_extensions.dart';
import 'package:kitchen_draw/logic/geometry_functions.dart';

extension AcDbEntityExtensions on AcDbEntity {
  AcDbPoint get startPoint {
    if (this is AcDbLine) {
      return AcDbPoint(
        x: (this as AcDbLine).x,
        y: (this as AcDbLine).y,
      );
    } else {
      throw ErrorDescription("Entity type does not defined for this function!");
    }
  }

  AcDbPoint get endPoint {
    if (this is AcDbLine) {
      return AcDbPoint(
        x: (this as AcDbLine).x1,
        y: (this as AcDbLine).y1,
      );
    } else {
      throw ErrorDescription("Entity type does not defined for this function!");
    }
  }

  double get length {
    if (this is AcDbLine) {
      final line = (this as AcDbLine);
      final dx = line.x1 - line.x;
      final dy = line.y1 - line.y;
      return sqrt(dx * dx + dy * dy);
    } else {
      throw ErrorDescription("Entity type does not defined for this function!");
    }
  }

  void setStartPoint({
    required double x,
    required double y,
  }) {
    if (this is AcDbLine) {
      (this as AcDbLine).x = x;
      (this as AcDbLine).y = y;
    } else {
      throw ErrorDescription("Entity type does not defined for this function!");
    }
  }

  void setEndPoint({
    required double x,
    required double y,
  }) {
    if (this is AcDbLine) {
      (this as AcDbLine).x1 = x;
      (this as AcDbLine).y1 = y;
    } else {
      throw ErrorDescription("Entity type does not defined for this function!");
    }
  }

  AcDbPoint getLabelPoint() {
    if (this is AcDbLine) {
      final start = startPoint;
      final end = endPoint;
      final perp = getPerpendicularFromTwoPoints(start, end).normalized;
      const perpDist = 20;

      final middle = AcDbPoint(
        x: start.x * 0.5 + end.x * 0.5,
        y: start.y * 0.5 + end.y * 0.5,
      );
      return AcDbPoint(
        x: middle.x + perp.x * perpDist,
        y: middle.y + perp.y * perpDist,
      );
    } else {
      throw ErrorDescription("Entity type does not defined for this function!");
    }
  }
}
