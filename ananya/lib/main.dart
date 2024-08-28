import 'package:ananya/l10n/l10n.dart';
import 'package:ananya/models/period_state_questionnaire.dart';
import 'package:ananya/screens/add_a_user.dart';
import 'package:ananya/screens/choose_user.dart';
import 'package:ananya/screens/history/cohort.dart';
import 'package:ananya/screens/history/individual.dart';
import 'package:ananya/screens/knowledge_nexus_info.dart';
import 'package:ananya/screens/landing/landing.dart';
import 'package:ananya/screens/loading.dart';
import 'package:ananya/screens/period_date_show.dart';
import 'package:ananya/screens/process/unlock_process1.dart';
import 'package:ananya/screens/process/unlock_process2.dart';
import 'package:ananya/screens/process/unlock_process3.dart';
import 'package:ananya/screens/process/unlock_process4.dart';
import 'package:ananya/screens/process/unlock_process5.dart';
import 'package:ananya/screens/process/unlock_process6.dart';
import 'package:ananya/screens/sign_in.dart';
import 'package:ananya/screens/sign_up.dart';
import 'package:ananya/utils/scheme.dart';
import 'package:ananya/screens/help.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('language_code');
  Locale initialLocale = Locale(languageCode ?? 'bn');

  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatefulWidget {
  final Locale initialLocale;

  const MyApp({required this.initialLocale, Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PeriodState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        theme: Scheme.lightTheme,
        themeMode: ThemeMode.system,
        locale: _locale,
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routes: {
          '/': (context) => const Landing(),
          '/signin': (context) => const SignIn(),
          '/signup': (context) => const SignUp(),
          '/add-user': (context) => const AddAUser(),
          '/choose-user': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as bool;
            return ChooseUser(updateperiod: args);
          },
          '/unlock-process/1': (context) => const UnlockProcess1(),
          '/unlock-process/2': (context) => const UnlockProcess2(),
          '/unlock-process/3': (context) => UnlockProcess3(),
          '/unlock-process/4': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as bool;
            return UnlockProcess4(update_period: args);
          },
          '/unlock-process/5': (context) => const UnlockProcess5(),
          '/unlock-process/6': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as bool;
            return UnlockProcess6(update_period: args);
          },
          '/loading': (context) => const Loading(),
          '/period-date': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return PeriodDateShow(data: args);
          },
          '/history/indivisual': (context) => const IndividualHistory(),
          '/history/cohort': (context) => const CohortHistory(),
          '/knowledge-nexus': (context) => const KnowledgeNexusInfo(),
          '/help': (context) => const Help(),
        },
      ),
    );
  }
}
