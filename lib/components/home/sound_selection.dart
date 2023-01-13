import 'package:chime/audio/audio_manager.dart';
import 'package:chime/enums/session_status.dart';
import 'package:chime/state/state_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../enums/focus_state.dart';
import '../../enums/sounds.dart';

class SoundSelection extends StatelessWidget {
  const SoundSelection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SoundButton(sound: Sounds.chime),
        SizedBox(
          width: size.width * 0.05,
        ),
        const SoundButton(sound: Sounds.gong),
      ],
    );
  }
}

class SoundButton extends ConsumerWidget {
  const SoundButton({required this.sound, Key? key}) : super(key: key);

  final Sounds sound;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);



    return SizedBox(
      width: size.width * 0.25,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: state.soundSelected == sound
              ? const BorderSide(color: Colors.teal, width: 2)
              : null,
        ),
        onPressed: () async {
          if(state.sessionStatus == SessionStatus.notStarted) {
            await AudioManager().playAudio(sound: sound.name);
          }
          notifier.setSound(sound);
          notifier.setTimerFocusState(FocusState.unFocus);
        },
        child: Text(
          sound.toText(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
