import 'package:ananya/utils/constants.dart';
import 'package:flutter/material.dart';

class UserSidebar extends StatelessWidget {
  const UserSidebar({super.key});

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
                child: Image.asset('assets/images/hotline.png'),
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
          const ListTile(
            title: Text('GET HELP'),
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
          ListTile(
            title: const Text("PERIOD HISTORY"),
            onTap: () => Navigator.pushNamed(context, '/history/indivisual'),
          ),
        ],
      ),
    );
  }
}
