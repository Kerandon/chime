import 'package:chime/configs/constants.dart';
import 'package:chime/pages/settings/color_theme/dark_mode_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../configs/app_colors.dart';
import '../../../enums/app_color_themes.dart';
import '../../../enums/prefs.dart';
import '../../../state/app_state.dart';
import '../../../state/database_manager.dart';
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
              Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.02, bottom: size.height * 0.03),
                child: const DarkThemeSwitchButton(),
              ),
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
                    onPressed: () async {
                      appNotifier.setColorTheme(colorTheme);
                      await DatabaseManager().insertIntoPrefs(
                          k: Prefs.colorTheme.name, v: colorTheme.name);
                    },
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
