import 'package:flutter/material.dart';

class SettingsTitleDivider extends StatelessWidget {
  const SettingsTitleDivider({
    super.key,
    this.title,
    this.hideDivider = false,
  });

  final String? title;
  final bool hideDivider;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        hideDivider
            ? SizedBox(
                height: size.height * 0.03,
              )
            : const Divider(),
        Align(
          alignment: const Alignment(-0.90, 0),
          child: title == null
              ? const SizedBox.shrink()
              : Text(
                  title!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Theme.of(context).secondaryHeaderColor, fontSize: 12),
                ),
        ),
      ],
    );
  }
}
