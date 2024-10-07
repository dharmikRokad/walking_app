import 'dart:developer';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/utils/app_utils.dart';
import 'package:walking_app/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class WalkPathDetailScreen extends StatefulWidget {
  const WalkPathDetailScreen({super.key, required this.walk});

  final WalkPathModel walk;

  @override
  State<WalkPathDetailScreen> createState() => _WalkPathDetailScreenState();
}

class _WalkPathDetailScreenState extends State<WalkPathDetailScreen> {
  final List<String> headers = ['No', 'Heading', 'Time', 'X', 'Y'];
  late String fileName;
  late File csvFile;
  final List<List<dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    fileName =
        'walk_path_${widget.walk.initT.dateF}_${widget.walk.initT.timeF}.csv';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _createExcelData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walk details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              AppUtils.shareCsv(XFile(csvFile.path));
            },
            icon: const Icon(CupertinoIcons.share),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Text(
            widget.walk.initT.timeF,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 7),
          Text(
            'Interval: ${widget.walk.interval} sec',
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 400,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: widget.walk.steps
                        .map((e) => FlSpot(e.coordinates[0], e.coordinates[1]))
                        .toList(),
                  )
                ],
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: widget.walk.steps.indexed.map(
              (data) {
                final (i, step) = data;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  isThreeLine: true,
                  title: Text(
                    '${i + 1}). ${step.timeStamp.timeF} = ${step.strCords}',
                  ),
                  subtitle: Text('heading : ${step.heading}'),
                );
              },
            ).toList(),
          )
        ],
      ),
    );
  }

  Future<void> _createExcelData() async {
    for (final (i, step) in widget.walk.steps.indexed) {
      final List<String> record = [];

      record.add((i + 1).toString());
      record.add(step.heading.formatted);
      record.add(step.timeStamp.formatted);
      record.add(step.x.formatted);
      record.add(step.y.formatted);

      data.add(record);
    }

    String csvData = const ListToCsvConverter().convert([headers, ...data]);

    final directory = await getApplicationDocumentsDirectory();

    final path = "${directory.path}/$fileName";

    csvFile = File(path);

    await csvFile.writeAsString(csvData);
    log('file ptah => ${csvFile.path}');
  }
}
