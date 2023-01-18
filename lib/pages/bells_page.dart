import 'package:chime/components/settings/settings_title.dart';
import 'package:chime/components/settings/ambience_volume_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/settings/bell_volume_slider.dart';
import '../components/settings/bells_checkbox_tile.dart';
import '../enums/bell.dart';

class BellsPage extends ConsumerWidget {
  const BellsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SettingsTitle(
                icon: Icon(
                  Icons.audiotrack_outlined,
                  color: Colors.white,
                ),
                text: 'Interval Bell'),
            const BellVolumeSlider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
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
