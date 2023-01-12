
import 'package:flutter/material.dart';

class StreakCounter extends StatelessWidget {
  const StreakCounter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: const Alignment(0.80, -0.80),
      child: SizedBox(
        width: size.width * 0.20,
        height: size.height * 0.10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Day 2',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white54, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
