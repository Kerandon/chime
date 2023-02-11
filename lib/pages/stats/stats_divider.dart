
import 'package:flutter/material.dart';

class StatsDivider extends StatelessWidget {
  const StatsDivider({this.padding,
    super.key,
  });

 final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: size.height * 0.05),
      child: Divider(
        color: Theme.of(context).secondaryHeaderColor,
      ),
    );
  }
}

