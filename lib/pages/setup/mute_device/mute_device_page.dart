import 'package:chime/utils/vibration_method.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vibration/vibration.dart';

import '../../../state/app_state.dart';

class MuteDevicePage extends ConsumerStatefulWidget {
  const MuteDevicePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MuteDevicePage> createState() => _MuteDevicePageState();
}

class _MuteDevicePageState extends ConsumerState<MuteDevicePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return SwitchListTile(
        inactiveTrackColor: Theme.of(context).disabledColor,
        inactiveThumbColor: Theme.of(context).disabledColor,
        title: Row(
          children: [
            const Icon(Icons.volume_mute_outlined),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.08),
              child: Text('Mute device',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(left: size.width * 0.135),
          child: Text('Turn off msg alerts & calls',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).primaryColor,
            ),

          ),
        ),
        value: state.deviceIsMuted,
        onChanged: (value) async {
          notifier.setDeviceIsMuted(value);
          if(await Vibration.hasVibrator() == true) {
            await vibrateDevice();
          }
        }
            );
  }
}
