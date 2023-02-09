
import 'package:flutter/material.dart';

import '../../../models/day_time_model.dart';

class LinearChart extends StatelessWidget {
  const LinearChart({
    required this.dayTimes,
    super.key,
  });

  final List<DayTimeModel> dayTimes;


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.03,
      child:

      ClipRRect(
        borderRadius: BorderRadius.circular(size.height* 0.10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(dayTimes.length, (index) => Expanded(
            flex: (dayTimes[index].percent * 100).toInt(),
            child: Container(color: dayTimes[index].color,),))

          // List<Widget>.generate(
          //   dayTimes.length,
          //       (int index) {
          //     return Container(
          //       width: (size.width * 0.90
          //       ) *
          //           (dayTimes[index].percent - (index == 0 ? 0 : dayTimes[index - 1].percent)),
          //       color: dayTimes[index].color,
          //     );
          //
          //
          //   },
          // ),
        ),
      ),
    );
  }
}
