import 'package:flutter/material.dart';
import 'package:trackit/widgets/Options/setting_option.dart'; // Ensure this import path is correct for your project.

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurple],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.black,
                  width: 3.0,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Adjust container height
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 111),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      'ตั้งค่าการใช้งาน',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Divider(height: 1, color: Colors.black),
                  SettingOption(
                    title: 'บัญชี',
                    onTap: () {
                      // Implement your navigation or action here
                    },
                  ),
                  SettingOption(
                    title: 'จัดการแท็ก',
                    onTap: () {
                      // Implement your navigation or action here
                    },
                  ),
                  SettingOption(
                    title: 'แนะนำการใช้งาน',
                    onTap: () {
                      // Implement your navigation or action here
                    },
                  ),
                  SettingOption(
                    title: 'บริการแนะนำ',
                    onTap: () {
                      // Implement your navigation or action here
                    },
                  ),
                  SettingOption(
                    title: 'บริการยอดนิยม',
                    onTap: () {
                      // Implement your navigation or action here
                    },
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
