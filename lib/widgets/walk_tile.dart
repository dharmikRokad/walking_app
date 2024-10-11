import 'package:flutter/material.dart';
import 'package:walking_app/hive_models/walk_path_model.dart';
import 'package:walking_app/utils/app_colors.dart';
import 'package:walking_app/utils/app_router.dart';
import 'package:walking_app/utils/extensions/extensions.dart';

class WalkTile extends StatelessWidget {
  const WalkTile({
    super.key,
    required this.walk,
  });

  final WalkPathModel walk;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            RouteNames.walkDetail.name,
            arguments: walk,
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.yellow, width: 1.5),
        ),
        tileColor: AppColors.yellow.withAlpha(220),
        title: Text(
          walk.iniT.dateF,
          style: const TextStyle(
            color: AppColors.brown,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          walk.iniT.timeF,
          style: const TextStyle(color: AppColors.brown),
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          color: AppColors.brown,
        ),
      ),
    );
  }
}
