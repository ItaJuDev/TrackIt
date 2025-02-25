import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:trackit/models/transaction.dart';
import 'package:trackit/widgets/transaction_card.dart';
import 'package:trackit/widgets/summary_card.dart';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late Future<List<Transaction>> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = loadTransactions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshData(); // Reload transactions when returning to this screen
  }

  Future<void> _refreshData() async {
    setState(() {
      debugPrint('Refreshing data...');
      _transactions = loadTransactions();

      buildTransactionList(_transactions as List<Transaction>);
    });
  }

  Future<List<Transaction>> loadTransactions() async {
    // Load JSON from assets
    String jsonString = await rootBundle.loadString('assets/transaction.json');
    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Transaction.fromJson(json)).toList();
  }

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
                child: RefreshIndicator(
                  onRefresh: _refreshData, // Trigger the refresh
                  child: FutureBuilder<List<Transaction>>(
                    future: _transactions,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('ไม่มีข้อมูลธุรกรรม'));
                      } else {
                        return buildTransactionList(snapshot.data!);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          // Floating Summary Cards
          Positioned(
            top: 180,
            left: 20,
            right: 20,
            child: FutureBuilder<List<Transaction>>(
              future: _transactions,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return SizedBox(); // Hide if no data
                return buildSummary(snapshot.data!);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTransactionList(List<Transaction> transactions) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];

        return Dismissible(
          key: Key(
              transaction.date + transaction.amount.toString()), // Unique key
          direction: DismissDirection.endToStart,
          background: ClipRRect(
            borderRadius: BorderRadius.circular(15), // Adjust as needed
            child: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          onDismissed: (direction) {
            setState(() {
              transactions.removeAt(index);
            });
            // await saveTransactions(transactions);
            // _refreshData();
          },
          child: TransactionCard(transaction: transaction),
        );
      },
    );
  }

  Widget buildSummary(List<Transaction> transactions) {
    double totalIncome = transactions
        .where((t) => t.isIncome)
        .fold(0, (sum, item) => sum + item.amount);
    double totalExpense = transactions
        .where((t) => !t.isIncome)
        .fold(0, (sum, item) => sum + item.amount);

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: SummaryCard(
                  title: 'รายรับ',
                  value: '${totalIncome.toStringAsFixed(0)} บาท'),
            ),
            SizedBox(width: 20),
            Expanded(
              child: SummaryCard(
                  title: 'รายจ่าย',
                  value: '${totalExpense.toStringAsFixed(0)} บาท'),
            ),
          ],
        ));
  }
}
