import 'package:flutter/material.dart';

class TimerButton extends StatelessWidget {
  const TimerButton({Key? key, required this.label}) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(fontSize: 20),
      ),
    );
  }
}
