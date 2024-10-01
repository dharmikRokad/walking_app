import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/providers/hive_helper.dart';
import 'package:walking_app/screens/walk_cycle_detail_screen.dart';
import 'package:walking_app/utils/app_router.dart';
import 'package:walking_app/utils/extensions/extensions.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walk Histories'),
      ),
      body: ValueListenableBuilder(
          valueListenable: HiveHelper.instance.walkPathBox.listenable(),
          builder: (context, box, _) {
            final List<WalkPathModel> walks = box.values.toList();
            return ListView.builder(
              itemBuilder: (context, i) {
                return ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(RouteNames.walkDetail.name);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return WalkCycleDetailScreen(
                            walk: walks[i],
                          );
                        },
                      ),
                    );
                  },
                  title: Text('Walk ${i + 1}'),
                  subtitle: Text(walks[i].initT.formatted),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                );
              },
            );
          }),
    );
  }
}
