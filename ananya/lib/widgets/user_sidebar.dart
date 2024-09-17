import 'dart:convert';

import 'package:ananya/main.dart';
import 'package:ananya/utils/api_sattings.dart';
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
  Locale _currentLocale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _checkSuperuserStatus();
    _loadLocale();
  }

  Future<Map<String, dynamic>> getInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('userId');
    ApiSettings api = ApiSettings(endPoint: 'user/get-user/$id');
    try {
      final response = await api.getMethod();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null;
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
          FutureBuilder<Map<String, dynamic>>(
            future: getInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ],
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return UserAccountsDrawerHeader(
                  accountName: Text(
                    snapshot.data!['name'],
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  accountEmail: Text(
                    snapshot.data!['email'],
                    style: const TextStyle(
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
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ],
                );
              }
            },
          ),
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
          FutureBuilder<Map<String, dynamic>>(
            future: getInfo(),
            builder: (context, loginSnapshot) {
              if (!loginSnapshot.hasData || loginSnapshot.data!.isEmpty) {
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.track_changes),
                      title: Text(
                        AppLocalizations.of(context)!.log_new_period,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .you_need_to_log_in_first),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.track_changes),
                    title: Text(
                      AppLocalizations.of(context)!.log_new_period,
                    ),
                    onTap: () {
                      if (_isSuperuser) {
                        Navigator.pushNamed(
                          context,
                          '/choose-user',
                          arguments: false,
                        );
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
              );
            },
          ),
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
          FutureBuilder<Map<String, dynamic>>(
              future: getInfo(),
              builder: (context, loginSnapshot) {
                if (!loginSnapshot.hasData || loginSnapshot.data!.isEmpty) {
                  return Container(
                    color: ACCENT,
                    child: ListTile(
                      leading: const Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.log_in,
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/signin');
                      },
                    ),
                  );
                } else {
                  return ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(AppLocalizations.of(context)!.log_out),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('userNumber');
                      await prefs.remove('userId');
                      await prefs.remove('is_superuser');
                      await prefs.remove('cohort-user');
                      await prefs.remove('token');
                      await prefs.remove('last_notification_date');
                      FlutterLocalNotificationsPlugin
                          flutterLocalNotificationsPlugin =
                          FlutterLocalNotificationsPlugin();
                      await flutterLocalNotificationsPlugin.cancelAll();
                      Navigator.pushNamed(context, '/signin');
                    },
                  );
                }
              }),
        ],
      ),
    );
  }
}
