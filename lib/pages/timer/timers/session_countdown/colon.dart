
import 'package:flutter/material.dart';

class Colon extends StatelessWidget {
  const Colon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(

      width: 10,
      height: 60,
      child: Center(
        child: Text(
          ':',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
    );
  }
}
