
import 'package:chime/configs/app_colors.dart';
import 'package:flutter/material.dart';

class CustomSwitchTile extends StatelessWidget {
  const CustomSwitchTile({
    super.key, required this.title, required this.icon, required this.value, required this.onChanged,
  });

  final String title;
  final IconData icon;
  final bool value;
  final Function(bool) onChanged;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
      child: SwitchListTile(
        inactiveTrackColor: AppColors.grey,
        inactiveThumbColor: AppColors.lightGrey,
        onChanged: onChanged,
        value: value,
        title: Row(
          children: [
            Icon(icon),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.03),
              child: Text(title),
            ),
          ],
        ),
      ),
    );
  }
}
