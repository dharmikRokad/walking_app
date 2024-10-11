import 'package:hive/hive.dart';
import 'package:walking_app/hive_models/walk_step_model.dart';
import 'package:walking_app/utils/app_consts.dart';

part 'walk_path_model.g.dart';

@HiveType(typeId: 1)
class WalkPathModel extends HiveObject {
  @HiveField(0)
  final List<WalkStepModel> steps;

  @HiveField(1)
  final double stepDistance;

  @HiveField(2)
  final double travelledDistance;

  WalkPathModel({
    required this.steps,
    this.stepDistance = Consts.kStepDis,
    this.travelledDistance = 0,
  });

  DateTime get iniT => steps.first.timeStamp;
  DateTime get endT => steps.last.timeStamp;
  Duration get totalTime => endT.difference(iniT);
}
