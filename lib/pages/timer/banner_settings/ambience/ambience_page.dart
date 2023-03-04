import 'package:chime/app_components/custom_animated_grid_box.dart';
import 'package:chime/app_components/custom_slider_tile.dart';
import 'package:chime/configs/constants.dart';
import 'package:chime/data/ambience_data.dart';
import 'package:chime/enums/ambience.dart';
import 'package:chime/pages/timer/banner_settings/ambience/ambience_volume_slider.dart';
import 'package:chime/state/audio_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../audio/audio_manager_new.dart';

class AmbiencePage extends ConsumerStatefulWidget {
  const AmbiencePage({Key? key}) : super(key: key);

  @override
  ConsumerState<AmbiencePage> createState() => _AmbiencePageState();
}

class _AmbiencePageState extends ConsumerState<AmbiencePage> {

  bool _audioPlayedOnInit = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);
    final spacing = size.width * 0.02;
    if(audioState.ambienceIsOn && !_audioPlayedOnInit){
      AudioManagerNew().playAmbience(ambience: audioState.ambienceSelected, volume: audioState.ambienceVolume);
      _audioPlayedOnInit = true;
    }

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                AudioManagerNew().stopAmbience();
                //AudioManagerNew().fadeOutStopAmbience(startVolume: audioState.ambienceVolume);
                Navigator.of(context).maybePop();
              },
              icon: const Icon(Icons.arrow_back_outlined),
            ),
            title: const Text('Ambience')),
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: size.width * kPageIndentation),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomSwitchTile(
                    title: 'Add ambience',
                    icon: audioState.ambienceIsOn
                        ? Icons.piano_outlined
                        : Icons.piano_off_outlined,
                    value: audioState.ambienceIsOn,
                    onChanged: (value) {
                      if(!value){
                        AudioManagerNew().stopAmbience();
                      }
                      audioNotifier
                        .setAmbienceIsOn(!audioState.ambienceIsOn);
                    }),
                Padding(
                  padding: EdgeInsets.only(bottom: size.height * 0.03),
                  child: const AmbienceVolumeSlider(),
                ),
                GridView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: ambienceData.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: spacing,
                      crossAxisSpacing: spacing,
                    ),
                    itemBuilder: (context, index) {
                      final ambience = ambienceData.elementAt(index).ambience;
                      return CustomAnimatedGridBox(
                        labelText: ambience.toText(),
                        onPressed: audioState.ambienceIsOn
                            ? () async {
                                audioNotifier.setAmbience(ambience);
                                await AudioManagerNew().playAmbience(ambience: ambience, volume: audioState.ambienceVolume);

                              }
                            : null,
                        isSelected: ambience == audioState.ambienceSelected &&
                            audioState.ambienceIsOn,
                        contents: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/ambience/${ambience.name}.jpg'),
                            ),
                            borderRadius: BorderRadius.circular(kBorderRadius),
                            border: Border.all(
                              color: Theme.of(context).splashColor,
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ));
  }
}
