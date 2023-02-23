import 'package:chime/state/audio_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BellVolumeSlider extends ConsumerWidget {
  const BellVolumeSlider({
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
            audioState.bellVolume == 0.0
                ? Icons.volume_mute_outlined
                : Icons.volume_up_outlined,
          ),
        ),
        Text(
          (audioState.bellVolume * 10).round().toString(),
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 16),
        ),
        Expanded(
          flex: 18,
          child: Slider(
            value: audioState.bellVolume,
            onChanged: (value) async {
              double volume = value;
              audioNotifier.setBellVolume(volume);

            },
            min: 0.0,
            max: 1.0,
          ),
        ),
      ],
    );
  }
}
