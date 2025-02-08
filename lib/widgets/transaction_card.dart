import 'package:flutter/material.dart';
import 'package:trackit/models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: ListTile(
        leading: Icon(
          transaction.isIncome ? Icons.arrow_upward : Icons.arrow_downward,
          color: transaction.isIncome ? Colors.green : Colors.red,
        ),
        title: Text(transaction.category),
        subtitle: Text(transaction.date.toString().split(' ')[0]), // Show date
        trailing: Text('\$${transaction.amount.toStringAsFixed(2)}'),
      ),
    );
  }
}
