import 'package:flutter/material.dart';
import 'package:kitchen_draw/logic/canvas_manager.dart';

class GestureLayer extends StatelessWidget {
  final CanvasManager manager;

  const GestureLayer({
    super.key,
    required this.manager,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) => manager.onPanDown(
        x: details.localPosition.dx,
        y: details.localPosition.dy,
      ),
      onPanUpdate: (details) => manager.onPanUpdate(
        dx: details.delta.dx,
        dy: details.delta.dy,
        x: details.localPosition.dx,
        y: details.localPosition.dy,
      ),
      onPanCancel: () => manager.onPanRelease(),
      onPanEnd: (details) => manager.onPanRelease(),
      child: Container(
        color: Colors.transparent,
        width: double.maxFinite,
        height: double.maxFinite,
      ),
    );
  }
}
