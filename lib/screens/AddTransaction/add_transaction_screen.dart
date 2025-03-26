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
                padding: const EdgeInsets.only(top: 60, bottom: 24),
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
                child: const Center(
                  child: Text(
                    'เพิ่มรายรับ/รายจ่าย',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Form Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Transaction Type Toggle
                      TransactionTypeToggle(
                        isIncome: isIncome,
                        onToggle: (value) {
                          setState(() {
                            isIncome = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date Picker
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined),
                              const SizedBox(width: 12),
                              Text(
                                DateFormat('dd MMM yyyy').format(selectedDate),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Spacer(),
                              const Icon(Icons.edit_calendar),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Amount Input
                      AmountInput(
                        controller: amountController,
                        isIncome: isIncome,
                      ),
                      const SizedBox(height: 16),

                      // Category Selector
                      GestureDetector(
                        onTap: _openCategorySelector,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.category_outlined),
                              const SizedBox(width: 12),
                              Text(
                                selectedCategory ?? 'เลือกหมวดหมู่',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Spacer(),
                              const Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Details
                      TextField(
                        controller: detailsController,
                        decoration: const InputDecoration(
                          labelText: 'รายละเอียดเพิ่มเติม',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const Spacer(),

                      // Save Button
                      ElevatedButton(
                        onPressed: _saveTransaction,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          minimumSize: const Size.fromHeight(48),
                        ),
                        child: const Text(
                          'บันทึกรายการ',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Custom back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 4,
            left: 4,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
