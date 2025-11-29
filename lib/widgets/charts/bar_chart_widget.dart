import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import '../../theme/app_colors.dart';

class BarChartData {
  final String label;
  final double value;
  final Color? color;

  BarChartData({
    required this.label,
    required this.value,
    this.color,
  });
}

class BarChartWidget extends StatelessWidget {
  final List<BarChartData> data;
  final String? title;
  final double height;
  final Color? barColor;

  const BarChartWidget({
    super.key,
    required this.data,
    this.title,
    this.height = 200,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
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
          child: fl.BarChart(
            fl.BarChartData(
              alignment: fl.BarChartAlignment.spaceAround,
              maxY: data.map((d) => d.value).reduce((a, b) => a > b ? a : b) * 1.2,
              barGroups: data.asMap().entries.map((entry) {
                return fl.BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    fl.BarChartRodData(
                      toY: entry.value.value,
                      color: entry.value.color ?? barColor ?? AppColors.primary,
                      width: 20,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                  ],
                );
              }).toList(),
              titlesData: fl.FlTitlesData(
                show: true,
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
              gridData: const fl.FlGridData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}
