import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/hive_models/walk_step_model.dart';
import 'package:walking_app/utils/app_consts.dart';

class HiveHelper {
  HiveHelper._();

  static final HiveHelper _instance = HiveHelper._();

  static HiveHelper get instance => _instance;

  final String _walkPathBoxName = Consts.kWalkPathsBoxKey;

  Box<WalkPathModel> get walkPathBox =>
      Hive.box<WalkPathModel>(_walkPathBoxName);

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WalkPathModelAdapter());
    Hive.registerAdapter(WalkStepModelAdapter());
    await Hive.openBox<WalkPathModel>(_walkPathBoxName);
  }

  // to add a WalkPath
  Future<void> addWalkPath(WalkPathModel walkPath) async {
    await walkPathBox.add(walkPath);
    log('added to hive', name: 'hive helper');
  }

  // fetch all WalkPaths
  List<WalkPathModel> getAllWalkPaths() {
    return walkPathBox.values.toList();
  }
}
