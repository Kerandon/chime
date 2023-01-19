import 'package:chime/animation/fade_in_animation.dart';
import 'package:flutter/material.dart';

import '../components/settings/settings_title.dart';
import '../configs/app_colors.dart';
import '../configs/constants.dart';

class MeditationGuidePage extends StatelessWidget {
  const MeditationGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * kSettingsHorizontalPageIndent),
          child: Column(
            children: [
              SettingsTitle(
                icon: Icon(
                  Icons.tips_and_updates_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                text: 'Step by step guide',
              ),
              SizedBox(
                  height: size.height * kSettingsImageHeight,
                  child: FadeInAnimation(
                    child: Image.asset(
                      'assets/images/people/person_1.png',
                      fit: BoxFit.fitHeight,
                    ),
                  )),
              Text.rich(
                TextSpan(
                  text: '\nStep 1',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 20,
                        color: AppColors.lightGrey,
                        fontWeight: FontWeight.w500,
                      ),
                  children: [
                    TextSpan(
                        text: '\n\nPlace your attention on your breath',
                        style: Theme.of(context).textTheme.bodyMedium),
                    TextSpan(
                      text: '\n\nStep 2',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.lightGrey,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    TextSpan(
                      text:
                          '\n\nIf your mind has wandered, the interval bells are a gentle reminder to return your attention to your breath',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextSpan(
                      text: '\n\nStep 3',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.lightGrey,
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
