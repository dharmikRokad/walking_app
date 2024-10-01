import 'package:walking_app/entities/walk_path.dart';
import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/screens/history_screen.dart';
import 'package:walking_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:walking_app/screens/walk_path_detail_screen.dart';

enum RouteNames {
  home,
  history,
  walkDetail;
}

class AppRouter {
  AppRouter._();

  static final AppRouter _instance = AppRouter._();

  static AppRouter get instance => _instance;

  Map<String, Widget Function(BuildContext)> routes() {
    return {
      RouteNames.home.name: (context) => const HomeScreen(),
      RouteNames.history.name: (context) => const HistoryScreen(),
      RouteNames.walkDetail.name: (context) => WalkPathDetailScreen(
          walk: (ModalRoute.of(context)?.settings.arguments) as WalkPathModel),
    };
  }
}
