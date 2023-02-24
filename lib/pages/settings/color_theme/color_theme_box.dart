
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../configs/app_colors.dart';
import '../../../configs/constants.dart';
import '../../../enums/app_color_themes.dart';
import '../../../enums/prefs.dart';
import '../../../state/app_state.dart';
import '../../../state/database_manager.dart';

class ColorThemeBox extends ConsumerWidget {
  const ColorThemeBox({
    super.key,
    required this.colorTheme,
  });

  final AppColorTheme colorTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            notifier.setColorTheme(colorTheme);
            await DatabaseManager()
                .insertIntoPrefs(k: Prefs.colorTheme.name, v: colorTheme.name);
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kBorderRadius),
                  border: Border.all(
                      color: colorTheme == state.colorTheme
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      width: 3),
                ),
                child: Padding(
                  padding: EdgeInsets.all(colorTheme == state.colorTheme ? size.width * 0.01 : size.width * 0.02),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      color: AppColors.themeColors
                          .firstWhere(
                              (element) => element.color.name == colorTheme.name)
                          .arbg,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    color: Theme.of(context).canvasColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.01),
                    child: Text(colorTheme.name, overflow: TextOverflow.ellipsis,),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: kFadeInTimeMilliseconds.milliseconds).scaleXY(begin: 0.90);
  }
}
