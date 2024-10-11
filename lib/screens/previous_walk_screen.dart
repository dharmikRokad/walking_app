import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/utils/app_consts.dart';
import 'package:walking_app/utils/hive_helper.dart';
import 'package:walking_app/widgets/walk_tile.dart';

class PreviousWalkScreen extends StatefulWidget {
  const PreviousWalkScreen({super.key});

  @override
  State<PreviousWalkScreen> createState() => _PreviousWalkScreenState();
}

class _PreviousWalkScreenState extends State<PreviousWalkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.previousWalks),
      ),
      body: ValueListenableBuilder(
        valueListenable: HiveHelper.instance.walkPathBox.listenable(),
        builder: (context, box, _) {
          final List<WalkPathModel> walks = box.values.toList();

          if (walks.isEmpty) {
            return const Center(
              child: Text(Strings.noPreviousWalks),
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
