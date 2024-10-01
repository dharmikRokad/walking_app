import 'package:hive/hive.dart';
import 'package:walking_app/utils/extensions/extensions.dart';

part 'walk_step_model.g.dart';

@HiveType(typeId: 2)
class WalkStepModel extends HiveObject {
  @HiveField(0)
  final List<double> coordinates;

  @HiveField(1)
  final double heading;

  @HiveField(2)
  final DateTime timeStamp;

  WalkStepModel({
    required this.coordinates,
    required this.heading,
    required this.timeStamp,
  });

  double get x => coordinates[0];
  double get y => coordinates[1];
  String get strCords => "(${x.formatted}, ${y.formatted})";
}
