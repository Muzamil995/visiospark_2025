import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import '../../theme/app_colors.dart';

class LineChartData {
  final String label;
  final double value;

  LineChartData({
    required this.label,
    required this.value,
  });
}

class LineChartWidget extends StatelessWidget {
  final List<LineChartData> data;
  final String? title;
  final double height;
  final Color? lineColor;
  final bool showDots;
  final bool showGrid;

  const LineChartWidget({
    super.key,
    required this.data,
    this.title,
    this.height = 200,
    this.lineColor,
    this.showDots = true,
    this.showGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = lineColor ?? AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        SizedBox(
          height: height,
          child: fl.LineChart(
            fl.LineChartData(
              lineBarsData: [
                fl.LineChartBarData(
                  spots: data.asMap().entries.map((entry) {
                    return fl.FlSpot(entry.key.toDouble(), entry.value.value);
                  }).toList(),
                  isCurved: true,
                  color: color,
                  barWidth: 3,
                  dotData: fl.FlDotData(show: showDots),
                  belowBarData: fl.BarAreaData(
                    show: true,
                    color: color.withValues(alpha: 0.1),
                  ),
                ),
              ],
              titlesData: fl.FlTitlesData(
                bottomTitles: fl.AxisTitles(
                  sideTitles: fl.SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < data.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            data[value.toInt()].label,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                leftTitles: const fl.AxisTitles(
                  sideTitles: fl.SideTitles(showTitles: false),
                ),
                topTitles: const fl.AxisTitles(
                  sideTitles: fl.SideTitles(showTitles: false),
                ),
                rightTitles: const fl.AxisTitles(
                  sideTitles: fl.SideTitles(showTitles: false),
                ),
              ),
              borderData: fl.FlBorderData(show: false),
              gridData: fl.FlGridData(show: showGrid),
            ),
          ),
        ),
      ],
    );
  }
}
