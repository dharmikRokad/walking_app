import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension FormatExtension on double {
  String get formatted {
    if (this < 0 && this > -0.00999999999) {
      return abs().toStringAsFixed(2);
    }
    return toStringAsFixed(2);
  }

  double get opposite {
    if (this == 0) {
      return 0;
    }

    return -this;
  }

  double get toRadian => this * (pi / 180);
}

extension FormateExt on DateTime {
  String get formatted {
    final DateFormat format = DateFormat('HH:mm:ss (dd/MM/yyyy)');
    return format.format(this);
  }

  String get dateF {
    final DateFormat format = DateFormat('dd-MM-yyyy');
    return format.format(this);
  }

  String get timeF {
    final DateFormat format = DateFormat('HH:mm:ss');
    return format.format(this);
  }
}

extension FormatExtOffset on Offset {
  String get formatted => '(${dx.formatted}, ${dy.formatted})';
}
