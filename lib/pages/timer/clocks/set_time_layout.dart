import 'package:flutter/material.dart';
import '../../../configs/constants.dart';
import 'number_picker/custom_number_picker.dart';

class SetTimeFieldLayout extends StatelessWidget {
  const SetTimeFieldLayout({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * kClocksHeight,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomNumberPicker(alignment: MainAxisAlignment.end, text: 'H',),
            Padding(
              padding: EdgeInsets.only(left: size.width * 0.01),
              child: VerticalDivider(
                indent: size.height * 0.05,
              endIndent: size.height * 0.05,
              ),
            ),
            const CustomNumberPicker(alignment: MainAxisAlignment.start, text: 'M',)

          ],
        ),
      ),
    );
  }
}
