import 'package:flutter/material.dart';
import 'package:trackit/data/local_db.dart';
import 'package:trackit/screens/Main/edit_transaction_screen.dart';
import 'package:trackit/widgets/Main/transaction_card.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];

        return Dismissible(
          key: Key(transaction.id.toString()),
          direction: DismissDirection.endToStart,
          background: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('ยืนยันการลบ'),
                content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบธุรกรรมนี้?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('ยกเลิก'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('ลบ'),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) async {
            await localDb.deleteTransaction(transaction.id);
          },
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EditTransactionScreen(transaction: transaction),
                ),
              );
            },
            child: TransactionCard(transaction: transaction),
          ),
        );
      },
    );
  }
}
