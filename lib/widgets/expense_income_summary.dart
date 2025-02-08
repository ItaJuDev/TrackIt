import 'package:flutter/material.dart';

class ExpenseIncomeSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // These values should be dynamically calculated based on transactions
    double totalIncome = 700.0;
    double totalExpense = 100.0;
    double balance = totalIncome - totalExpense;

    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Total Income: \$${totalIncome.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Total Expense: \$${totalExpense.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Balance: \$${balance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
