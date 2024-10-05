import 'package:ananya/screens/knowledge_nexus.dart';
import 'package:ananya/screens/landing/superuser_home.dart';
import 'package:ananya/screens/landing/user_home.dart';
import 'package:ananya/utils/api_settings.dart';
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
  late Future<bool> userPresent = getInfo();

  @override
  void initState() {
    super.initState();
    userPresent = getInfo();
  }

  Future<bool> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('userId');
    ApiSettings api = ApiSettings(endPoint: 'user/get-user/$id');
    try {
      final response = await api.getMethod();
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isSuperuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSuperuser = prefs.getBool('is_superuser');
    return isSuperuser ?? false;
  }

  void _onItemTapped(int index) {
    Future.delayed(Duration.zero, () {
      setState(() {
        _selectedIndex = index;
      });
    });
  }

  Widget _getBodyWidget() {
    switch (_selectedIndex) {
      case 0:
        return FutureBuilder<bool>(
          future: isSuperuser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data == true) {
              return SuperuserHome(
                onselect: _onItemTapped,
              );
            } else {
              return UserHome(
                onselect: _onItemTapped,
              );
            }
          },
        );
      case 1:
        return const KnowledgeNexus();
      case 2:
        return UserHome(
          onselect: _onItemTapped,
        ); // Replace with the appropriate widget for "Shop"
      default:
        return UserHome(
          onselect: _onItemTapped,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        drawer: UserSidebar(
          onselect: _onItemTapped,
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          actions: [
            FutureBuilder<bool>(
              future: userPresent,
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
                        style: const TextStyle(fontSize: 12),
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
                size: 30,
                color: _selectedIndex == 0 ? SECONDARY_COLOR : Colors.grey[600],
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.language,
                size: 30,
                color: _selectedIndex == 1 ? SECONDARY_COLOR : Colors.grey[600],
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                size: 30,
                color: _selectedIndex == 2 ? SECONDARY_COLOR : Colors.grey[600],
              ),
              label: "",
            ),
          ],
        ),
      ),
    );
  }
}
