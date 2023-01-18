import 'package:chime/models/prefs_model.dart';
import 'package:chime/state/preferences_ambience.dart';
import 'package:chime/state/preferences_main.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../configs/app_colors.dart';
import '../../data/ambience_data.dart';
import '../../enums/ambience.dart';
import '../../state/app_state.dart';
import '../../configs/constants.dart';

class AmbienceDisplay extends ConsumerWidget {
  const AmbienceDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(stateProvider.notifier);
    final size = MediaQuery.of(context).size;
    return FutureBuilder<dynamic>(
        future: PreferencesMain.getPreferences(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            PrefsModel prefsData = snapshot.data!;
            double volume = prefsData.ambienceVolume;
            Ambience ambience = prefsData.ambienceSelected;

            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) {
                notifier.setAmbienceVolume(volume);
                notifier.setAmbience(ambience);
              },
            );
            Icon? icon;
            for (var d in ambienceData) {
              if (d.ambience == ambience) {
                icon = Icon(
                  d.icon.icon,
                  color: AppColors.lightGrey,
                  size: kHomePageSmallIcon,
                );
              }
            }

            return ambience == Ambience.none
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(
                      left: size.width * 0.06,
                    ),
                    child: icon);
          }
          return const SizedBox.shrink();
        });
  }
}
