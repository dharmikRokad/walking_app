import 'dart:ui';

// TypeDefs

typedef WalkingStep = ({
  double heading,
  List<double> coordinate,
  DateTime timeStamp
});

// Constants

class Consts {
  static const String kStateMachineKey = 'State Machine 1';
  static const String kSwithKey = 'switch';
  static const String kWalkKey = 'Walk';
  static const String kHandsKey = 'Hands';
  static const String kDistanceNodeKey = 'distance_node';
  static const String kWalkPathsBoxKey = 'walk_paths';

  static const kTableHeadings = ['No.', 'X', 'Y', 'Heading', 'Time'];

  static const double kRadToDeg = 57.2958;
  static const double kStepDis = .4;
}

class Strings {
  // HOME //
  static const String home = 'Home';
  static const String stepDistanceLbl = 'Step distance (m)';
  static const String recentWalks = 'Recent walks';
  static const String viewAll = 'View All';
  static const String noRecentWalkMsg =
      'No recent walks. Try to start walking by pressing the above start button.';

  // Previous Walks //
  static const String previousWalks = 'Previous Walks';
  static const String noPreviousWalks = 'No recent walks.';

  // Walk details //
  static const String walkDetails = 'Walk details';
  static const String xAxisTitle = 'X (m)';
  static const String yAxisTitle = 'Y (m)';
}
