import 'package:chime/utils/vibration_method.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vibration/vibration.dart';

import '../../../configs/app_colors.dart';
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
        inactiveTrackColor: AppColors.grey,
        inactiveThumbColor: AppColors.lightGrey,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.08),
              child: SizedBox(
                  width: size.width * 0.05,
                  child: const Icon(Icons.volume_mute_outlined)),
            ),
            const Text('Mute device alerts & calls'),
          ],
        ),
        value: state.deviceIsMuted,
        onChanged: (value) async {
          notifier.setDeviceIsMuted(value);
          if (await Vibration.hasVibrator() == true) {
            await vibrateDevice();
          }
        });
  }
}
