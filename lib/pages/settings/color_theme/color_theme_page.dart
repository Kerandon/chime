import 'package:flutter/material.dart';
import '../components/settings_title.dart';
import 'color_theme_checkbox.dart';
import '../../../configs/constants.dart';
import '../../../enums/app_color_themes.dart';

class ColorThemePage extends StatelessWidget {
  const ColorThemePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const SettingsTitle(
            icon: Icon(Icons.color_lens_outlined), text: 'Color theme'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * kPageIndentation,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: AppColorTheme.values.length,
          itemBuilder: (context, index) => ColorThemeCheckbox(
            colorTheme: AppColorTheme.values.elementAt(index),
          ),
        ),
      ),
    );
  }
}
