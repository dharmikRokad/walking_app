import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:walking_app/utils/consts.dart';
import 'package:walking_app/utils/extensions/extensions.dart';

part 'walk_path_model.g.dart';

@HiveType(typeId: 1)
class WalkPathModel extends HiveObject {
  @HiveField(0)
  final List<WalkingStep> steps;

  @HiveField(1)
  final double stepDistance;

  @HiveField(2)
  final double interval;

  WalkPathModel({
    required this.steps,
    this.stepDistance = .5,
    this.interval = 1,
  });

  DateTime get initT => steps.first.timeStamp;
  DateTime get stopT => steps.last.timeStamp;
}
