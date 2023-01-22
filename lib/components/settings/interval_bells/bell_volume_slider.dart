import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../state/app_state.dart';
import '../../../state/preferences_main.dart';

class BellVolumeSlider extends ConsumerWidget {
  const BellVolumeSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
          ),
          child: Icon(
            state.bellVolume == 0.0
                ? Icons.volume_mute_outlined
                : Icons.volume_up_outlined,
          ),
        ),
        Text(
          (state.bellVolume * 10).round().toString(),
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 16),
        ),
        Expanded(
          flex: 18,
          child: Slider(
            value: state.bellVolume,
            onChanged: (value) async {
              double volume = value;
              notifier.setBellVolume(volume);
              await PreferencesMain.setPreferences(bellVolume: volume);
            },
            min: 0.0,
            max: 1.0,
          ),
        ),
      ],
    );
  }
}
