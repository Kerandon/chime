import 'package:chime/state/audio_state.dart';
import 'package:chime/state/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../enums/prefs.dart';

class AmbienceVolumeSlider extends ConsumerWidget {
  const AmbienceVolumeSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
          ),
          child: Icon(
            audioState.ambienceVolume == 0.0 ||
                    !audioState.ambienceIsOn
                ? Icons.volume_mute_outlined
                : Icons.volume_up_outlined,
          ),
        ),
        Text(
          !audioState.ambienceIsOn
              ? '0'
              : (audioState.ambienceVolume * 10).round().toString(),
        ),
        Expanded(
          flex: 18,
          child: Slider(
            value: !audioState.ambienceIsOn
                ? 0
                : audioState.ambienceVolume,
            onChanged: !audioState.ambienceIsOn
                ? null
                : (value) async {
                    double volume = value;
                    audioNotifier.setAmbienceVolume(volume);
                    await DatabaseManager().insertIntoPrefs(k: Prefs.ambienceVolume.name, v: value);
                  },
            min: 0.0,
            max: 1.0,
          ),
        ),
      ],
    );
  }
}
