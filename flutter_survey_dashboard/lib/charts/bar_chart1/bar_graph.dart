import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_survey_dashboard/charts/bar_chart1/bar_data.dart';
import 'package:flutter_survey_dashboard/charts/bar_chart1/individual_bar.dart';

class MyBarGraph extends StatelessWidget {
  final List<CountryPopulation> countryData;
  const MyBarGraph({super.key, required this.countryData});

  @override
  Widget build(BuildContext context) {
    final uniqueIDs = assignUniqueIDs(countryData);
    final List<IndividualBar> bars = countryData
        .map((data) =>
            IndividualBar(x: uniqueIDs[data.nationality] ?? 0, y: data.count))
        .toList();

    double maxDataValue = 0;
    for (var data in bars) {
      if (data.y > maxDataValue) {
        maxDataValue = data.y;
      }
    }

    return BarChart(
      BarChartData(
        maxY: 100,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final data = countryData[groupIndex];
              final percentage = (data.count / 1005) * 100;
              return BarTooltipItem(
                '${percentage.toStringAsFixed(2)}%',
                const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              );
            },
          ),
          touchCallback:
              (FlTouchEvent event, BarTouchResponse? touchResponse) {},
        ),
        barGroups: bars
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: Colors.grey[800],
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: maxDataValue,
                      color: Colors.grey[200],
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

Map<String, int> assignUniqueIDs(List<CountryPopulation> countryData) {
  final uniqueIDs = <String, int>{};
  for (int i = 0; i < countryData.length; i++) {
    uniqueIDs[countryData[i].nationality] = i;
  }
  return uniqueIDs;
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('ID', style: style);
      break;
    case 1:
      text = const Text('SD', style: style);
      break;
    case 2:
      text = const Text('FR', style: style);
      break;
    case 3:
      text = const Text('MX', style: style);
      break;
    case 4:
      text = const Text('ZA', style: style);
      break;
    case 5:
      text = const Text('YE', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
