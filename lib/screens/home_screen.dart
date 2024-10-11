import 'dart:async';

import 'package:rive/rive.dart';
import 'package:walking_app/providers/rive_anim_provider.dart';
import 'package:walking_app/utils/app_colors.dart';
import 'package:walking_app/utils/app_consts.dart';
import 'package:walking_app/utils/app_router.dart';
import 'package:walking_app/utils/app_utils.dart';
import 'package:walking_app/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';
import 'package:walking_app/widgets/walk_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _stepDController;
  final FocusNode _sdfn = FocusNode(debugLabel: Consts.kDistanceNodeKey);

  @override
  void initState() {
    super.initState();
    _stepDController = TextEditingController(
      text: context.read<HomeProvider>().stepDistance.toString(),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<RiveAnimProvider>().initWalkingCrab();
      await initCompass();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initCompass() async {
    FlutterCompass.events!.listen(
      context.read<HomeProvider>().onCompassEvent,
      onError: (_) => AppUtils.showSensorErrorDialogue(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeProvider, RiveAnimProvider>(
      builder: (context, provider, rive, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(Strings.home),
          ),
          body: provider.isLoading || rive.walkCrabArtboard == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Column(
                    children: [
                      _buildAnimationView(provider, rive),
                      const SizedBox(height: 5),
                      const Divider(),
                      Expanded(child: _buildRecentWalkVieW(provider)),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildAnimationView(HomeProvider provider, RiveAnimProvider rive) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Rive(
            artboard: rive.walkCrabArtboard!,
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: _buildstepDistanceVieW(provider),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _buildActionButton(provider),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildstepDistanceVieW(HomeProvider provider) {
    return TextField(
      focusNode: _sdfn,
      controller: _stepDController,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: Strings.stepDistanceLbl,
        labelStyle: const TextStyle(
          fontSize: 18,
        ),
        suffixIcon: _sdfn.hasFocus
            ? IconButton(
                icon: const Icon(
                  Icons.done,
                  color: AppColors.brown,
                ),
                onPressed: () {
                  provider.changeStepD(double.parse(_stepDController.text));
                  _sdfn.nextFocus();
                },
              )
            : IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.brown,
                ),
                onPressed: _sdfn.requestFocus,
              ),
      ),
    );
  }

  Widget _buildActionButton(HomeProvider provider) {
    return IconButton(
      onPressed: provider.isStartBtnEnable
          ? () {
              if (!provider.isStartBtnEnable) return;
              provider.onStart();
              context.read<RiveAnimProvider>().changeCrabWalk(true);
              context.read<RiveAnimProvider>().changeCrabHandsJoint(true);
            }
          : () {
              if (provider.isStartBtnEnable) return;
              context.read<RiveAnimProvider>().changeCrabWalk(false);
              context.read<RiveAnimProvider>().changeCrabHandsJoint(false);
              provider.onStop();
            },
      iconSize: 40,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.brown,
        elevation: 3,
        shadowColor: AppColors.grey,
      ),
      icon: Icon(
        provider.isStartBtnEnable ? Icons.play_arrow : Icons.pause,
      ),
    );
  }

  Widget _buildRecentWalkVieW(HomeProvider provider) {
    return Column(
      children: [
        Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                Strings.recentWalks,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.brown,
                ),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RouteNames.previousWalks.name);
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.brown,
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 2,
                ),
              ),
              child: const Row(
                children: [
                  Text(Strings.previousWalks),
                  Icon(Icons.keyboard_arrow_right)
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: provider.recentWalks.isEmpty
              ? const Center(
                  child: Text(
                    Strings.noRecentWalkMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.5,
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: provider.recentWalks.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  separatorBuilder: (_, __) => const SizedBox(height: 5),
                  itemBuilder: (context, i) {
                    return WalkTile(
                      walk: provider.recentWalks.reversed.toList()[i],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
