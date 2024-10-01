import 'dart:math' as math;
import 'package:walking_app/utils/consts.dart';
import 'package:walking_app/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class WalkPath with HeadingAndCoordinateCalculation {
  WalkPath.init({
    required double heading,
    this.stepDistance = 1,
    this.interval = 1,
  }) {
    addStep(heading);
  }

  final double stepDistance;
  final double interval;

  List<WalkingStep> steps = [];

  DateTime get iniT => steps.first.timeStamp;
  DateTime get endT => steps.last.timeStamp;

  void addStep(double heading) {
    DateTime timeStamp = DateTime.now();

    if (steps.isEmpty) {
      steps.add(
        (
          heading: heading,
          coordinate: const Offset(0, 0),
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

    return;
  }
}

mixin HeadingAndCoordinateCalculation {
  Offset calculateNextCoordinate(
    Offset lastCoordinate,
    double stepDistance,
    double headingDiff,
  ) {
    double dx = stepDistance * math.sin(headingDiff.toRadian);
    double dy = stepDistance * math.cos(headingDiff.toRadian);

    return Offset(lastCoordinate.dx + dx, lastCoordinate.dy + dy);
  }
}
