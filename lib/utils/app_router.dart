import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/screens/previous_walk_screen.dart';
import 'package:walking_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:walking_app/screens/walk_path_detail_screen.dart';

enum RouteNames {
  home,
  previousWalks,
  walkDetail;
}

class AppRouter {
  AppRouter._();

  static final AppRouter _instance = AppRouter._();

  static AppRouter get instance => _instance;

  Map<String, Widget Function(BuildContext)> routes() {
    return {
      RouteNames.home.name: (context) => const HomeScreen(),
      RouteNames.previousWalks.name: (context) => const PreviousWalkScreen(),
      RouteNames.walkDetail.name: (context) => WalkDetailScreen(
          walk: (ModalRoute.of(context)?.settings.arguments) as WalkPathModel),
    };
  }
}
