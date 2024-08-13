import 'package:ananya/screens/landing.dart';
import 'package:ananya/screens/loading.dart';
import 'package:ananya/screens/period_date_show.dart';
import 'package:ananya/screens/unlock_process1.dart';
import 'package:ananya/screens/unlock_process2.dart';
import 'package:ananya/screens/unlock_process3.dart';
import 'package:ananya/screens/unlock_process4.dart';
import 'package:ananya/screens/unlock_process5.dart';
import 'package:ananya/screens/unlock_process6.dart';
import 'package:ananya/utils/scheme.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    theme: Scheme.lightTheme,
    themeMode: ThemeMode.system,
    routes: {
      '/': (context) => const Landing(),
      '/unlock-process/1': (context) => const UnlockProcess1(),
      '/unlock-process/2': (context) => const UnlockProcess2(),
      '/unlock-process/3': (context) => const UnlockProcess3(),
      '/unlock-process/4': (context) => const UnlockProcess4(),
      '/unlock-process/5': (context) => const UnlockProcess5(),
      '/unlock-process/6': (context) => const UnlockProcess6(),
      '/loading': (context) => const Loading(),
      '/period-date': (context) => const PeriodDateShow(),
    },
  ));
}
