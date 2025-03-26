import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../utils/color_utils.dart';

Future<Color?> showColorPickerDialog({
  required BuildContext context,
  required Color initialColor,
  required List<Color> presetColors,
}) async {
  Color selectedColor = initialColor;

  return await showDialog<Color>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text('เลือกสีหมวดหมู่'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: presetColors.map((color) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context, color);
                },
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 16,
                  child: Icon(Icons.check,
                      size: 16,
                      color: selectedColor == color
                          ? getContrastingTextColor(color)
                          : Colors.transparent),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ColorPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) => selectedColor = color,
            enableAlpha: false,
            displayThumbColor: true,
            labelTypes: [],
            pickerAreaHeightPercent: 0.7,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text('ยกเลิก'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: Text('บันทึก'),
          onPressed: () => Navigator.pop(context, selectedColor),
        ),
      ],
    ),
  );
}
