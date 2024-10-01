import 'dart:developer';
import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:to_csv/to_csv.dart' as exp_csv;

class WalkCycleDetailScreen extends StatelessWidget {
  const WalkCycleDetailScreen({super.key, required this.walk});

  final WalkPathModel walk;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walk details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Opacity(
            opacity: 0,
            child: IconButton(
              onPressed: downloadFile,
              icon: const Icon(Icons.ios_share),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Text(
            walk.initT.timeF,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 7),
          Text(
            'Interval: ${walk.interval} sec',
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Column(
            children: walk.steps.indexed.map(
              (data) {
                final (i, step) = data;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  isThreeLine: true,
                  title: Text(
                    '${i + 1}). ${step.timeStamp.timeF} = ${step.coordinate.formatted}',
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

  downloadFile() async {
    final List<String> headers = ['No.', 'X', 'Y'];

    List<List<String>> data = [];

    for (final (i, step) in walk.steps.indexed) {
      final List<String> record = [];

      record.add((i + 1).toString());
      record.add(step.coordinate.dx.formatted);
      record.add(step.coordinate.dy.formatted);

      data.add(record);
    }

    final resp = await exp_csv.myCSV(headers, data, setHeadersInFirstRow: true);
    log('resp => ${resp.runtimeType}');
    log('resp => $resp');
  }
}
