import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:trackit/data/local_db.dart';

class GoalScreen extends StatefulWidget {
  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final List<String> modes = ['รายวัน', 'รายเดือน', 'รายปี'];
  String selectedMode = 'รายวัน';
  final formatter = NumberFormat("#,##0.00", "en_US");

  double goalAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadGoalAmount();
  }

  Future<void> _loadGoalAmount() async {
    final dailyGoal = await localDb.getGoalByMode('รายวัน');
    double calculated = dailyGoal?.amount ?? 0;
    final now = DateTime.now();

    if (selectedMode == 'รายเดือน') {
      final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
      calculated *= daysInMonth;
    } else if (selectedMode == 'รายปี') {
      final isLeapYear =
          (now.year % 4 == 0 && now.year % 100 != 0) || (now.year % 400 == 0);
      calculated *= isLeapYear ? 366 : 365;
    }

    setState(() => goalAmount = calculated);
  }

  void _showEditGoalDialog() {
    final controller =
        TextEditingController(text: goalAmount.toStringAsFixed(0));
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
            onPressed: () async {
              final input = double.tryParse(controller.text);
              if (input != null) {
                await localDb.upsertGoal(
                    'รายวัน', input); // always update daily
                await _loadGoalAmount(); // recalculate
                Navigator.pop(context);
              }
            },
            child: Text("บันทึก"),
          ),
        ],
      ),
    );
  }

  double calculateProgress(double spent) {
    if (goalAmount == 0) return 0;
    return (spent / goalAmount).clamp(0.0, 1.0);
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
            onSelected: (_) async {
              setState(() => selectedMode = mode);
              await _loadGoalAmount();
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailCard(double spent) {
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
              title: Text("ประเภทเป้าหมาย"),
              trailing: Text(selectedMode,
                  style: TextStyle(fontSize: 14, color: Colors.black)),
            ),
            ListTile(
              leading: Icon(Icons.track_changes, color: Colors.deepPurple),
              title: Text("เป้าหมาย"),
              trailing: Text("${formatter.format(goalAmount)} บาท",
                  style: TextStyle(fontSize: 14, color: Colors.black)),
            ),
            ListTile(
              leading: Icon(Icons.money_off, color: Colors.deepPurple),
              title: Text("ใช้ไปแล้ว"),
              trailing: Text("${formatter.format(spent)} บาท",
                  style: TextStyle(fontSize: 14, color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: StreamBuilder<List<Transaction>>(
        stream: localDb.watchAllTransactions(),
        builder: (context, snapshot) {
          final all = snapshot.data ?? [];

          final now = DateTime.now();
          final filtered = all.where((t) {
            if (t.isIncome) return false;
            final date = DateTime.parse(t.date);
            if (selectedMode == 'รายวัน') {
              return date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day;
            } else if (selectedMode == 'รายเดือน') {
              return date.year == now.year && date.month == now.month;
            } else {
              return date.year == now.year;
            }
          }).toList();

          final spent = filtered.fold(0.0, (sum, t) => sum + t.amount);
          final progress = calculateProgress(spent);

          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 70, bottom: 30),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.deepPurple],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'เป้าหมายการใช้เงิน',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildModeSelector(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          CircularPercentIndicator(
                            radius: 120.0,
                            lineWidth: 15.0,
                            animation: true,
                            percent: progress,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${(progress * 100).toStringAsFixed(1)}%",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "ใช้ไป ${formatter.format(spent)} / ${formatter.format(goalAmount)} บาท",
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            progressColor:
                                progress >= 1.0 ? Colors.red : Colors.green,
                            backgroundColor: Colors.grey.shade300,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                          const SizedBox(height: 20),
                          _buildDetailCard(spent),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 4,
                right: 16,
                child: IconButton(
                  icon: Icon(Icons.edit, color: Colors.white),
                  onPressed: _showEditGoalDialog,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
