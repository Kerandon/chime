import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.title,
    required this.onPressed,
    this.subTitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String? subTitle;
  final Icon icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
      ),
      subtitle: subTitle != null
          ? Text(
              subTitle!,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            )
          : null,
      onTap: onPressed,
      trailing: const Icon(
        Icons.arrow_forward_ios_outlined,
      ),
    );
  }
}
