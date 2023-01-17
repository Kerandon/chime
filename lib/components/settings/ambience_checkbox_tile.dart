import 'package:chime/state/preferences_ambience.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../audio/audio_manager.dart';
import '../../enums/ambience.dart';
import '../../models/ambience_model.dart';
import '../../state/app_state.dart';

class AmbienceCheckBoxTile extends ConsumerWidget {
  const AmbienceCheckBoxTile({
    super.key,
    required this.ambienceData,
  });

  final AmbienceData ambienceData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return CheckboxListTile(
      title: Row(
        children: [
          ambienceData.icon,
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.03),
            child: Text(ambienceData.ambience.toText(), style: Theme.of(context).textTheme.bodySmall,),
          ),
        ],
      ),
      value: state.ambienceSelected == ambienceData.ambience,
      onChanged: (value) async {
        Ambience ambience = ambienceData.ambience;
        notifier.setAmbience(ambience);
        await AudioManager().playAmbience(ambience);
        await PreferencesAmbience.setAmbienceSelected(ambience);
      },
      activeColor: Theme.of(context).primaryColor,
      side: BorderSide(color: Colors.white),
    );
  }
}
