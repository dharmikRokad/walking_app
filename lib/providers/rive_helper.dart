import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:walking_app/utils/app_assets.dart';
import 'package:walking_app/utils/app_consts.dart';

class RiveHelper extends ChangeNotifier {
  RiveHelper() {
    initWalkingMan();
  }

  late final StateMachineController? _walkingManStateCtrl;
  Artboard? _walkManArtboard;
  late SMITrigger _walkingSwitch;

  StateMachineController? get walkingStateCtrl => _walkingManStateCtrl;
  Artboard? get walkmanArtboard => _walkManArtboard;
  bool get isWalking => _walkingSwitch.value;

  Future<void> initWalkingMan() async {
    final data = await rootBundle.load(AnimationAssets.instance.walkingMan);

    final riveFile = RiveFile.import(data);
    final characterBoard = riveFile.mainArtboard;

    _walkingManStateCtrl = StateMachineController.fromArtboard(
      characterBoard,
      Consts.kStateMachineKey,
    );

    if (_walkingManStateCtrl == null) {
      log('_walkingManStateCtrl is null');
      return;
    }

    characterBoard.addController(_walkingManStateCtrl);

    _walkManArtboard = characterBoard;
    _walkingSwitch = _walkingManStateCtrl.findSMI(Consts.kSwitchKey);
    notifyListeners();
  }

  void changeWalkSwitch(bool value) {
    _walkingSwitch.change(value);
    notifyListeners();
  }
}
