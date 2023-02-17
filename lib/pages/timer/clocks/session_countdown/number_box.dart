
import 'package:flutter/material.dart';

class NumberBox extends StatelessWidget {
  const NumberBox(
      this.number, {
        super.key,
      });

  final int number;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.20,
      child: Text(
        number.toString().padLeft(2, '0'),
        style: Theme.of(context).textTheme.displayLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}
