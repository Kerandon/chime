
import 'package:flutter/material.dart';

class Colon extends StatelessWidget {
  const Colon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.03,
      child: Text(
        ':',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }
}
