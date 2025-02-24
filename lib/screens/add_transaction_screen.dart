import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trackit/widgets/show_category.dart';
import 'package:trackit/widgets/amount_input.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool _isIncome = false;
  String _selectedCategory = 'อาหาร'; // Default category
  final TextEditingController _amountController = TextEditingController();
  late Future<List<String>> _categories;

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
  Future<List<String>> _loadCategories() async {
    String jsonString = await rootBundle.loadString('assets/category.json');
    List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((category) => category.toString()).toList();
  }

  void _showCategorySelector(BuildContext context, List<String> categories) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CategorySelector(
          categories: categories,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<String>>(
          future: _categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading categories'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No categories available'));
            } else {
              // Categories loaded successfully
              return Form(
                child: Column(
                  children: [
                    ToggleButtons(
                      isSelected: [!_isIncome, _isIncome],
                      onPressed: (int index) {
                        setState(() {
                          _isIncome = index == 1;
                        });
                      },
                      borderRadius: BorderRadius.circular(8.0),
                      selectedColor: Colors.white,
                      fillColor: Colors.purple[200],
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
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.category),
                          title: Text('เลือกหมวดหมู่/แท็ก'),
                          subtitle: Text(_selectedCategory),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.note),
                        title: Text('เพิ่มโน้ต'),
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        final enteredAmount = _amountController.text;
                        // Save the transaction logic here
                        Navigator.pop(context); // Close the screen after saving
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

class AmountInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isIncome;

  AmountInput({required this.controller, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: Icon(
          isIncome ? Icons.add : Icons.remove,
          color: isIncome ? Colors.green : Colors.red,
        ),
        title: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: '0 ฿'),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            } else if (double.tryParse(value) == null ||
                double.parse(value) <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
      ),
    );
  }
}
