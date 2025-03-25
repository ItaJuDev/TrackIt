import 'package:flutter/material.dart';
import 'package:trackit/data/local_db.dart';
import 'package:trackit/widgets/Main/transaction_list.dart';
import 'package:trackit/widgets/Summarize/summary_header.dart';

class TransactionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Column(
            children: [
              // Gradient Header
              Container(
                width: double.infinity,
                height: 220,
                padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'เป้าหมาย',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '500บาท/วัน',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              // Transaction List
              Expanded(
                child: StreamBuilder<List<Transaction>>(
                  stream: localDb.watchAllTransactions(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final transactions = snapshot.data!;
                    if (transactions.isEmpty) {
                      return Center(child: Text('ไม่มีข้อมูลธุรกรรม'));
                    }

                    return TransactionList(
                        transactions: transactions); // ⬅️ Inside Expanded
                  },
                ),
              ),
            ],
          ),
          // Summary Cards
          Positioned(
              top: 180,
              left: 20,
              right: 20,
              child: StreamBuilder<List<Transaction>>(
                stream: localDb.watchAllTransactions(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return SizedBox();
                  return SummaryHeader(transactions: snapshot.data!);
                },
              )),
        ],
      ),
    );
  }
}
