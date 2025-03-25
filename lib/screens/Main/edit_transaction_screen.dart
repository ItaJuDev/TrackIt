import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:trackit/data/local_db.dart';

class EditTransactionScreen extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  late TextEditingController amountController;
  late TextEditingController detailsController;

  String? selectedCategory;
  List<Category> incomeCategories = [];
  List<Category> expenseCategories = [];

  @override
  void initState() {
    super.initState();
    amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    detailsController =
        TextEditingController(text: widget.transaction.details ?? '');
    selectedCategory = widget.transaction.category;

    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final all = await localDb.getAllCategories();
    setState(() {
      incomeCategories = all.where((c) => c.isIncome).toList();
      expenseCategories = all.where((c) => !c.isIncome).toList();
    });
  }

  void saveChanges() async {
    final updated = TransactionsCompanion(
      id: drift.Value(widget.transaction.id),
      amount: drift.Value(double.tryParse(amountController.text) ?? 0),
      date: drift.Value(widget.transaction.date),
      isIncome: drift.Value(widget.transaction.isIncome),
      category: drift.Value(selectedCategory ?? ''),
      details: drift.Value(detailsController.text),
    );

    await localDb.updateTransaction(updated);
    Navigator.pop(context);
  }

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        final sectionCategories =
            widget.transaction.isIncome ? incomeCategories : expenseCategories;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.transaction.isIncome
                  ? 'หมวดหมู่รายรับ'
                  : 'หมวดหมู่รายจ่าย',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ...sectionCategories.map((cat) => ListTile(
                  title: Text(cat.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("ลบหมวดหมู่"),
                          content: Text(
                              "คุณแน่ใจหรือไม่ว่าต้องการลบ '${cat.name}'?"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("ยกเลิก")),
                            TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("ลบ",
                                    style: TextStyle(color: Colors.red))),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await localDb.deleteCategory(cat.id);
                        fetchCategories();
                        if (selectedCategory == cat.name) {
                          setState(() => selectedCategory = null);
                        }
                      }
                    },
                  ),
                  onTap: () {
                    setState(() => selectedCategory = cat.name);
                    Navigator.pop(context);
                  },
                )),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('เพิ่มหมวดหมู่ใหม่'),
              onTap: () {
                Navigator.pop(context);
                _showAddCategoryDialog();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddCategoryDialog() {
    final newCatController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('เพิ่มหมวดหมู่ใหม่'),
        content: TextField(
          controller: newCatController,
          decoration: const InputDecoration(hintText: 'ชื่อหมวดหมู่'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () async {
              final name = newCatController.text.trim();
              if (name.isNotEmpty) {
                await localDb.insertCategory(CategoriesCompanion(
                  name: drift.Value(name),
                  isIncome: drift.Value(widget.transaction.isIncome),
                ));
                await fetchCategories();
                setState(() => selectedCategory = name);
                Navigator.pop(context);
              }
            },
            child: const Text('เพิ่ม'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขรายการ'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                leading: Icon(
                  widget.transaction.isIncome ? Icons.add : Icons.remove,
                  color:
                      widget.transaction.isIncome ? Colors.green : Colors.red,
                ),
                title: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวนเงิน'),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _showCategorySelector,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.category_outlined),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        selectedCategory ?? 'เลือกหมวดหมู่',
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedCategory == null
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
                    const Icon(Icons.expand_more),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: detailsController,
              decoration: const InputDecoration(
                labelText: 'รายละเอียดเพิ่มเติม',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text(
                'บันทึกการเปลี่ยนแปลง',
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
