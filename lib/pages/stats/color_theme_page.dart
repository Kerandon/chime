import 'package:chime/configs/constants.dart';
import 'package:chime/pages/settings/dark_mode/dark_mode_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../configs/app_colors.dart';
import '../../enums/app_color_themes.dart';
import '../../enums/prefs.dart';
import '../../state/app_state.dart';
import '../../state/database_manager.dart';

class ColorThemeP extends StatelessWidget {
  const ColorThemeP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final spacing = size.width * 0.0;
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                  ),
                  itemBuilder: (context, index) => ColorThemeBox(
                        colorTheme: AppColorTheme.values.elementAt(index),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}

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
