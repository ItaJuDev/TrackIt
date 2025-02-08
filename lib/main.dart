import 'package:flutter/material.dart';
import 'package:trackit/screens/home_screen.dart';
import 'package:trackit/screens/transaction_screen.dart'; // Add this screen later
import 'package:trackit/screens/settings_screen.dart'; // Add this screen later

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackIt',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/transaction': (context) =>
            TransactionScreen(), // Define this screen later
        '/settings': (context) => SettingsScreen(), // Define this screen later
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
