
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../configs/constants.dart';

class LoadingBar extends StatelessWidget {
  const LoadingBar({
    super.key, required this.index, required this.currentIndex,
  });

  final int index;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return index == currentIndex ?
    buildBar(size, Theme.of(context).primaryColor)
        : buildBar(size, Theme.of(context).colorScheme.secondary.withOpacity(0.50));
  }

  Padding buildBar(Size size, Color color) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.01),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadius),
              color: color
          ),
          height: size.height * 0.05,
          width: size.width * 0.02,
        )
    )..animate().shimmer();
  }
}
