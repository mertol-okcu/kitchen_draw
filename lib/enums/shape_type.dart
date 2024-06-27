import 'package:flutter/material.dart';

enum ShapeType {
  kitchenCountertop,
  island,
}

const Map<ShapeType, double> defaultWidthForAShape = {
  ShapeType.kitchenCountertop: 25.5,
  ShapeType.island: 30.0,
};

const Map<ShapeType, Color> colorForAShape = {
  ShapeType.kitchenCountertop: Color(0xffE0D3DD),
  ShapeType.island: Color(0xffD5E0D3),
};
