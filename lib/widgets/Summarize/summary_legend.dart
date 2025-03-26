import 'package:flutter/material.dart';
import 'package:trackit/data/local_db.dart';
import 'package:trackit/utils/color_utils.dart';

class SummaryLegend extends StatelessWidget {
  final List<Transaction> transactions;
  final bool showIncome;
  final Map<String, Color> categoryColors;
  final void Function(String category) onEditColor;

  const SummaryLegend({
    required this.transactions,
    required this.showIncome,
    required this.categoryColors,
    required this.onEditColor,
  });

  @override
  Widget build(BuildContext context) {
    final filtered =
        transactions.where((t) => t.isIncome == showIncome).toList();

    final Map<String, double> categoryTotals = {};
    for (var t in filtered) {
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
    }

    return ListView(
      children: categoryTotals.entries.map((e) {
        final color = categoryColors[e.key] ?? Colors.grey;
        return ListTile(
          leading: GestureDetector(
            onTap: () => onEditColor(e.key),
            child: CircleAvatar(
              backgroundColor: color,
              radius: 14,
              child: Icon(
                Icons.edit,
                size: 14,
                color: getContrastingTextColor(color),
              ),
            ),
          ),
          title: Text(
            e.key,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            '${e.value.toStringAsFixed(0)} บาท',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        );
      }).toList(),
    );
  }
}
