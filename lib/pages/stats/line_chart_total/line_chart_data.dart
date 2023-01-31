import 'package:chime/models/stats_model.dart';
import 'package:chime/utils/methods.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'line_chart_total_main.dart';

LineChartData getData(
    {required BuildContext context,
    required Size size,
    required List<StatsModel> data,
    required List<LineChartAxis> axisData}) {


  double intervalX = 150, intervalY = 60;
  double totalMeditationTime = 0;

  data.sort((a, b) => a.dateTime.compareTo(b.dateTime));

  for (int i = 0; i < data.length; i++) {
    double difference =
        data[i].dateTime.difference(data.first.dateTime).inDays.toDouble();
    totalMeditationTime += data[i].totalMeditationTime.toDouble();

    if(totalMeditationTime > 0) {
      axisData.add(LineChartAxis(difference, totalMeditationTime),);
    }




  }

  if (data.isNotEmpty) {
    int totalDuration =
        data.last.dateTime.difference(data.first.dateTime).inDays;

    if (totalDuration <= 365) {
      intervalX = 150;
    } else if (totalDuration > 365) {
      intervalX = totalDuration / 5;
    }
  }

  if (totalMeditationTime <= 600) {
  } else if (totalMeditationTime > 600) {
    int divided = (totalMeditationTime ~/ 5);
    intervalY = (divided / 60).roundToDouble() * 60;
  }

  return LineChartData(
    borderData: borderData,
    gridData: FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          interval: intervalY,
          reservedSize: size.width * 0.10,
          showTitles: true,
          getTitlesWidget: (value, meta) {
            String formatted = value.toInt().formatToHour();
            if (value == meta.max) {
              formatted = "";
            }
            return Text(
              formatted,
              style: Theme.of(context).textTheme.labelSmall,
            );
          },
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          reservedSize: size.height * 0.10,
          interval: intervalX,
          showTitles: true,
          getTitlesWidget: (value, meta) {
            String formattedDate = "";
            double invertedValue = meta.max - value;
            DateTime dateX = DateTime.now();
            if (meta.max != value) {
              dateX = dateX.copyWith(day: -invertedValue.toInt());
              final formatter = DateFormat.yM();
              formattedDate = formatter.format(dateX);
            }

            return Padding(
              padding: EdgeInsets.all(size.width * 0.02),
              child: Text(formattedDate,
                  style: Theme.of(context).textTheme.labelSmall),
            );
          },
        ),
      ),
    ),
    lineBarsData: [
      LineChartBarData(
        color: Theme.of(context).primaryColor,
          isStrokeCapRound: true,
          dotData: FlDotData(show: false),
          barWidth: 6,
          spots: axisData.map(
            (e) {
              return FlSpot(e.x, e.y);
            },
          ).toList())
    ],
  );
}
