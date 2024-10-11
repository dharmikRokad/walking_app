import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:walking_app/utils/app_assets.dart';
import 'package:walking_app/utils/app_consts.dart';

class RiveAnimProvider extends ChangeNotifier {
  RiveAnimProvider();

  // Crab
  late final StateMachineController? _walkingCrabStateCtrl;
  Artboard? _walkCrabArtboard;
  late SMIBool _isCrabWalking;
  late SMIBool _isCrabsHandsJoint;

  StateMachineController? get walkingCrabStateCtrl => _walkingCrabStateCtrl;
  Artboard? get walkCrabArtboard => _walkCrabArtboard;
  bool get isCrabWalking => _isCrabWalking.value;
  bool get isCrabsHandsJoint => _isCrabsHandsJoint.value;

  Future<void> initWalkingCrab() async {
    final data = await rootBundle.load(AnimationAssets.instance.walkingCrab);

    await RiveFile.initialize();

    final riveFile = RiveFile.import(data);
    final characterBoard = riveFile.mainArtboard;

    _walkingCrabStateCtrl = StateMachineController.fromArtboard(
      characterBoard,
      Consts.kStateMachineKey,
    );

    if (_walkingCrabStateCtrl == null) {
      log('_walkingCrabStateCtrl is null');
      return;
    }

    characterBoard.addController(_walkingCrabStateCtrl);

    _walkCrabArtboard = characterBoard;
    _isCrabWalking = _walkingCrabStateCtrl.findSMI(Consts.kWalkKey);
    _isCrabsHandsJoint = _walkingCrabStateCtrl.findSMI(Consts.kHandsKey);
    notifyListeners();
  }

  void changeCrabWalk(bool newValue) {
    _isCrabWalking.change(newValue);
    notifyListeners();
  }

  void changeCrabHandsJoint(bool newValue) {
    _isCrabsHandsJoint.change(newValue);
    notifyListeners();
  }
}
