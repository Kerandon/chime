import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.title,
    required this.onPressed,
    this.subTitle,
    this.icon,
    this.faIcon,
    super.key,
  });

  final String title;
  final String? subTitle;
  final Icon? icon;
  final FaIcon? faIcon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon ?? faIcon,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: subTitle != null ? Text(
        subTitle!,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Theme.of(context).primaryColor),
      ) : null,
      onTap: onPressed,
      trailing: const Icon(
        Icons.arrow_forward_ios_outlined,
        color: Colors.white,
      ),
    );
  }
}
