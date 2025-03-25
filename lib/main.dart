import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:trackit/data/local_db.dart';
import 'package:trackit/screens/home_screen.dart';
import 'package:trackit/screens/Main/transaction_screen.dart'; // Add this screen later
import 'package:trackit/screens/Options/settings_screen.dart'; // Add this screen later

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await localDb.insertTransaction(TransactionsCompanion.insert(
    amount: 199.0,
    date: DateTime.now().toIso8601String(),
    isIncome: true,
    category: 'Salary',
    details: const Value('ทดสอบ drift db'),
  ));
  // await localDb.deleteDatabaseFile();
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
        '/transaction': (context) => TransactionScreen(),
        '/settings': (context) => SettingsScreen(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
