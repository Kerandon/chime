import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../components/settings/color_theme_checkbox.dart';
import '../../components/settings/settings_title.dart';
import '../../configs/constants.dart';
import '../../enums/color_themes.dart';

class ColorThemePage extends ConsumerWidget {
  const ColorThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const SettingsTitle(
            icon: Icon(Icons.color_lens_outlined), text: 'Color theme'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width *kPageIndentation,
          ),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: ColorTheme.values.length,
            itemBuilder: (context, index) => ColorThemeCheckbox(
              colorTheme: ColorTheme.values.elementAt(index),
            ),
          ),
        ),
      ),
    );
  }
}
