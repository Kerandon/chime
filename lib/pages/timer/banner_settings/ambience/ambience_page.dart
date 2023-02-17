import 'package:chime/configs/constants.dart';
import 'package:chime/data/ambience_data.dart';
import 'package:chime/pages/timer/banner_settings/ambience/ambience_volume_slider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../configs/app_colors.dart';
import '../../../../state/app_state.dart';
import 'ambience_image_box.dart';

class AmbiencePage extends ConsumerWidget {
  const AmbiencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    final spacing = size.width * 0.02;
    return Scaffold(
        appBar: AppBar(title: const Text('Ambience')),
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: size.width * kPageIndentation),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SwitchListTile(
                    inactiveTrackColor: AppColors.grey,
                    inactiveThumbColor: AppColors.lightGrey,
                    title: const Text('Add ambience'),
                    value: state.ambienceIsOn,
                    onChanged: (value) {
                      notifier.setAmbienceIsOn(!state.ambienceIsOn);
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
                    itemBuilder: (context, index) => AmbienceImageBox(
                          ambienceData: ambienceData[index],
                        )),
              ],
            ),
          ),
        ));
  }
}
