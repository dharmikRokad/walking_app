import 'package:hive/hive.dart';
import 'package:walking_app/hive_models/walk_step_model.dart';

part 'walk_path_model.g.dart';

@HiveType(typeId: 1)
class WalkPathModel extends HiveObject {
  @HiveField(0)
  final List<WalkStepModel> steps;

  @HiveField(1)
  final double stepDistance;

  WalkPathModel({
    required this.steps,
    this.stepDistance = .5,
  });

  DateTime get initT => steps.first.timeStamp;
  DateTime get stopT => steps.last.timeStamp;
}
