import 'package:chime/configs/constants.dart';
import 'package:chime/pages/settings/color_theme/dark_mode_switch_button.dart';
import 'package:flutter/material.dart';
import '../../../enums/app_color_themes.dart';
import 'color_theme_box.dart';


class ColorTheme extends StatelessWidget {
  const ColorTheme({Key? key}) : super(key: key);

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
