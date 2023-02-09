import 'package:flutter/material.dart';

class LegendKey extends StatelessWidget {
  const LegendKey({
    super.key,
    required this.text,
    required this.color,
    required this.percent,
  });

  final String text;
  final Color color;
  final double percent;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.01
      ),
      child: SizedBox(
        width: size.width * 0.40,
        child: Row(
          children: [
            Container(
              width: size.width * 0.02,
              height: size.width * 0.02,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            Text(
              ' $text (${(percent * 100).toStringAsFixed(1)}%)',
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}
