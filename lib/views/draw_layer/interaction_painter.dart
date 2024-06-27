// part of 'draw_layer.dart';

// class _InteractionPainter extends CustomPainter {
//   final List<Shape> shapes;
//   final MovingInfo? info;

//   _InteractionPainter({
//     required this.shapes,
//     required this.info,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (info == null) {
//       return;
//     }

//     final paint = Paint()
//       ..color = Colors.teal.withOpacity(0.4)
//       ..strokeWidth = 6.0;

//     final shape = shapes[info!.shapeIndex];
//     late final List<AcDbEntity> activeEntities;

//     if (info!.knotIndexes.length == 2) {
//       final sortedIndexes = [...info!.knotIndexes];
//       sortedIndexes.sort((a, b) => a.compareTo(b));
//       activeEntities = shape.entities
//           .where(
//             (e) => shape.entities.indexOf(e) == sortedIndexes.first,
//           )
//           .toList();
//     } else {
//       activeEntities = shape.entities;
//     }

//     final axis = info!.axis;

//     for (var entity in activeEntities) {
//       final start = entity.startPoint;
//       final end = entity.endPoint;
//       canvas.drawLine(
//         Offset(start.x, start.y),
//         Offset(end.x, end.y),
//         paint,
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
