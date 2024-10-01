import 'dart:async';
import 'dart:developer';
import 'package:walking_app/entities/walk_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/hive_models/walk_step_model.dart';
import 'package:walking_app/providers/hive_helper.dart';
// import 'package:geolocator/geolocator.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider();

  bool _isLoading = false;
  Timer? _calculationTimer;

  // List<double>? _acceleroData;
  // List<double>? _magnetoData;
  // List<double>? _gyroData;

  double? _heading;

  DateTime? _startT;

  double _stepDistance = .5;

  int _deltaT = 1;
  WalkPathModel? _pathModel;
  WalkPath? _pathEntity;
  // List<WalkPath> _walkPaths = [];

  bool get isLoading => _isLoading;

  // List<double>? get acceleroData => _acceleroData;
  // List<double>? get magnetoData => _magnetoData;
  // List<double>? get gyroData => _gyroData;

  double? get heading => _heading;

  DateTime? get startT => _startT;

  double get stepDistance => _stepDistance;

  int get deltaT => _deltaT;
  WalkPathModel? get currentCycle => _pathModel;
  // List<WalkPath> get walkCycles => _walkPaths;

  bool get isStartBtnEnable => _calculationTimer == null;

  void changeLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void changeStepD(double newD) {
    _stepDistance = newD;
    notifyListeners();
  }

  // void onAcceleometerEvent(UserAccelerometerEvent newValue) {
  //   // print('data => ${{'x': newValue.x, 'y': newValue.y, 'z': newValue.z}}',
  //   //     name: 'UserAccelerometerEvent');
  //   _acceleroData = [newValue.x, newValue.y, newValue.z];
  //   notifyListeners();
  // }

  // void onGyroscopeEvent(GyroscopeEvent newValue) {
  //   // print('data => ${{'x': newValue.x, 'y': newValue.y, 'z': newValue.z}}',
  //   //     name: 'GyroScope');
  //   _gyroData = [newValue.x, newValue.y, newValue.z];
  //   notifyListeners();
  // }

  // void onMagnetometerEvent(MagnetometerEvent newValue) {
  //   // print('data => ${{'x': newValue.x, 'y': newValue.y, 'z': newValue.z}}',
  //   //     name: 'MagnetometerEvent');
  //   _magnetoData = [newValue.x, newValue.y, newValue.z];
  //   notifyListeners();
  // }

  void onCompassEvent(CompassEvent? event) {
    _heading = event?.heading;
    notifyListeners();
  }

  void onDeltaTChanged(int? value) {
    _deltaT = value ?? 1;
    notifyListeners();
  }

  void addNewPath() {
    _pathModel = WalkPathModel(
      steps: (_pathEntity?.steps
              .map(
                (e) => WalkStepModel(
                  coordinates: [e.coordinate.dx, e.coordinate.dy],
                  heading: e.heading,
                  timeStamp: e.timeStamp,
                ),
              )
              .toList()) ??
          [],
      interval: _pathEntity?.interval ?? 1,
      stepDistance: _pathEntity?.stepDistance ?? .5,
    );

    HiveHelper.instance.addWalkPath(_pathModel!);

    notifyListeners();
  }

  void onStart(VoidCallback onError) async {
    _pathEntity = WalkPath.init(
      heading: _heading!,
      interval: _deltaT.toDouble(),
      stepDistance: _stepDistance,
    );
    _startT = DateTime.now();
    _calculationTimer = Timer.periodic(
      Duration(seconds: _deltaT),
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
    _startT = null;
    _pathEntity = null;
    _pathModel = null;
    _calculationTimer = null;

    // _acceleroData = null;
    // _gyroData = null;
    // _magnetoData = null;
  }
}
