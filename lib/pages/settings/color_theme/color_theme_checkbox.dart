import 'package:chime/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../configs/app_colors.dart';
import '../../../state/database_manager.dart';
import '../../../enums/app_color_themes.dart';
import '../../../enums/prefs.dart';
import '../../../state/app_state.dart';

class ColorThemeCheckbox extends ConsumerWidget {
  const ColorThemeCheckbox({
    required this.colorTheme,
    super.key,
  });

  final AppColorTheme colorTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);

    return CheckboxListTile(
        title: Text(colorTheme.name.capitalize()),
        subtitle: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
          child: Align(
            alignment: const Alignment(-1.0, 0),
            child: Container(
              width: size.width * 0.30,
              height: size.height * 0.02,
              decoration: BoxDecoration(
                  color: AppColors.themeColors
                      .firstWhere(
                          (element) => element.color.name == colorTheme.name)
                      .arbg,
                  borderRadius: BorderRadius.circular(kBorderRadius)),
            ),
          ),
        ),
        value: colorTheme == state.colorTheme,
        onChanged: (value) async {
          await DatabaseManager()
              .insertIntoPrefs(k: Prefs.colorTheme.name, v: colorTheme.name);
          notifier.setColorTheme(colorTheme);
        });
  }
}
