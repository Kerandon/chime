import 'package:chime/state/preferences_main.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../enums/ambience.dart';
import '../../../state/app_state.dart';

class AmbienceVolumeSlider extends ConsumerWidget {
  const AmbienceVolumeSlider({
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
            state.ambienceVolume == 0.0 ||
                    state.ambienceSelected == Ambience.none
                ? Icons.volume_mute_outlined
                : Icons.volume_up_outlined,
          ),
        ),
        Text(
          state.ambienceSelected == Ambience.none
              ? '0'
              : (state.ambienceVolume * 10).round().toString(),
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 16),
        ),
        Expanded(
          flex: 18,
          child: Slider(
            value: state.ambienceSelected == Ambience.none
                ? 0
                : state.ambienceVolume,
            onChanged: state.ambienceSelected == Ambience.none
                ? null
                : (value) async {
                    double volume = value;
                    notifier.setAmbienceVolume(volume);
                    await PreferencesMain.setPreferences(ambienceVolume: value);
                  },
            min: 0.0,
            max: 1.0,
          ),
        ),
      ],
    );
  }
}
