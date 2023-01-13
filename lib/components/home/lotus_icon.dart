import 'package:flutter/material.dart';

class LotusIcon extends StatelessWidget {
  const LotusIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/lotus.png', color: Theme.of(context).primaryColor);
  }
}
