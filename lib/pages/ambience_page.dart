import 'package:chime/components/settings/settings_title.dart';
import 'package:chime/configs/constants.dart';
import 'package:chime/enums/audio_type.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../audio/audio_manager.dart';
import '../components/settings/ambience/ambience_checkbox_tile.dart';
import '../components/settings/ambience/ambience_volume_slider.dart';
import '../data/ambience_data.dart';

class AmbiencePage extends ConsumerStatefulWidget {
  const AmbiencePage({Key? key}) : super(key: key);

  @override
  ConsumerState<AmbiencePage> createState() => _AmbiencePageState();
}

class _AmbiencePageState extends ConsumerState<AmbiencePage> {
  bool _audioPlayedOnLoad = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final state = ref.watch(stateProvider);

    if (!_audioPlayedOnLoad) {
      AudioManager().playAmbience(ambience: state.ambienceSelected);
      _audioPlayedOnLoad = true;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            AudioManager().stop(
                audioType: AudioType.ambience,
                fadeOutMilliseconds: kAudioFadeDuration);
            await Navigator.maybePop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
        ),
        title:             SettingsTitle(
          text: 'Ambience',
          icon: Icon(
            Icons.piano_outlined,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AmbienceVolumeSlider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * kSettingsListWidthIndentation ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ambienceData.length,
                itemBuilder: (context, index) {
                  return AmbienceCheckBoxTile(
                    ambienceData: ambienceData[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
