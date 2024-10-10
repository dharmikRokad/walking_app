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
        ),
        tileColor: AppColors.color1,
        title: Text(
          walk.initT.dateF,
          style: const TextStyle(
            color: AppColors.color4,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          walk.initT.formatted,
          style: const TextStyle(color: AppColors.color4),
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          color: AppColors.color4,
        ),
      ),
    );
  }
}
