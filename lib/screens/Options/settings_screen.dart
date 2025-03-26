import 'package:flutter/material.dart';
import 'package:trackit/screens/Options/account_screen.dart';
import 'package:trackit/screens/Options/recommend_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 130, bottom: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purple],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 30),
              child: Text(
                'ตั้งค่าการใช้งาน',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'บัญชี',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 93, 43, 179),
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountScreen()),
                        );
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      endIndent: 10,
                      color: Color.fromARGB(255, 93, 43, 179),
                    ),
                    ListTile(
                      title: Text(
                        'จัดการแท็ก',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 93, 43, 179),
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {},
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      endIndent: 10,
                      color: Color.fromARGB(255, 93, 43, 179),
                    ),
                    ListTile(
                      title: Text(
                        'แนะนำการใช้งาน',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 93, 43, 179),
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecommendScreen()),
                        );
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      endIndent: 10,
                      color: Color.fromARGB(255, 93, 43, 179),
                    ),
                    ListTile(
                      title: Text(
                        'ภาษา',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 93, 43, 179),
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
