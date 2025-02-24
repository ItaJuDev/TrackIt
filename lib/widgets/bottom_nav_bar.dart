import 'package:flutter/material.dart';
import 'package:trackit/screens/add_transaction_screen.dart';

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
          backgroundColor: Colors.grey[100],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black,
          showUnselectedLabels: true,
          onTap: (index) {
            if (index == 2) return;
            onTap(index);
          },
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
              icon: Icon(Icons.more_horiz),
              label: 'เพิ่มเติม',
            ),
          ],
        ),
      ],
    );
  }
}
