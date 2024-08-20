import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSidebar extends StatefulWidget {
  const UserSidebar({super.key});

  @override
  State<UserSidebar> createState() => _UserSidebarState();
}

class _UserSidebarState extends State<UserSidebar> {
  bool _isSuperuser = false;

  @override
  void initState() {
    super.initState();
    _checkSuperuserStatus();
  }

  Future<void> _checkSuperuserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSuperuser = prefs.getBool('is_superuser');
    setState(() {
      _isSuperuser = isSuperuser ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              "Shahabuddin",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            accountEmail: const Text(
              "shavoddin54@gmail.com",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/images/default_person.png'),
              ),
            ),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          ListTile(
            title: const Text(
              "HOME",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Text("LOG NEW PERIOD"),
            onTap: () {
              Navigator.pushNamed(context, '/new-period');
            },
          ),
          if (_isSuperuser)
            ListTile(
              title: const Text("ADD A USER"),
              onTap: () {
                Navigator.pushNamed(context, '/add-user');
              },
            ),
          ListTile(
            title: const Text("CHAT WITH ANANYA"),
            onTap: () {
              Navigator.pushNamed(context, '/chat');
            },
          ),
          ListTile(
            title: const Text("KNOWLEDGE NEXUS"),
            onTap: () => Navigator.pushNamed(context, '/knowledge-nexus'),
          ),
          ListTile(
            title: const Text("VISIT SHOP"),
            onTap: () => Navigator.pushNamed(context, '/visit-shop'),
          ),
          ListTile(
            title: const Text("PERIOD HISTORY"),
            onTap: () {
              if (_isSuperuser) {
                Navigator.pushNamed(context, '/history/cohort');
              } else {
                Navigator.pushNamed(context, '/history/indivisual');
              }
            },
          ),
          const Divider(
            height: 1,
            color: Color(0xFF405070),
          ),
          const ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('LANGUAGE'),
                Row(
                  children: [
                    Text("BN"),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "EN",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const ListTile(
            title: Text('GET HELP'),
          ),
          ListTile(
            title: const Text("LOG OUT"),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('userNumber');
              await prefs.remove('userId');
              await prefs.remove('is_superuser');
              await prefs.remove('cohort-user');
              Navigator.pushNamed(context, '/signin');
            },
          ),
        ],
      ),
    );
  }
}
