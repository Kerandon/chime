
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../configs/app_colors.dart';
import '../../../../state/app_state.dart';

class BellListTile extends ConsumerWidget {
  const BellListTile({required this.text, required this.value, required this.onChanged,
    super.key,
  });

  final String text;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider);
    final notifier = ref.read(stateProvider.notifier);
    return SwitchListTile(
      inactiveTrackColor: AppColors.grey,
      inactiveThumbColor: AppColors.lightGrey,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
          ),
        ],
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
