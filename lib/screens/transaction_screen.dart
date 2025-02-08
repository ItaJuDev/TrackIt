import 'package:flutter/material.dart';
import 'package:trackit/models/transaction.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  // Mock data for transactions
  final List<Transaction> transactions = [
    Transaction(
      isIncome: true,
      category: 'Salary',
      date: DateTime.now(),
      amount: 5000.0,
      details: 'Monthly salary',
    ),
    Transaction(
      isIncome: false,
      category: 'Groceries',
      date: DateTime.now().subtract(Duration(days: 5)),
      amount: 1500.0,
      details: 'Grocery shopping',
    ),
    Transaction(
      isIncome: true,
      category: 'Freelance',
      date: DateTime.now().subtract(Duration(days: 10)),
      amount: 2000.0,
      details: 'Freelance work payment',
    ),
    Transaction(
      isIncome: false,
      category: 'Transport',
      date: DateTime.now().subtract(Duration(days: 2)),
      amount: 500.0,
      details: 'Transport expenses',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            // List of transactions
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: Icon(
                        transaction.isIncome
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: transaction.isIncome ? Colors.green : Colors.red,
                      ),
                      title: Text(transaction.details), // Showing details
                      subtitle: Text('Category: ${transaction.category}'),
                      trailing:
                          Text('${transaction.amount.toStringAsFixed(2)} baht'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
