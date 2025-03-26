import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackit/data/local_db.dart';
import 'package:trackit/widgets/Summarize/summary_card.dart';

class SummaryHeader extends StatelessWidget {
  final List<Transaction> transactions;
  final formatter = NumberFormat("#,##0.00", "en_US");

  SummaryHeader({super.key, required this.transactions});

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
          child: SummaryCard(title: 'รายรับ', value: totalIncome.toString()),
        ),
        SizedBox(width: 20),
        Expanded(
          child: SummaryCard(title: 'รายจ่าย', value: totalExpense.toString()),
        ),
      ],
    );
  }
}
