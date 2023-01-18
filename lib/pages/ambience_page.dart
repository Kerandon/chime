import 'package:chime/components/settings/settings_title.dart';
import 'package:flutter/material.dart';
import '../audio/audio_manager.dart';
import '../components/settings/ambience_checkbox_tile.dart';
import '../components/settings/ambience_volume_slider.dart';
import '../data/ambience_data.dart';

class AmbiencePage extends StatelessWidget {
  const AmbiencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            AudioManager().stopAmbienceAudio();
            Navigator.maybePop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SettingsTitle(
              text: 'Ambience',
              icon: Icon(
                Icons.piano_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(size.width * 0.03),
              child: const AmbienceVolumeSlider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
