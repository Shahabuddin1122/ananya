import 'package:ananya/screens/landing/superuser_home.dart';
import 'package:ananya/screens/landing/user_home.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/user_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _selectedIndex = 0;
  late Future<bool> numberPresent;

  @override
  void initState() {
    super.initState();
    numberPresent = getInfo();
  }

  Future<bool> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? number = prefs.getString('userNumber');
    return number != null;
  }

  Future<bool> isSuperuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSuperuser = prefs.getBool('is_superuser');
    return isSuperuser ?? false;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBodyWidget() {
    switch (_selectedIndex) {
      case 0:
        return FutureBuilder<bool>(
          future: isSuperuser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data == true) {
              return const SuperuserHome();
            } else {
              return const UserHome();
            }
          },
        );
      case 1:
        return UserHome(); // Replace with the appropriate widget for "Knowledge Nexus"
      case 2:
        return UserHome(); // Replace with the appropriate widget for "Shop"
      default:
        return UserHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        drawer: const UserSidebar(),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            FutureBuilder<bool>(
              future: numberPresent,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else if (snapshot.hasData && snapshot.data == true) {
                  return IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {},
                  );
                } else {
                  return Padding(
                    padding: Theme.of(context).largemainPadding,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(ACCENT),
                        minimumSize:
                            WidgetStateProperty.all(const Size(50, 20)),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/signin');
                      },
                      child: Text(
                        AppLocalizations.of(context)!.log_in,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: _getBodyWidget(),
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
