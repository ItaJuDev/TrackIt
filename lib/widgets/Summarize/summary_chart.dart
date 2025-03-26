import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trackit/data/local_db.dart';
import 'package:trackit/utils/color_utils.dart';

class SummaryChart extends StatelessWidget {
  final List<Transaction> transactions;
  final bool showIncome;
  final Map<String, Color> categoryColors;

  const SummaryChart({
    required this.transactions,
    required this.showIncome,
    required this.categoryColors,
  });

  @override
  Widget build(BuildContext context) {
    final data = transactions.where((t) => t.isIncome == showIncome).toList();
    final total = data.fold(0.0, (sum, t) => sum + t.amount);

    final sections = <PieChartSectionData>[];
    final Map<String, double> categoryTotals = {};

    for (var t in data) {
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
    }

    categoryTotals.forEach((category, amount) {
      final color = categoryColors[category] ?? Colors.grey;
      final percent = (amount / total) * 100;
      sections.add(PieChartSectionData(
        value: percent,
        title: '$category ${percent.toStringAsFixed(0)}%',
        color: color,
        radius: 90,
        titleStyle: TextStyle(
          color: getContrastingTextColor(color),
          fontWeight: FontWeight.w600,
          fontSize: 13,
          shadows: List.generate(4, (index) {
            final offset = [
              Offset(-1, -1),
              Offset(1, -1),
              Offset(1, 1),
              Offset(-1, 1),
            ][index];
            return Shadow(
              offset: offset,
              color: getContrastingTextColor(color) == Colors.black
                  ? Colors.white
                  : Colors.black,
            );
          }),
        ),
      ));
    });

    return SizedBox(
      height: 300,
      child: PieChart(PieChartData(
        sections: sections,
        centerSpaceRadius: 70,
        sectionsSpace: 5,
      )),
    );
  }
}
