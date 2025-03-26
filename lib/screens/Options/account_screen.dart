import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: Text('บัญชี', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(40.0)),
          //Phone Number and Birthday
          Container(
            color: const Color.fromARGB(192, 75, 46, 205),
            child: Column(
              children: [
                ListTile(
                  title: Text('เบอร์มือถือ',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('ยังไม่มีข้อมูล',
                          style: TextStyle(
                              color: const Color.fromARGB(119, 255, 255, 255))),
                      SizedBox(width: 8),
                      Icon(Icons.edit, color: Colors.white),
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1),
                ListTile(
                  title: Text('วันเกิด',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('ยังไม่มีข้อมูล',
                          style: TextStyle(
                              color: const Color.fromARGB(119, 255, 255, 255))),
                      SizedBox(width: 8),
                      Icon(Icons.edit, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25),
          // Second Section: Buttons
          Container(
            color: const Color.fromARGB(192, 75, 46, 205),
            child: Column(
              children: [
                ListTile(
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ลงชื่อเข้าใช้',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  tileColor: Colors.purple,
                  onTap: () {
                    // Handle sign-in action
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            color: const Color.fromARGB(192, 75, 46, 205),
            child: Column(
              children: [
                ListTile(
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ออกจากระบบ',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  tileColor: Colors.purple,
                  onTap: () {
                    // Handle sign-in action
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
