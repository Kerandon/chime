import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(top: size.height * 0.05, bottom: size.height * 0.01),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Colors.white54),
      ),
    );
  }
}
