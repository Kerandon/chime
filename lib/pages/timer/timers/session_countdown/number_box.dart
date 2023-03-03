import 'package:flutter/material.dart';

class NumberBox extends StatelessWidget {
  const NumberBox(
    this.number, {
    super.key,
  });

  final String number;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 60,
      child: Center(
        child: Text(
          number,
          //  number.toString().padLeft(2, '0'),
          style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
