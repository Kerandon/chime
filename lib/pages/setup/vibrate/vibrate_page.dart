import 'package:chime/utils/vibration_method.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vibration/vibration.dart';

import '../../../state/app_state.dart';

class Vibrate extends ConsumerStatefulWidget {
  const Vibrate({
    super.key,
  });

  @override
  ConsumerState<Vibrate> createState() => _VibrateState();
}

class _VibrateState extends ConsumerState<Vibrate> {
  late final Future<bool> _vibrationFuture;

  @override
  void initState() {
    _vibrationFuture = _checkDeviceCanVibrate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    bool canVibrate = true;

    return FutureBuilder(
      future: _vibrationFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          canVibrate = snapshot.data!;
        }

        return SwitchListTile(
            inactiveTrackColor: Theme.of(context).disabledColor,
            inactiveThumbColor: Theme.of(context).disabledColor,
            title: Row(
              children: [
                const Icon(Icons.vibration_outlined),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.08),
                  child: Text('Vibrate on completion',
                      style: Theme.of(context).textTheme.bodySmall),
                ),
              ],
            ),
            value: state.vibrateOnCompletion,
            onChanged: canVibrate
                ? (value) async {
              if(value){
               await vibrateDevice();
              }
                    notifier.setVibrateOnCompletion(value);
                  }
                : null);
      },
    );
  }

  Future<bool> _checkDeviceCanVibrate() async {
    if (await Vibration.hasVibrator() == true) {
      return true;
    } else {
      return false;
    }
  }
}
