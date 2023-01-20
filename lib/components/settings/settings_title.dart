import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsTitle extends StatelessWidget {
  const SettingsTitle({
    super.key,
    required this.text,
    this.icon,
    this.faIcon,
  });

  final String text;
  final Icon? icon;
  final FaIcon? faIcon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          icon ?? faIcon!,
          Padding(
            padding: EdgeInsets.only(left: size.width * 0.03),
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
