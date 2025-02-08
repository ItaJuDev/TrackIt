import 'package:flutter/material.dart';
import 'package:trackit/screens/transaction_screen.dart';
import 'package:trackit/screens/budget_screen.dart';
import 'package:trackit/screens/summary_screen.dart';
import 'package:trackit/screens/settings_screen.dart';
import 'package:trackit/widgets/bottom_nav_bar.dart'; // Import the BottomNavBar widget

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens to navigate to based on the selected index
  final List<Widget> _screens = [
    TransactionScreen(), // Summary screen
    BudgetScreen(), // Transaction screen
    SummaryScreen(), // Budget screen
    SettingsScreen(), // Settings screen
  ];

  // Navigation function for bottom navigation bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavBar(
        // Use the BottomNavBar widget
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
