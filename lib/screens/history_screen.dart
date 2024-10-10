import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/providers/hive_helper.dart';
import 'package:walking_app/utils/app_colors.dart';
import 'package:walking_app/utils/app_router.dart';
import 'package:walking_app/utils/extensions/extensions.dart';
import 'package:walking_app/widgets/walk_tile.dart';

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
        title: const Text('History'),
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveHelper.instance.walkPathBox.listenable(),
        builder: (context, box, _) {
          final List<WalkPathModel> walks = box.values.toList();

          if (walks.isEmpty) {
            return const Center(
              child: Text('NO data.'),
            );
          }

          return ListView.separated(
            itemCount: walks.length,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            separatorBuilder: (_, __) => const SizedBox(height: 5),
            itemBuilder: (context, i) {
              return WalkTile(walk: walks.reversed.toList()[i]);
            },
          );
        },
      ),
    );
  }
}
