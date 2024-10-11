import 'dart:math' as math;
import 'package:walking_app/utils/app_consts.dart';
import 'package:walking_app/utils/extensions/extensions.dart';

class WalkPath with HeadingAndCoordinateCalculation {
  WalkPath.init({
    required double heading,
    this.stepDistance = Consts.kStepDis,
  }) {
    addStep(heading);
  }

  final double stepDistance;
  double _travelledDistance = 0;

  List<WalkingStep> steps = [];

  DateTime get iniT => steps.first.timeStamp;
  DateTime get endT => steps.last.timeStamp;
  double get travelledDistance => _travelledDistance;
  Duration get totalTime => endT.difference(iniT);

  void addStep(double heading) {
    DateTime timeStamp = DateTime.now();

    if (steps.isEmpty) {
      steps.add(
        (
          heading: heading,
          coordinate: [0, 0],
          timeStamp: timeStamp,
        ),
      );
      return;
    }

    steps.add(
      (
        heading: heading,
        timeStamp: timeStamp,
        coordinate: calculateNextCoordinate(
          steps.last.coordinate,
          stepDistance,
          heading - (steps.first.heading),
        ),
      ),
    );

    _travelledDistance += stepDistance;

    return;
  }
}

mixin HeadingAndCoordinateCalculation {
  List<double> calculateNextCoordinate(
    List<double> lastCoordinate,
    double stepDistance,
    double headingDiff,
  ) {
    double dx = stepDistance * math.sin(headingDiff.toRadian).roundToDouble();
    double dy = stepDistance * math.cos(headingDiff.toRadian).roundToDouble();

    return [lastCoordinate[0] + dx, lastCoordinate[1] + dy];
  }
}
