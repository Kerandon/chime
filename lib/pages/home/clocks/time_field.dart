import 'package:flutter/material.dart';
import '../../../configs/app_colors.dart';
import 'custom_number_picker.dart';

class TimeField extends StatelessWidget {
  const TimeField({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        width: size.width * 0.80,
        height: size.height * 0.25,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const CustomNumberPicker(alignment: MainAxisAlignment.end, text: 'H',),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: VerticalDivider(
                  indent: size.height * 0.05,
                endIndent: size.height * 0.05,
                  color: AppColors.darkGrey,
                ),
              ),
              const CustomNumberPicker(alignment: MainAxisAlignment.start, text: 'M',)

            ],
          ),
        ),
      ),
    );
  }
}
