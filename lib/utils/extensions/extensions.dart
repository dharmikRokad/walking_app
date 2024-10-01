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
  String get formatted => DateFormat('HH:mm:ss (dd/MM/yyyy)').format(this);

  String get dateF => DateFormat('dd-MM-yyyy').format(this);

  String get mmYY => DateFormat.MMMEd().format(this);

  String get timeF => DateFormat('HH:mm:ss').format(this);
}

extension FormatExtOffset on Offset {
  String get formatted => '(${dx.formatted}, ${dy.formatted})';
}

extension SnackBarExt on BuildContext {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSuccess(
      String msg) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showError(
      String msg) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
