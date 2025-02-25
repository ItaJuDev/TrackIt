import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInput extends StatefulWidget {
  final TextEditingController controller;
  final bool isIncome;

  AmountInput({required this.controller, required this.isIncome});

  @override
  _AmountInputState createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Focused, keyboard should appear
        debugPrint('TextFormField is focused');
      } else {
        debugPrint('None Focus');
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: Icon(
          !widget.isIncome ? Icons.add : Icons.remove,
          color: !widget.isIncome ? Colors.green : Colors.red,
        ),
        title: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
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
