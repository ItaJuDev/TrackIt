import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:trackit/data/local_db.dart';
import 'package:trackit/widgets/Summarize/summary_card.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool showIncome = true;
  DateTime selectedDate = DateTime.now();
  String filterMode = 'Monthly';

  List<Transaction> _filterTransactions(List<Transaction> all) {
    return all.where((t) {
      final tDate = DateTime.parse(t.date);
      return tDate.year == selectedDate.year &&
          tDate.month == selectedDate.month;
    }).toList();
  }

  String _formattedDate() {
    return DateFormat('MMM yyyy').format(selectedDate);
  }

  void _goToPreviousPeriod() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
    });
  }

  void _goToNextPeriod() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
    });
  }

  Future<void> _selectDate() async {
    final picked = await showMonthPicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        headerColor: Colors.purple,
        unselectedMonthTextColor: Colors.black);
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<List<Transaction>>(
        stream: localDb.watchAllTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final transactions = _filterTransactions(snapshot.data!);
          return buildSummary(transactions);
        },
      ),
    );
  }

  Widget buildSummary(List<Transaction> transactions) {
    double totalIncome = transactions
        .where((t) => t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);
    double totalExpense = transactions
        .where((t) => !t.isIncome)
        .fold(0, (sum, t) => sum + t.amount);

    final filtered =
        transactions.where((t) => t.isIncome == showIncome).toList();

    final Map<String, double> categoryTotals = {};
    for (var t in filtered) {
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
    }

    final double total = showIncome ? totalIncome : totalExpense;

    final pieSections = categoryTotals.entries.map((entry) {
      final percent = (entry.value / total) * 100;
      return PieChartSectionData(
        value: percent,
        title: '${entry.key}\n${percent.toStringAsFixed(0)}%',
        color: getCategoryColor(entry.key),
        radius: 80,
        titleStyle: TextStyle(color: Colors.white, fontSize: 12),
      );
    }).toList();

    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            bottom: 20,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: _goToPreviousPeriod,
                  ),
                  GestureDetector(
                    onTap: _selectDate,
                    child: Text(
                      _formattedDate(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: _goToNextPeriod,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => showIncome = true),
                  child: SummaryCard(
                    title: 'รายรับ',
                    value: totalIncome.toStringAsFixed(0),
                    isSelected: showIncome,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => showIncome = false),
                  child: SummaryCard(
                    title: 'รายจ่าย',
                    value: totalExpense.toStringAsFixed(0),
                    isSelected: !showIncome,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: pieSections,
              sectionsSpace: 5,
              centerSpaceRadius: 70,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: categoryTotals.entries.map((e) {
              return ListTile(
                leading: Icon(Icons.category, color: getCategoryColor(e.key)),
                title: Text(e.key),
                trailing: Text('${e.value.toStringAsFixed(0)} บาท'),
              );
            }).toList(),
          ),
        )
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
