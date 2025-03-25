import 'package:flutter/material.dart';
import 'package:trackit/screens/Target/add_goal_screen.dart';

class GoalScreen extends StatefulWidget {
  @override
  _GoalScreenState createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  List<Map<String, dynamic>> _goals = []; // Store goals

  void _addGoal(Map<String, dynamic> newGoal) {
    setState(() {
      _goals.add(newGoal);
    });
  }

  void _navigateToAddGoalScreen() async {
    final newGoal = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddGoalScreen()),
    );

    if (newGoal != null) {
      _addGoal(newGoal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'เป้าหมายการเงิน',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
