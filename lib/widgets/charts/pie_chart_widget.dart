import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import '../../theme/app_colors.dart';

class PieChartData {
  final String label;
  final double value;
  final Color? color;

  PieChartData({
    required this.label,
    required this.value,
    this.color,
  });
}

class PieChartWidget extends StatelessWidget {
  final List<PieChartData> data;
  final String? title;
  final double height;
  final bool showLegend;
  final double radius;

  const PieChartWidget({
    super.key,
    required this.data,
    this.title,
    this.height = 200,
    this.showLegend = true,
    this.radius = 80,
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
          child: Row(
            children: [
              Expanded(
                child: fl.PieChart(
                  fl.PieChartData(
                    sections: _buildSections(),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              if (showLegend) ...[
                const SizedBox(width: 16),
                _buildLegend(context),
              ],
            ],
          ),
        ),
      ],
    );
  }

  List<fl.PieChartSectionData> _buildSections() {
    return data.asMap().entries.map((entry) {
      final color = entry.value.color ??
          AppColors.chartColors[entry.key % AppColors.chartColors.length];
      return fl.PieChartSectionData(
        value: entry.value.value,
        color: color,
        title: '${entry.value.value.toStringAsFixed(0)}%',
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        radius: radius,
      );
    }).toList();
  }

  Widget _buildLegend(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.asMap().entries.map((entry) {
        final color = entry.value.color ??
            AppColors.chartColors[entry.key % AppColors.chartColors.length];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                entry.value.label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
