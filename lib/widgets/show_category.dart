import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final Function(String) onCategorySelected;

  const CategorySelector({
    Key? key,
    required this.categories,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: categories.map((category) {
        return ListTile(
          title: Text(category),
          onTap: () {
            onCategorySelected(category); // Pass selected category back
            Navigator.pop(context); // Close bottom sheet after selection
          },
        );
      }).toList(),
    );
  }
}
