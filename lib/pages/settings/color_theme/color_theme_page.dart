import 'package:chime/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../app_components/custom_slider_tile.dart';
import '../../../configs/app_colors.dart';
import '../../../enums/app_color_themes.dart';
import '../../../state/app_state.dart';
import '../../../app_components/custom_animated_grid_box.dart';

class ColorTheme extends ConsumerWidget {
  const ColorTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Theme'),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: size.width * kPageIndentation),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomSwitchTile(
                  title: 'Dark theme',
                  icon: Icons.dark_mode_outlined,
                  value: appState.isDarkTheme,
                  onChanged: (value) => appNotifier.setBrightness(value)),
              GridView.builder(
                itemCount: AppColorTheme.values.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final colorTheme = AppColorTheme.values.elementAt(index);
                  return CustomAnimatedGridBox(
                    labelText: colorTheme.name,
                    onPressed: () async => appNotifier.setColorTheme(colorTheme),
                    isSelected: colorTheme == appState.colorTheme,
                    contents: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorderRadius),
                        color: AppColors.themeColors
                            .firstWhere((element) =>
                                element.color.name == colorTheme.name)
                            .arbg,
                      ),
                    ),
                    selectedLabelColor: Theme.of(context).canvasColor,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
