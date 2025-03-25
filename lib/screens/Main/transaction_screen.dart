import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackit/data/local_db.dart';
import 'package:trackit/widgets/Main/transaction_list.dart';
import 'package:trackit/widgets/Summarize/summary_header.dart';

class TransactionScreen extends StatefulWidget {
  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  DateTime selectedDate = DateTime.now();
  String filterMode = 'Daily';

  List<Transaction> _filterTransactions(List<Transaction> all) {
    return all.where((t) {
      final tDate = DateTime.parse(t.date);
      if (filterMode == 'Daily') {
        return tDate.year == selectedDate.year &&
            tDate.month == selectedDate.month &&
            tDate.day == selectedDate.day;
      } else if (filterMode == 'Monthly') {
        return tDate.year == selectedDate.year &&
            tDate.month == selectedDate.month;
      } else {
        return tDate.year == selectedDate.year;
      }
    }).toList();
  }

  String _formattedDate() {
    if (filterMode == 'Daily') {
      return DateFormat('dd MMM yyyy').format(selectedDate);
    } else if (filterMode == 'Monthly') {
      return DateFormat('MMM yyyy').format(selectedDate);
    } else {
      return DateFormat('yyyy').format(selectedDate);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: Colors.purple,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

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
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.deepPurple],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Date and Filter Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 90),
                        Center(
                          child: TextButton.icon(
                            onPressed: _selectDate,
                            icon: const Icon(Icons.calendar_month,
                                color: Colors.white),
                            label: Text(
                              _formattedDate(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.purple[100],
                              value: filterMode,
                              iconEnabledColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                              items: ['Daily', 'Monthly', 'Annually']
                                  .map((mode) => DropdownMenuItem(
                                        value: mode,
                                        child: Text(mode),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => filterMode = value);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'เป้าหมาย',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '500บาท/วัน',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              Expanded(
                child: StreamBuilder<List<Transaction>>(
                  stream: localDb.watchAllTransactions(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final filtered = _filterTransactions(snapshot.data!);
                    if (filtered.isEmpty) {
                      return const Center(child: Text('ไม่มีข้อมูลธุรกรรม'));
                    }
                    return TransactionList(transactions: filtered);
                  },
                ),
              ),
            ],
          ),
          Positioned(
            top: 170,
            left: 20,
            right: 20,
            child: StreamBuilder<List<Transaction>>(
              stream: localDb.watchAllTransactions(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();
                final filtered = _filterTransactions(snapshot.data!);
                return SummaryHeader(transactions: filtered);
              },
            ),
          ),
        ],
      ),
    );
  }
}
