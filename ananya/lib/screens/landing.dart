import 'package:ananya/screens/home.dart';
import 'package:ananya/screens/unlock_process1.dart';
import 'package:ananya/screens/unlock_process2.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/widgets/user_sidebar.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;
    switch (_selectedIndex) {
      case 0:
        bodyWidget = const Home();
        break;
      case 1:
        bodyWidget = const Home();
        break;
      default:
        bodyWidget = const Home();
    }
    return Container(
      color: Colors.white,
      child: Scaffold(
        drawer: UserSidebar(),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: bodyWidget,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[100],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: SECONDARY_COLOR,
          unselectedItemColor: Colors.grey[600],
          selectedFontSize: 16,
          unselectedFontSize: 14,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today,
                size: _selectedIndex == 0 ? 40 : 30,
                color: _selectedIndex == 0 ? SECONDARY_COLOR : Colors.grey[600],
              ),
              label: "Tracker",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.language,
                size: _selectedIndex == 1 ? 40 : 30,
                color: _selectedIndex == 1 ? SECONDARY_COLOR : Colors.grey[600],
              ),
              label: "Knowledge Nexus",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                size: _selectedIndex == 2 ? 40 : 30,
                color: _selectedIndex == 2 ? SECONDARY_COLOR : Colors.grey[600],
              ),
              label: "Shop",
            ),
          ],
        ),
      ),
    );
  }
}
