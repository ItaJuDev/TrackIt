import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackit/data/local_db.dart';
import 'package:trackit/screens/Main/home_screen.dart';
import 'package:trackit/screens/Main/transaction_screen.dart';
import 'package:trackit/screens/Options/settings_screen.dart'; // Add this screen later

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await localDb.deleteDatabaseFile();
  await insertDefualtCategory();
  await _checkIdleTime();
  runApp(MyApp());
}

Future<void> insertDefualtCategory() async {
// insert defualt categories
  final defaultCategories = [
    {'name': 'อาหาร', 'isIncome': false},
    {'name': 'เดินทาง', 'isIncome': false},
    {'name': 'บันเทิง', 'isIncome': false},
    {'name': 'เงินเดือน', 'isIncome': true},
    {'name': 'ขายของ', 'isIncome': true},
    {'name': 'ของใช้', 'isIncome': false},
    {'name': 'ค่าโอที', 'isIncome': true},
    {'name': 'ค่างานเสริม', 'isIncome': true},
    {'name': 'น้ำมัน', 'isIncome': false},
    {'name': 'เครื่องดื่ม', 'isIncome': false},
  ];

  for (final i in defaultCategories) {
    await localDb.insertCategory(i['name'] as String, i['isIncome'] as bool);
  }
}

Future<void> _checkIdleTime() async {
  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now().millisecondsSinceEpoch;
  final last = prefs.getInt('last_transaction_time') ?? 0;

  if (now - last >= Duration(hours: 8).inMilliseconds) {
    // TODO: trigger local notification here
  }
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
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
