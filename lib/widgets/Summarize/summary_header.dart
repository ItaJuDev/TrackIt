import 'package:flutter/material.dart';
import 'package:trackit/data/local_db.dart';
import 'package:trackit/widgets/Summarize/summary_card.dart';

class SummaryHeader extends StatelessWidget {
  final List<Transaction> transactions;

  const SummaryHeader({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    double totalIncome = transactions
        .where((t) => t.isIncome)
        .fold(0, (sum, item) => sum + item.amount);
    double totalExpense = transactions
        .where((t) => !t.isIncome)
        .fold(0, (sum, item) => sum + item.amount);

    return Row(
      children: [
        Expanded(
          child: SummaryCard(
              title: 'รายรับ', value: '${totalIncome.toStringAsFixed(0)} บาท'),
        ),
        SizedBox(width: 20),
        Expanded(
          child: SummaryCard(
              title: 'รายจ่าย',
              value: '${totalExpense.toStringAsFixed(0)} บาท'),
        ),
      ],
    );
  }
}
