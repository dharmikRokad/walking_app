import 'dart:async';

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
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) async => initCompass());
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
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RouteNames.history.name);
              },
              icon: const Icon(Icons.history),
            )
          ],
        ),
        body: Column(
          children: [
            _buildConfigRow(provider),
            _buildActionsRow(provider),
          ],
          // ],
        ),
      );
    });
  }

  Widget _buildConfigRow(HomeProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: _sdfn,
              controller: _stepDController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                focusedBorder: const OutlineInputBorder(),
                border: InputBorder.none,
                labelText: 'Step distance (m)',
                labelStyle: const TextStyle(fontSize: 18),
                suffixIcon: _sdfn.hasFocus
                    ? IconButton(
                        icon: const Icon(Icons.done),
                        onPressed: () {
                          provider
                              .changeStepD(double.parse(_stepDController.text));
                          _sdfn.nextFocus();
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _sdfn.requestFocus,
                      ),
              ),
            ),
          ),
          Expanded(
            child: DropdownButtonFormField(
              padding: const EdgeInsets.all(12),
              focusNode: _stfn,
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
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionsRow(HomeProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                if (!provider.isStartBtnEnable) return;

                // _activateSensers();
                provider
                    .onStart(() => AppUtils.showSensorErrorDialogue(context));
              },
              style: TextButton.styleFrom(
                backgroundColor: provider.isStartBtnEnable
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Colors.white,
                foregroundColor: provider.isStartBtnEnable
                    ? Colors.white
                    : Theme.of(context).colorScheme.inversePrimary,
                elevation: 10,
                fixedSize: const Size.fromHeight(50),
              ),
              child: const Text('Start'),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextButton(
              onPressed: () {
                if (provider.isStartBtnEnable) return;

                provider.onStop();
                // _disposeSubscriptions();
              },
              style: TextButton.styleFrom(
                backgroundColor: provider.isStartBtnEnable
                    ? Colors.white
                    : Theme.of(context).colorScheme.inversePrimary,
                foregroundColor: provider.isStartBtnEnable
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Colors.white,
                elevation: 100,
                fixedSize: const Size.fromHeight(50),
              ),
              child: const Text('Stop'),
            ),
          )
        ],
      ),
    );
  }
}
