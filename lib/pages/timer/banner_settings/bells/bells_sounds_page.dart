import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../configs/constants.dart';
import '../../../../../enums/bell.dart';
import '../../../settings/components/settings_title.dart';
import 'bell_volume_slider.dart';
import 'bells_checkbox_tile.dart';

class BellsSoundsPage extends ConsumerWidget {
  const BellsSoundsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const SettingsTitle(
            icon: Icon(Icons.audiotrack_outlined), text: 'Bell Sounds'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(size.height * kPageIndentation),
              child: const BellVolumeSlider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * kPageIndentation ),
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
