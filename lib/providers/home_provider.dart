import 'dart:async';
import 'dart:developer';
import 'package:walking_app/entities/walk_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/hive_models/walk_step_model.dart';
import 'package:walking_app/utils/app_consts.dart';
import 'package:walking_app/utils/hive_helper.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider();

  bool _isLoading = false;
  Timer? _calculationTimer;

  double? _heading;

  double _stepDistance = Consts.kStepDis;

  WalkPathModel? _pathModel;

  WalkPath? _pathEntity;

  final List<WalkPathModel> _recentWalks = [];

  bool get isLoading => _isLoading;

  double? get heading => _heading;

  double get stepDistance => _stepDistance;

  WalkPathModel? get currentCycle => _pathModel;

  List<WalkPathModel> get recentWalks => _recentWalks;

  bool get isStartBtnEnable => _calculationTimer == null;

  void changeLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void changeStepD(double newD) {
    _stepDistance = newD;
    notifyListeners();
  }

  void onCompassEvent(CompassEvent? event) {
    _heading = event?.heading;
    notifyListeners();
  }

  void addNewPath() {
    _pathModel = WalkPathModel(
      steps: (_pathEntity?.steps
              .map(
                (e) => WalkStepModel(
                  coordinates: e.coordinate,
                  heading: e.heading,
                  timeStamp: e.timeStamp,
                ),
              )
              .toList()) ??
          [],
      stepDistance: _pathEntity?.stepDistance ?? _stepDistance,
      travelledDistance: _pathEntity?.travelledDistance ?? 0,
    );

    if (_recentWalks.length == 4) {
      _recentWalks.removeAt(0);
    }

    _recentWalks.add(_pathModel!);

    HiveHelper.instance.addWalkPath(_pathModel!);
    notifyListeners();
  }

  void onStart() async {
    _pathEntity = WalkPath.init(
      heading: _heading!,
      stepDistance: _stepDistance,
    );
    _calculationTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (_heading != null) {
          _pathEntity?.addStep(_heading!);
          log('added new heading');
        }
      },
    );
    notifyListeners();
  }

  void onStop() {
    _calculationTimer?.cancel();
    addNewPath();
    _resetValues();
  }

  void _resetValues() {
    _pathEntity = null;
    _pathModel = null;
    _calculationTimer = null;
  }
}
