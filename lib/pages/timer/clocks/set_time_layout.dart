import 'package:flutter/material.dart';
import '../../../configs/constants.dart';
import 'custom_number_picker.dart';

class SetTimeFieldLayout extends StatelessWidget {
  const SetTimeFieldLayout({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * kClocksHeight,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const CustomNumberPicker(alignment: MainAxisAlignment.end, text: 'H',),
            VerticalDivider(
              indent: size.height * 0.05,
            endIndent: size.height * 0.05,
              color: Theme.of(context).secondaryHeaderColor,
            ),
            const CustomNumberPicker(alignment: MainAxisAlignment.start, text: 'M',)

          ],
        ),
      ),
    );
  }
}
