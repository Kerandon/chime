import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../components/settings/settings_title.dart';
import '../../configs/constants.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const SettingsTitle(
          text: 'Meditation guide',
          icon: Icon(
            FontAwesomeIcons.book,
          ),
        ),

      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * kSettingsHorizontalPageIndent),
          child: Column(
            children: [
              Text.rich(
                TextSpan(
                  text: '\nStep 1',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                  children: [
                    TextSpan(
                        text: '\n\nPlace your attention on your breath',
                        style: Theme.of(context).textTheme.bodyMedium),
                    TextSpan(
                      text: '\n\nStep 2',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    TextSpan(
                      text:
                          '\n\nIf you find your mind has wandered, gently return your attention to your breath',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: '\n\nStep 3',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    TextSpan(
                      text: '\n\nRepeat\n\n',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
