import 'package:chime/components/settings/settings_title.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/settings/interval_bells/bell_volume_slider.dart';
import '../components/settings/interval_bells/bells_checkbox_tile.dart';
import '../configs/constants.dart';
import '../enums/bell.dart';

class MeditationBellsPage extends ConsumerWidget {
  const MeditationBellsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const SettingsTitle(
            icon: Icon(Icons.audiotrack_outlined), text: 'Meditation Bells'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(size.height * kSettingsListWidthIndentation),
              child: const BellVolumeSlider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * kSettingsListWidthIndentation ),
              child: ListView.builder(
                itemCount: Bell.values.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => BellsCheckBoxTile(
                  bell: Bell.values.elementAt(index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
