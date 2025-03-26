import 'package:flutter/material.dart';
import 'package:trackit/data/local_db.dart';
import 'package:drift/drift.dart' as drift;

class CategorySelectorSheet extends StatefulWidget {
  final bool isIncome;

  const CategorySelectorSheet({super.key, required this.isIncome});

  @override
  State<CategorySelectorSheet> createState() => _CategorySelectorSheetState();
}

class _CategorySelectorSheetState extends State<CategorySelectorSheet> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final all = await localDb.getAllCategories();
    setState(() {
      categories = all.where((cat) => cat.isIncome == widget.isIncome).toList();
    });
  }

  Future<void> _deleteCategory(int id) async {
    await localDb.deleteCategory(id);
    _loadCategories();
  }

  void _showAddCategoryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('เพิ่มหมวดหมู่'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'ชื่อหมวดหมู่'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                await localDb.insertCategory(
                  name,
                  widget.isIncome,
                );
                Navigator.pop(context);
                _loadCategories();
              }
            },
            child: Text('เพิ่ม'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            Text(
              widget.isIncome ? 'หมวดหมู่รายรับ' : 'หมวดหมู่รายจ่าย',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            if (categories.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('ยังไม่มีหมวดหมู่'),
              ),
            ...categories.map((cat) {
              return ListTile(
                title: Text(cat.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('ลบหมวดหมู่'),
                        content: Text('ต้องการลบ "${cat.name}" หรือไม่?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('ยกเลิก'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child:
                                Text('ลบ', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await _deleteCategory(cat.id);
                    }
                  },
                ),
                onTap: () {
                  Navigator.pop(context, cat.name);
                },
              );
            }).toList(),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('เพิ่มหมวดหมู่ใหม่'),
              onTap: _showAddCategoryDialog,
            ),
          ],
        ),
      ),
    );
  }
}
