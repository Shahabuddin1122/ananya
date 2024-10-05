import 'dart:convert';
import 'package:ananya/main.dart';
import 'package:ananya/utils/api_settings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/widgets/web-view-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserSidebar extends StatefulWidget {
  final Function(int) onselect;
  const UserSidebar({required this.onselect, super.key});

  @override
  State<UserSidebar> createState() => _UserSidebarState();
}

class _UserSidebarState extends State<UserSidebar> {
  bool _isSuperuser = false;
  Locale _currentLocale = const Locale('bn');
  String? _userName;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _checkSuperuserStatus();
    _loadLocale();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userName = prefs.getString('userName');

    setState(() {
      _isLoggedIn = token != null && userName != null;
      _userName = userName;
    });
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
          if (_isLoggedIn) ...[
            UserAccountsDrawerHeader(
              accountName: Text(
                _userName ?? '',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              accountEmail: Text(
                '',
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset('assets/images/default_person.png'),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
          ] else ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ],
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
              AppLocalizations.of(context)!.home,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              widget.onselect(0);
            },
          ),
          if (_isLoggedIn) ...[
            ListTile(
              leading: const Icon(Icons.track_changes),
              title: Text(
                AppLocalizations.of(context)!.log_new_period,
              ),
              onTap: () {
                if (_isSuperuser) {
                  Navigator.pushNamed(context, '/choose-user',
                      arguments: false);
                } else {
                  Navigator.pushNamed(context, '/unlock-process/1');
                }
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
          ],
          ListTile(
            leading: const Icon(Icons.chat),
            title: Text(
              AppLocalizations.of(context)!.chat_with_ananya,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WebViewScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: Text(AppLocalizations.of(context)!.knowledge_nexus),
            onTap: () {
              Navigator.pop(context);
              widget.onselect(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: Text(AppLocalizations.of(context)!.visit_shop),
            onTap: () => Navigator.pushNamed(context, '/'),
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
          if (_isLoggedIn) ...[
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.log_out),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                FlutterLocalNotificationsPlugin
                    flutterLocalNotificationsPlugin =
                    FlutterLocalNotificationsPlugin();
                await flutterLocalNotificationsPlugin.cancelAll();
                Navigator.pushNamed(context, '/signin');
              },
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: Text(
                AppLocalizations.of(context)!.log_in,
                style: const TextStyle(color: ACCENT),
              ),
              onTap: () async {
                Navigator.pushNamed(context, '/signin');
              },
            ),
          ],
        ],
      ),
    );
  }
}
