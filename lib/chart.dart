import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'character.dart';

class CustomTipIndicator extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final String text;

  const CustomTipIndicator({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final History history;
  //final List<BarChartGroupData> group ;

  const _BarChart(this.history);

  @override
  Widget build(BuildContext context) {
    var max = 0;
    for (final l in history.list) {
      if (l.exp > max) {
        max = l.exp;
      }
    }
    var base = 0;
    if (max > 1000000000000) {
      base = 1000000000000;
    } else if (max > 1000000000) {
      base = 1000000000;
    } else if (max > 1000000) {
      base = 1000000;
    } else if (max > 1000) {
      base = 1000;
    }
    int roundedNumber = ((max / base + 9) ~/ 10) * 10;

    final group = initGroup(base);
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: group,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: roundedNumber / 1.0,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          //fitInsideHorizontally: true ,
          fitInsideVertically: true,
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Color(0xFF50E4FF),
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: const Color(0xFF2196F3).darken(20),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '2-13';
        break;
      case 1:
        text = '2-14';
        break;
      case 2:
        text = '2-15';
        break;
      case 3:
        text = '2-16';
        break;
      case 4:
        text = '2-17';
        break;
      case 5:
        text = '2-18';
        break;
      case 6:
        text = '2-19';
        break;
      default:
        text = '2-20';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          // sideTitles: SideTitles(showTitles: true),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 1,
            getTitlesWidget: leftTitles,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          const Color(0xFF2196F3).darken(20),
          const Color(0xFF50E4FF),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> initGroup(int base) {
    List<BarChartGroupData> group = [];
    for (int i = 0; i < history.list.length; i++) {
      group.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: (history.list[i].exp / 1.0) / (base / 1.0),
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      ));
    }
    return group;
  }

  /*
  List<BarChartGroupData> get barGroups => [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: 8,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
          toY: 10,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
          toY: 14,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: 15,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 4,
      barRods: [
        BarChartRodData(
          toY: 13,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 5,
      barRods: [
        BarChartRodData(
          toY: 10,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 6,
      barRods: [
        BarChartRodData(
          toY: 16,
          gradient: _barsGradient,
        )
      ],
      showingTooltipIndicators: [0],
    ),
  ];
   */
}

Widget leftTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color(0xff7589a2),
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text;
  if (value == 0) {
    text = '1K';
  } else if (value == 10) {
    text = '5K';
  } else if (value == 19) {
    text = '10K';
  } else {
    return Container();
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 0,
    child: Text(text, style: style),
  );
}

class BarChartSample3 extends StatefulWidget {
  final History history;
  const BarChartSample3(this.history, {super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1.6,
        child: _BarChart(widget.history),
      ),
    );
  }
}

extension ColorExtension on Color {
  /// Convert the color to a darken color based on the [percent]
  Color darken([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = 1 - percent / 100;
    return Color.fromARGB(
      alpha,
      (red * value).round(),
      (green * value).round(),
      (blue * value).round(),
    );
  }

  Color lighten([int percent = 40]) {
    assert(1 <= percent && percent <= 100);
    final value = percent / 100;
    return Color.fromARGB(
      alpha,
      (red + ((255 - red) * value)).round(),
      (green + ((255 - green) * value)).round(),
      (blue + ((255 - blue) * value)).round(),
    );
  }

  Color avg(Color other) {
    final red = (this.red + other.red) ~/ 2;
    final green = (this.green + other.green) ~/ 2;
    final blue = (this.blue + other.blue) ~/ 2;
    final alpha = (this.alpha + other.alpha) ~/ 2;
    return Color.fromARGB(alpha, red, green, blue);
  }
}
