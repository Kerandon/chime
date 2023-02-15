import 'package:chime/configs/constants.dart';
import 'package:chime/enums/audio_type.dart';
import 'package:chime/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../audio/audio_manager.dart';
import '../../../data/ambience_data.dart';
import '../components/settings_title.dart';
import 'ambience_checkbox_tile.dart';
import 'ambience_volume_slider.dart';

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

      _audioPlayedOnLoad = true;
    }



    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {

            await Navigator.maybePop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
        ),
        title:             const SettingsTitle(
          text: 'Ambience',
          icon: Icon(
            Icons.piano_outlined,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(size.height * kPageIndentation),
              child: const AmbienceVolumeSlider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * kPageIndentation ),
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
