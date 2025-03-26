import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:trackit/data/local_db.dart';
import 'package:trackit/widgets/color_picker_dialog.dart';
import 'package:trackit/widgets/Summarize/summary_card.dart';
import 'package:trackit/widgets/Summarize/summary_header.dart';
import 'package:trackit/widgets/Summarize/summary_chart.dart';
import 'package:trackit/widgets/Summarize/summary_controls.dart';
import 'package:trackit/widgets/Summarize/summary_legend.dart';

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool showIncome = true;
  DateTime selectedDate = DateTime.now();
  Map<String, Color> categoryColors = {};

  @override
  void initState() {
    super.initState();
    _loadCategoryColors();
  }

  void _loadCategoryColors() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('categoryColors');
    if (saved != null) {
      final Map<String, dynamic> decoded = json.decode(saved);
      setState(() {
        categoryColors = decoded.map(
          (key, value) => MapEntry(key, Color(int.parse(value.toString()))),
        );
      });
    }
  }

  void _saveCategoryColors() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = categoryColors
        .map((key, value) => MapEntry(key, value.value.toString()));
    await prefs.setString('categoryColors', json.encode(encoded));
  }

  void changeCategoryColor(String category) async {
    final current = categoryColors[category] ?? Colors.grey;
    final usedColors = categoryColors.values.toSet().toList();

    final picked = await showColorPickerDialog(
      context: context,
      initialColor: current,
      presetColors: usedColors,
    );

    if (picked != null) {
      setState(() {
        categoryColors[category] = picked;
        _saveCategoryColors();
      });
    }
  }

  List<Transaction> _filterTransactions(List<Transaction> all) {
    return all.where((t) {
      final tDate = DateTime.parse(t.date);
      return tDate.year == selectedDate.year &&
          tDate.month == selectedDate.month;
    }).toList();
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
      unselectedMonthTextColor: Colors.black,
    );
    if (picked != null) {
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
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final filtered = _filterTransactions(snapshot.data!);
          return Column(
            children: [
              SummaryControls(
                selectedDate: selectedDate,
                onDateSelect: _selectDate,
                onPrev: _goToPreviousPeriod,
                onNext: _goToNextPeriod,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => showIncome = true),
                        child: SummaryCard(
                          title: 'รายรับ',
                          value: _getTotal(filtered, true).toString(),
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
                          value: _getTotal(filtered, false).toString(),
                          isSelected: !showIncome,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SummaryChart(
                transactions: filtered,
                showIncome: showIncome,
                categoryColors: categoryColors,
              ),
              Expanded(
                child: SummaryLegend(
                  transactions: filtered,
                  showIncome: showIncome,
                  categoryColors: categoryColors,
                  onEditColor: changeCategoryColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  double _getTotal(List<Transaction> transactions, bool income) {
    return transactions
        .where((t) => t.isIncome == income)
        .fold(0, (sum, t) => sum + t.amount);
  }
}
