import 'package:chime/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../audio/audio_manager.dart';
import '../../../enums/ambience.dart';
import '../../../enums/prefs.dart';
import '../../../models/ambience_model.dart';
import '../../../state/app_state.dart';

class AmbienceCheckBoxTile extends ConsumerStatefulWidget {
  const AmbienceCheckBoxTile({
    super.key,
    required this.ambienceData,
  });

  final AmbienceData ambienceData;

  @override
  ConsumerState<AmbienceCheckBoxTile> createState() =>
      _AmbienceCheckBoxTileState();
}

class _AmbienceCheckBoxTileState extends ConsumerState<AmbienceCheckBoxTile> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    return CheckboxListTile(
      title: Row(
        children: [
          widget.ambienceData.icon,
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.03),
            child: Text(
              widget.ambienceData.ambience.toText(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
      value: state.ambienceSelected == widget.ambienceData.ambience,
      onChanged: (value) async {
        Ambience ambience = widget.ambienceData.ambience;
        notifier.setAmbienceSelected(ambience);
        await AudioManager().playAmbience(ambience: ambience);
        print('insert in database ${Prefs.ambienceSelected.name} and $ambience');
        await DatabaseManager().insertIntoPrefs(k: Prefs.ambienceSelected.name, v: ambience.name);
      },
    );
  }
}
