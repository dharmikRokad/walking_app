import 'dart:developer';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/utils/app_utils.dart';
import 'package:walking_app/utils/extensions/extensions.dart';

class WalkDetailsScrProvider extends ChangeNotifier {
  WalkDetailsScrProvider({required WalkPathModel walk}) : _walk = walk;

  final WalkPathModel _walk;
  final List<List<dynamic>> _excelData = [];
  bool _isChartView = true;

  WalkPathModel get walk => _walk;
  List<List<dynamic>> get excelData => _excelData;
  bool get isChartView => _isChartView;

  @override
  void dispose() {
    log('WalkDetailScrProvider disposed!!');
    super.dispose();
  }

  void changeView() {
    _isChartView = !_isChartView;
    notifyListeners();
  }

  void prepareDataToExport() {
    for (final (i, step) in _walk.steps.indexed) {
      final List<String> record = [];

      record.add((i + 1).toString());
      record.add(step.x.formatted);
      record.add(step.y.formatted);
      record.add(step.heading.formatted);
      record.add(step.timeStamp.timeF);

      _excelData.add(record);
    }
  }

  Future<String> createCsvFile() async {
    final headers = ['No', 'X', 'Y', 'Heading', 'Time'];
    final fileName = 'walk_path_${_walk.initT.dateF}_${_walk.initT.timeF}.csv';

    String csvData =
        const ListToCsvConverter().convert([headers, ..._excelData]);

    final directory = await getApplicationDocumentsDirectory();

    final path = "${directory.path}/$fileName";

    final csvFile = File(path);

    await csvFile.writeAsString(csvData);

    return csvFile.path;
  }

  void shareCsv() async =>
      await AppUtils.shareFile(XFile(await createCsvFile()));
}
