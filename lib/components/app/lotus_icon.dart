import 'package:flutter/material.dart';

class LotusIcon extends StatelessWidget {
  const LotusIcon({
    super.key, this.width,
  });

  final double? width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
        width: width ?? size.width * 0.10,
        height: width ?? size.width * 0.10,
        child: Image.asset('assets/images/lotus.png', color: Theme.of(context).primaryColor));
  }
}
