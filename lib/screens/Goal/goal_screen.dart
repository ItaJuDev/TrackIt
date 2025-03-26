import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:trackit/data/local_db.dart';

class GoalScreen extends StatefulWidget {
  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final List<String> modes = ['รายวัน', 'รายเดือน', 'รายปี'];
  String selectedMode = 'รายวัน';

  double goalAmount = 0;
  double currentSpent = 0;
  Goal? currentGoal;

  double get progress =>
      goalAmount == 0 ? 0 : (currentSpent / goalAmount).clamp(0.0, 1.0);

  @override
  void initState() {
    super.initState();
    _loadGoalData();
  }

  Future<void> _loadGoalData() async {
    final dailyGoal = await localDb.getGoalByMode('รายวัน');
    final spent = await localDb.getSpentAmount(selectedMode);
    double calculatedGoal = dailyGoal?.amount ?? 0;

    final now = DateTime.now();
    if (selectedMode == 'รายเดือน') {
      final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
      calculatedGoal *= daysInMonth;
    } else if (selectedMode == 'รายปี') {
      final isLeapYear =
          (now.year % 4 == 0 && now.year % 100 != 0) || (now.year % 400 == 0);
      calculatedGoal *= isLeapYear ? 366 : 365;
    }

    setState(() {
      goalAmount = calculatedGoal;
      currentSpent = spent;
    });
  }

  Future<void> _updateGoalAmount(double newAmount) async {
    await localDb.delete(localDb.goals).go();
    await localDb.upsertGoal(selectedMode, newAmount);
    _loadGoalData();
  }

  void _showEditGoalDialog() {
    final controller = TextEditingController(text: goalAmount.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("ตั้งเป้าหมาย $selectedMode"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'จำนวนเป้าหมาย (บาท)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("ยกเลิก"),
          ),
          ElevatedButton(
            onPressed: () {
              final input = double.tryParse(controller.text);
              if (input != null) {
                _updateGoalAmount(input);
                Navigator.pop(context);
              }
            },
            child: Text("บันทึก"),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: modes.map((mode) {
        final isSelected = mode == selectedMode;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: ChoiceChip(
            label: Text(mode),
            selected: isSelected,
            selectedColor: Colors.purple,
            backgroundColor: Colors.grey[300],
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
            onSelected: (_) {
              setState(() => selectedMode = mode);
              _loadGoalData();
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProgressIndicator() {
    return CircularPercentIndicator(
      radius: 120.0,
      lineWidth: 15.0,
      animation: true,
      percent: progress,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${(progress * 100).toStringAsFixed(1)}%",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            "ใช้ไป ${currentSpent.toStringAsFixed(0)} / ${goalAmount.toStringAsFixed(0)} บาท",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
      progressColor: progress >= 1.0 ? Colors.red : Colors.green,
      backgroundColor: Colors.grey.shade300,
      circularStrokeCap: CircularStrokeCap.round,
    );
  }

  Widget _buildDetailCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("รายละเอียดเป้าหมาย",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.deepPurple),
              title: Text(
                "ประเภทเป้าหมาย",
              ),
              trailing: Text(selectedMode, style: TextStyle(fontSize: 14)),
            ),
            ListTile(
              leading: Icon(Icons.track_changes, color: Colors.deepPurple),
              title: Text("เป้าหมาย"),
              trailing: Text("${goalAmount.toStringAsFixed(0)} บาท",
                  style: TextStyle(fontSize: 14)),
            ),
            ListTile(
              leading: Icon(Icons.money_off, color: Colors.deepPurple),
              title: Text("ใช้ไปแล้ว"),
              trailing: Text("${currentSpent.toStringAsFixed(0)} บาท",
                  style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'เป้าหมายการใช้เงิน',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.white,
            onPressed: _showEditGoalDialog,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildModeSelector(),
            const SizedBox(height: 40),
            _buildProgressIndicator(),
            const SizedBox(height: 40),
            _buildDetailCard(),
          ],
        ),
      ),
    );
  }
}
