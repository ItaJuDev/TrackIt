import 'package:flutter/material.dart';

class AddGoalScreen extends StatefulWidget {
  @override
  _AddGoalScreenState createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  int _duration = 3;
  String _durationType = 'เดือน';

  void _saveGoal() {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) return;

    final newGoal = {
      'name': _nameController.text,
      'amount': double.parse(_amountController.text),
      'duration': _duration,
      'durationType': _durationType,
    };

    Navigator.pop(context, newGoal);
  }

  void _showDurationPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${index + 1}'),
                      onTap: () {
                        setState(() => _duration = index + 1);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => _durationType = 'วัน'),
                    child: Text('วัน'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => _durationType = 'เดือน'),
                    child: Text('เดือน'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => _durationType = 'ปี'),
                    child: Text('ปี'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยืนยัน'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('เพิ่มเป้าหมาย'), backgroundColor: Colors.purple),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'เป้าหมาย')),
            TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'ระบุจำนวนเงิน'),
                keyboardType: TextInputType.number),
            SizedBox(height: 10),
            ListTile(
              title: Text('ระยะเวลาออม: $_duration $_durationType'),
              trailing: Icon(Icons.arrow_drop_down),
              onTap: _showDurationPicker,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGoal,
              child: Text('บันทึกรายการ'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),
          ],
        ),
      ),
    );
  }
}
