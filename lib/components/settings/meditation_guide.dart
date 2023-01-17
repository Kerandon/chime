import 'package:chime/components/settings/settings_close.dart';
import 'package:chime/components/settings/settings_title.dart';
import 'package:flutter/material.dart';

import '../../configs/app_colors.dart';

class MeditationGuide extends StatelessWidget {
  const MeditationGuide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      title: SettingsTitle(
        text: 'Step by step guide',
        icon: Icon(
          Icons.tips_and_updates_outlined,
          color: Theme.of(context).primaryColor,
        ),
      ),
      content: SizedBox(
        height: size.height * 0.50,
        child: Text.rich(
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
                  style: Theme.of(context).textTheme.bodySmall),
              TextSpan(
                text: '\n\nStep 2',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.lightGrey,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              TextSpan(
                  text:
                      '\n\nWhen you notice your mind has wandered, gently return your attention to your breath',
                  style: Theme.of(context).textTheme.bodySmall),
              TextSpan(
                text: '\n\nStep 3',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: AppColors.lightGrey,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              TextSpan(
                text: '\n\nRepeat',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
      actionsPadding: EdgeInsets.all(size.width * 0.05),
      actions: const [
        SettingsClose(),
      ],
    );
  }
}
