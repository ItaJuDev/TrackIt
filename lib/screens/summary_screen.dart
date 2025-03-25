import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fl_chart/fl_chart.dart';
import 'package:trackit/models/transaction.dart';
import 'package:trackit/widgets/Summarize/summary_card.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late Future<List<TransactionModel>> _transactions;
  bool showIncome =
      true; // State to track selected summary (true = Income, false = Expense)

  @override
  void initState() {
    super.initState();
    _transactions = loadTransactions();
  }

  // ===== Load Data from JSON ======
  Future<List<TransactionModel>> loadTransactions() async {
    String jsonString = await rootBundle.loadString('assets/transaction.json');
    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => TransactionModel.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<TransactionModel>>(
        future: _transactions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('เกิดข้อผิดพลาด'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('ไม่มีข้อมูล'));
          } else {
            return buildSummary(snapshot.data!);
          }
        },
      ),
    );
  }

// Inside buildSummary()
  Widget buildSummary(List<TransactionModel> transactions) {
    double totalIncome = transactions
        .where((t) => t.isIncome)
        .fold(0, (sum, item) => sum + item.amount);
    double totalExpense = transactions
        .where((t) => !t.isIncome)
        .fold(0, (sum, item) => sum + item.amount);

    // Filter transactions based on selected type
    List<TransactionModel> filteredTransactions =
        transactions.where((t) => t.isIncome == showIncome).toList();

    // Group transactions by category
    Map<String, double> categoryTotals = {};
    for (var t in filteredTransactions) {
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
    }

    // Pie Chart for Expenses
    List<PieChartSectionData> pieSections = categoryTotals.entries.map((entry) {
      double total =
          showIncome ? totalIncome : totalExpense; // Use correct total
      double percentage = (entry.value / total) * 100;

      return PieChartSectionData(
        color: getCategoryColor(entry.key),
        value: percentage,
        title: '${entry.key}\n${percentage.toStringAsFixed(0)}%',
        radius: 80,
      );
    }).toList();

    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            bottom: 20,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () {},
              ),
              Text(
                'ม.ค. 68',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Income & Expense Summary
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => showIncome = true),
                  child: SummaryCard(
                    title: 'รายรับ',
                    value: '$totalIncome',
                    isSelected: showIncome,
                  ),
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => showIncome = false),
                  child: SummaryCard(
                    title: 'รายจ่าย',
                    value: '$totalExpense',
                    isSelected: !showIncome,
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          height: 300,
          child: PieChart(PieChartData(sections: pieSections)),
        ),

        // Transaction List
        Expanded(
          child: ListView(
            children: categoryTotals.entries.map((entry) {
              return ListTile(
                leading:
                    Icon(Icons.category, color: getCategoryColor(entry.key)),
                title: Text(entry.key),
                trailing: Text('${entry.value.toStringAsFixed(0)} บาท'),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'อาหาร':
        return Colors.orange;
      case 'จ่ายบิล':
        return Colors.purple;
      case 'ทั่วไป':
        return Colors.pink;
      case 'เครื่องดื่ม':
        return Colors.yellow;
      case 'เดินทาง':
        return const Color.fromARGB(255, 119, 105, 248);
      default:
        return const Color.fromARGB(255, 57, 205, 69);
    }
  }
}
