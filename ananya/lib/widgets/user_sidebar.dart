import 'package:ananya/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSidebar extends StatefulWidget {
  const UserSidebar({super.key});

  @override
  State<UserSidebar> createState() => _UserSidebarState();
}

class _UserSidebarState extends State<UserSidebar> {
  bool _isSuperuser = false;
  Locale _currentLocale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _checkSuperuserStatus();
    _loadLocale();
  }

  Future<void> _checkSuperuserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isSuperuser = prefs.getBool('is_superuser');
    setState(() {
      _isSuperuser = isSuperuser ?? false;
    });
  }

  Future<void> _loadLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('language_code');
    setState(() {
      _currentLocale = Locale(languageCode ?? 'en');
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    setState(() {
      _currentLocale = Locale(languageCode);
    });
    MyApp.setLocale(context, _currentLocale);
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
            leading: const Icon(Icons.home),
            title: Text(
              AppLocalizations.of(context)!.home,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.track_changes),
            title: Text(
              AppLocalizations.of(context)!.log_new_period,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/new-period');
            },
          ),
          if (_isSuperuser)
            ListTile(
              leading: const Icon(Icons.add),
              title: Text(
                AppLocalizations.of(context)!.add_a_user,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/add-user');
              },
            ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: Text(
              AppLocalizations.of(context)!.chat_with_ananya,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/chat');
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: Text(AppLocalizations.of(context)!.knowledge_nexus),
            onTap: () => Navigator.pushNamed(context, '/knowledge-nexus'),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: Text(AppLocalizations.of(context)!.visit_shop),
            onTap: () => Navigator.pushNamed(context, '/visit-shop'),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(
              AppLocalizations.of(context)!.period_history,
            ),
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
          ListTile(
            leading: const Icon(Icons.g_translate),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.language),
                PopupMenuButton<Locale>(
                  onSelected: (Locale locale) {
                    _changeLanguage(locale.languageCode);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: Locale('bn', ''),
                      child: Text("বাংলা"),
                    ),
                    const PopupMenuItem(
                      value: Locale('en', ''),
                      child: Text("English"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: Text(AppLocalizations.of(context)!.get_help),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(AppLocalizations.of(context)!.log_out),
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
