import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackit/data/local_db.dart';
import 'package:trackit/widgets/AddTransaction/amount_input.dart';
import 'package:trackit/widgets/AddTransaction/category_selector_bottomsheet.dart';
import 'package:trackit/widgets/AddTransaction/transaction_type_toggle.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool isIncome = true;
  DateTime selectedDate = DateTime.now();

  String? selectedCategory;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  void _openCategorySelector() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CategorySelectorSheet(
        isIncome: isIncome,
      ),
    );

    if (result != null) {
      setState(() => selectedCategory = result);
    }
  }

  Future<void> _saveTransaction() async {
    final amount = double.tryParse(amountController.text.trim());
    if (amount == null || selectedCategory == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'last_transaction_time', DateTime.now().millisecondsSinceEpoch);

    final newTransaction = TransactionsCompanion(
      amount: drift.Value(amount),
      date: drift.Value(selectedDate.toIso8601String()), // ← use selected date
      isIncome: drift.Value(isIncome),
      category: drift.Value(selectedCategory!),
      details: drift.Value(detailsController.text.trim()),
    );

    await localDb.insertTransaction(newTransaction);
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'เพิ่มรายรับ/รายจ่าย',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.purple[500],
          iconTheme: IconThemeData(color: Colors.white)),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TransactionTypeToggle(
              isIncome: isIncome,
              onToggle: (value) {
                setState(() {
                  isIncome = value;
                });
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('dd MMM yyyy').format(selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Icon(Icons.edit_calendar),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            AmountInput(controller: amountController, isIncome: isIncome),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _openCategorySelector,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.category_outlined),
                    const SizedBox(width: 12),
                    Text(
                      selectedCategory ?? 'เลือกหมวดหมู่',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: detailsController,
              decoration: InputDecoration(
                labelText: 'รายละเอียดเพิ่มเติม',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _saveTransaction,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size(10, 50),
              ),
              child: Text(
                'บันทึกรายการ',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
