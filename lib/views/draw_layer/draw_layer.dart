import 'package:flutter/material.dart';
import 'package:kitchen_draw/enums/shape_type.dart';
import 'package:kitchen_draw/logic/ac_db_entity_extensions.dart';
import 'package:kitchen_draw/logic/canvas_manager.dart';
import 'package:kitchen_draw/logic/export_dxf.dart';
import 'package:kitchen_draw/logic/shape.dart';
part 'line_painter.dart';
// part 'interaction_painter.dart';
part 'label_painter.dart';

class DrawLayer extends StatelessWidget {
  final CanvasManager manager;

  const DrawLayer({
    super.key,
    required this.manager,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: const Size(double.maxFinite, double.maxFinite),
          painter: _LinePainter(
            shapes: manager.shapes,
            overlappingIndexes: manager.overlappingShapeIndexes(),
          ),
        ),
        // CustomPaint(
        //   size: const Size(double.maxFinite, double.maxFinite),
        //   painter: _InteractionPainter(
        //     shapes: manager.shapes,
        //     info: manager.movingInfo,
        //   ),
        // ),
        CustomPaint(
          size: const Size(double.maxFinite, double.maxFinite),
          painter: _LabelPainter(shapes: manager.shapes),
        ),
      ],
    );
  }
}
