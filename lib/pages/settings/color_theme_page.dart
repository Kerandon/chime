import 'package:flutter/material.dart';

class ColorTheme extends StatelessWidget {
  const ColorTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Color Theme'),
      leading: Icon(Icons.color_lens_outlined),
      ),
    );
  }
}
