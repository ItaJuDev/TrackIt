import 'package:flutter/material.dart';
import 'package:trackit/data/local_db.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final formatter = NumberFormat("#,##0.00", "en_US");

  TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      color: Colors.white,
      child: ListTile(
        leading: Icon(
          transaction.isIncome ? Icons.add : Icons.remove,
          color: transaction.isIncome ? Colors.green : Colors.red,
        ),
        title: Text(
          transaction.category,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(transaction.details ?? ''),
        trailing: Text(
          '${formatter.format(transaction.amount)} ฿',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
