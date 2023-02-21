import 'package:flutter/material.dart';
import '../../../../configs/app_colors.dart';

class BellListTile extends StatelessWidget {
  const BellListTile({required this.text, required this.value, required this.onChanged,
    super.key,
  });

  final String text;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
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
