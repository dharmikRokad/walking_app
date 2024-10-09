import 'dart:async';

import 'package:rive/rive.dart';
import 'package:walking_app/providers/rive_helper.dart';
import 'package:walking_app/utils/app_colors.dart';
import 'package:walking_app/utils/app_router.dart';
import 'package:walking_app/utils/app_utils.dart';
import 'package:walking_app/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TextEditingController _stepDController;
  final FocusNode _sdfn = FocusNode(debugLabel: 'distance node');
  final FocusNode _stfn = FocusNode(debugLabel: 'interval node');

  @override
  void initState() {
    super.initState();
    _stepDController = TextEditingController(
      text: context.read<HomeProvider>().stepDistance.toString(),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<RiveHelper>().initWalkingCrab();
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
    return Consumer2<HomeProvider, RiveHelper>(
      builder: (context, provider, rive, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteNames.history.name);
                },
                icon: const Icon(Icons.history),
              )
            ],
          ),
          body: provider.isLoading || rive.walkCrabArtboard == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    Rive(
                      artboard: rive.walkCrabArtboard!,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomCenter,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          // _buildActionsRow(provider),
                          const SizedBox(height: 10),
                          _buildstepDistanceVieW(provider),
                          const SizedBox(height: 10),
                          _buildIntervalView(provider),
                          const SizedBox(height: 10),
                          _buildActionButton(provider),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      },
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
        color: AppColors.primary,
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.ternary),
        ),
        border: InputBorder.none,
        labelText: 'Step distance (m)',
        labelStyle: const TextStyle(
          fontSize: 18,
          color: AppColors.ternary,
        ),
        suffixIcon: _sdfn.hasFocus
            ? IconButton(
                icon: const Icon(
                  Icons.done,
                  color: AppColors.ternary,
                ),
                onPressed: () {
                  provider.changeStepD(double.parse(_stepDController.text));
                  _sdfn.nextFocus();
                },
              )
            : IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: AppColors.ternary,
                ),
                onPressed: _sdfn.requestFocus,
              ),
      ),
    );
  }

  Widget _buildIntervalView(HomeProvider provider) {
    return DropdownButtonFormField(
      padding: const EdgeInsets.all(12),
      focusNode: _stfn,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.headingTextColor,
      ),
      iconEnabledColor: AppColors.lightTextColor,
      items: const [
        DropdownMenuItem<int>(value: 1, child: Text('1')),
        DropdownMenuItem<int>(value: 5, child: Text('5')),
        DropdownMenuItem<int>(value: 15, child: Text('15')),
        DropdownMenuItem<int>(value: 30, child: Text('30')),
      ],
      value: provider.deltaT,
      onChanged: (value) {
        provider.onDeltaTChanged(value);
        _stfn.nextFocus();
      },
      decoration: const InputDecoration(
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(),
        labelText: 'Time interval (s)',
        labelStyle: TextStyle(
          fontSize: 18,
          color: AppColors.lightTextColor,
        ),
      ),
    );
  }

  Widget _buildActionButton(HomeProvider provider) {
    return InkWell(
      onTap: provider.isStartBtnEnable
          ? () {
              if (!provider.isStartBtnEnable) return;
              provider.onStart();
              context.read<RiveHelper>().changeCrabWalk(true);
              context.read<RiveHelper>().changeCrabHandsJoint(true);
            }
          : () {
              if (provider.isStartBtnEnable) return;
              context.read<RiveHelper>().changeCrabWalk(false);
              context.read<RiveHelper>().changeCrabHandsJoint(false);
              provider.onStop();
            },
      child: ClipOval(
        child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: Text(provider.isStartBtnEnable ? 'Start' : 'Stop'),
        ),
      ),
    );
  }
}
