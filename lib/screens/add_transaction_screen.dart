import 'dart:convert';
// import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackit/models/transaction.dart';
import 'package:trackit/widgets/show_category.dart';
import 'package:trackit/widgets/amount_input.dart';
import 'package:trackit/services/save_transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool _isIncome = false;
  String _selectedCategory = '';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  late Future<Map<String, List<String>>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = _loadCategories(); // Load categories on init
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // Load categories from a JSON file
  Future<Map<String, List<String>>> _loadCategories() async {
    String jsonString = await rootBundle.loadString('assets/category.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    List<String> incomeCategories = List<String>.from(jsonMap['income']);
    List<String> expenseCategories = List<String>.from(jsonMap['expense']);
    return {
      'income': incomeCategories,
      'expense': expenseCategories,
    };
  }

  void _showCategorySelector(
      BuildContext context, Map<String, List<String>> categories) {
    List<String> selectedCategories =
        !_isIncome ? categories['income']! : categories['expense']!;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CategorySelector(
          categories: selectedCategories,
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = category;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context); // Close current screen and go back
          },
        ),
      ),
      body: Container(
        color: Colors.grey[200], // Set background color
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, List<String>>>(
          future: _categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading categories'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No categories available'));
            } else {
              return Form(
                child: Column(
                  children: [
                    ToggleButtons(
                      isSelected: [!_isIncome, _isIncome],
                      onPressed: (int index) {
                        setState(() {
                          _isIncome = index == 1;
                          _selectedCategory =
                              !_isIncome ? "เงินเดือน" : "อาหาร";
                        });
                      },
                      borderRadius: BorderRadius.circular(8.0),
                      selectedColor: Colors.white,
                      fillColor: Colors.purple[300],
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('รายรับ'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('รายจ่าย'),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    AmountInput(
                        controller: _amountController, isIncome: _isIncome),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () =>
                          _showCategorySelector(context, snapshot.data!),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.category),
                          title: Text('เลือกหมวดหมู่/แท็ก'),
                          subtitle: Text(
                            _selectedCategory.isEmpty
                                ? (!_isIncome ? "เงินเดือน" : "อาหาร")
                                : _selectedCategory,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.note),
                        title: TextFormField(
                          controller: _detailsController,
                          decoration: InputDecoration(hintText: 'เพิ่มโน็ต'),
                        ),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (_amountController.text.isEmpty) return;

                        final enteredAmount = _amountController.text;
                        final newTransaction = Transaction(
                          amount: double.parse(enteredAmount),
                          date: DateTime.now().toString(),
                          isIncome: !_isIncome,
                          category: _selectedCategory.isEmpty
                              ? (!_isIncome ? "เงินเดือน" : "อาหาร")
                              : _selectedCategory,
                          details: _detailsController.text,
                        );

                        onWriteJsonFile(newTransaction);

                        try {
                          Navigator.pop(context);
                        } catch (e) {
                          debugPrint("Error closing the screen: $e");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.purple),
                      ),
                      child: Text('บันทึกรายการ'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
