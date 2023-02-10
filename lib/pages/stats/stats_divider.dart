
import 'package:flutter/material.dart';

class StatsDivider extends StatelessWidget {
  const StatsDivider({this.removeTopPadding = false,
    super.key,
  });

 final bool removeTopPadding;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.height * 0.05;
    return Padding(
      padding: removeTopPadding ? EdgeInsets.only(bottom: padding) :
      EdgeInsets.symmetric(vertical: padding),
      child: Divider(
        color: Theme.of(context).secondaryHeaderColor,
      ),
    );
  }
}

