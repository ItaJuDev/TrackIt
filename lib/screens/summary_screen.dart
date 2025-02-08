import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SummaryScreen extends StatelessWidget {
  // Mock Data for Pie Chart
  //==========================
  final double income = 7000.0;
  final double expense = 5000.0;
  //==========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Summary"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Income vs Expense Analysis",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: _generateChartSections(),
                  centerSpaceRadius: 50, // Empty space in the middle
                  sectionsSpace: 2, // Space between slices
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to generate Pie Chart sections
  List<PieChartSectionData> _generateChartSections() {
    double total = income + expense;
    return [
      PieChartSectionData(
        color: Colors.green,
        value: income,
        title: '${((income / total) * 100).toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: expense,
        title: '${((expense / total) * 100).toStringAsFixed(1)}%',
        radius: 80,
        titleStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }
}
