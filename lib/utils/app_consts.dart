import 'dart:ui';

// TypeDefs

typedef WalkingStep = ({double heading, Offset coordinate, DateTime timeStamp});

// Constants

class Consts {
  static const String kStateMachineKey = 'State Machine 1';
  static const String kSwitchKey = 'switch';

  static const double RAD_TO_DEG = 57.2958;
  static const double AVG_STP_LNTH = 0.445;
}
