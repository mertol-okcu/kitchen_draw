import 'package:kitchen_draw/enums/moving_axis.dart';

class MovingInfo {
  final int shapeIndex;
  final List<int> knotIndexes;
  final MovingAxis axis;

  MovingInfo({
    required this.shapeIndex,
    required this.knotIndexes,
    required this.axis,
  });
}
