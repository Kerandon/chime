import 'package:flutter/material.dart';

class CompletionStatBox extends StatelessWidget {
  const CompletionStatBox({
    super.key,
    required this.text,
    required this.value,
  });

  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
        Text(text),
      ],
    );
  }
}
