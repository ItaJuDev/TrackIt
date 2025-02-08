import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allow the elevated button to overflow
      children: [
        BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.grey[200],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          onTap: (index) {
            // Ignore taps for the middle item (index 2)
            if (index != 2) {
              if (index > 2) {
                index--;
              }
              onTap(index);
            }
          },
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.point_of_sale_rounded),
              label: 'เป้าหมาย',
            ),
            BottomNavigationBarItem(
              icon: SizedBox.shrink(), // Empty space for the center item
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'สรุป',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'เพิ่มเติม',
            ),
          ],
        ),
        Positioned(
          bottom: 35, // Raise the center item above the nav bar
          left: MediaQuery.of(context).size.width * 0.43, // Center horizontally
          child: GestureDetector(
            onTap: () {
              // Action for the center item (e.g., create a new transaction)
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60, // Icon size container
                  width: 60, // Icon size container
                  decoration: BoxDecoration(
                    color: Colors.blue, // Background color of the center button
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 8.0,
                        offset:
                            Offset(0, 4), // Vertical shadow for raised effect
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35, // Larger icon size
                  ),
                ),
                SizedBox(height: 5), // Space between icon and text
                Text(
                  'จดเพิ่ม', // Text label below the icon
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16, // Adjust the font size as needed
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
