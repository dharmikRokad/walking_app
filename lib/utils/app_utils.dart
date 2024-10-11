import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class AppUtils {
  static List<double> getMinMaxXY(List<List<double>> points) {
    if (points.isEmpty) {
      throw ArgumentError('The list of points is empty');
    }

    double minX = points.first[0];
    double minY = points.first[1];
    double maxX = points.first[0];
    double maxY = points.first[1];

    for (List<double> point in points) {
      if (point[0] < minX) minX = point[0];
      if (point[1] < minY) minY = point[1];
      if (point[0] > maxX) maxX = point[0];
      if (point[1] > maxY) maxY = point[1];
    }

    return [minX, minY, maxX, maxY];
  }

  // Matrix Functions ------------- //
  static List<List<double>> multiplyMatrix(
      List<List<double>> A, List<List<double>> B) {
    int aRows = A.length, aCols = A[0].length, bCols = B[0].length;
    List<List<double>> result =
        List.generate(aRows, (_) => List.filled(bCols, 0.0));

    for (int i = 0; i < aRows; i++) {
      for (int j = 0; j < bCols; j++) {
        for (int k = 0; k < aCols; k++) {
          result[i][j] += A[i][k] * B[k][j];
        }
      }
    }
    return result;
  }

  static List<List<double>> addMatrix(
      List<List<double>> A, List<List<double>> B) {
    int rows = A.length, cols = A[0].length;
    List<List<double>> result =
        List.generate(rows, (_) => List.filled(cols, 0.0));
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i][j] = A[i][j] + B[i][j];
      }
    }
    return result;
  }

  static List<List<double>> subtractMatrix(
      List<List<double>> A, List<List<double>> B) {
    int rows = A.length, cols = A[0].length;
    List<List<double>> result =
        List.generate(rows, (_) => List.filled(cols, 0.0));
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[i][j] = A[i][j] - B[i][j];
      }
    }
    return result;
  }

  static List<List<double>> transposeMatrix(List<List<double>> A) {
    int rows = A.length, cols = A[0].length;
    List<List<double>> result =
        List.generate(cols, (_) => List.filled(rows, 0.0));
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        result[j][i] = A[i][j];
      }
    }
    return result;
  }

  static List<List<double>> invert3x3Matrix(List<List<double>> A) {
    double det = A[0][0] * (A[1][1] * A[2][2] - A[1][2] * A[2][1]) -
        A[0][1] * (A[1][0] * A[2][2] - A[1][2] * A[2][0]) +
        A[0][2] * (A[1][0] * A[2][1] - A[1][1] * A[2][0]);
    if (det == 0) {
      throw Exception("Matrix is singular and cannot be inverted.");
    }
    double invDet = 1.0 / det;

    return [
      [
        invDet * (A[1][1] * A[2][2] - A[1][2] * A[2][1]),
        invDet * (A[0][2] * A[2][1] - A[0][1] * A[2][2]),
        invDet * (A[0][1] * A[1][2] - A[0][2] * A[1][1])
      ],
      [
        invDet * (A[1][2] * A[2][0] - A[1][0] * A[2][2]),
        invDet * (A[0][0] * A[2][2] - A[0][2] * A[2][0]),
        invDet * (A[0][2] * A[1][0] - A[0][0] * A[1][2])
      ],
      [
        invDet * (A[1][0] * A[2][1] - A[1][1] * A[2][0]),
        invDet * (A[0][1] * A[2][0] - A[0][0] * A[2][1]),
        invDet * (A[0][0] * A[1][1] - A[0][1] * A[1][0])
      ]
    ];
  }
  // ------------- //

  // Dialogues ---------------- //

  static void showSensorErrorDialogue(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Sensor Not Found"),
          content: Text(
            "It seems that your device doesn't support one or more Sensors, that are required for the app.",
          ),
        );
      },
    );
  }

  static void showActivityRecPerDialogue(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Permission Denied."),
          content: Text(
            "You denied the permission for activity recognition to use pedometer, please allow it from the settings.",
          ),
        );
      },
    );
  }
  // ---------------- //

  // Export & share ---------------- //
  static Future<void> shareFile(XFile file) async {
    try {
      await Share.shareXFiles([file]);
    } on Exception catch (e) {
      log('err - sharing file => $e');
    }
  }
  // ----------------------- //
}
