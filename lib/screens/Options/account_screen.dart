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
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
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
                  title: Text(
                    'เบอร์มือถือ',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 150, // Adjust width as needed
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'กรอกเบอร์มือถือ',
                            hintStyle: TextStyle(
                                color:
                                    const Color.fromARGB(119, 255, 255, 255)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.edit, color: Colors.white),
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1),
                ListTile(
                  title: Text(
                    'วันเกิด',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 150, // Adjust width as needed
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'กรอกวันเกิด',
                            hintStyle: TextStyle(
                                color:
                                    const Color.fromARGB(119, 255, 255, 255)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
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
          // Third Section: Logout
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.deepPurple, Colors.purple],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: Icon(Icons.close,
                                            color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'ต้องการออกจากระบบ?',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          style: TextButton.styleFrom(
                                            side:
                                                BorderSide(color: Colors.white),
                                            backgroundColor: Colors.transparent,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                          ),
                                          child: Text(
                                            'อยู่ต่อ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                            // Add your logout logic here
                                          },
                                          style: TextButton.styleFrom(
                                            side:
                                                BorderSide(color: Colors.white),
                                            backgroundColor: Colors.deepPurple,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                          ),
                                          child: Text(
                                            'ออกจากระบบ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
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
