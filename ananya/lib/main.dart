import 'package:ananya/models/period_state_questionnaire.dart';
import 'package:ananya/screens/add_a_user.dart';
import 'package:ananya/screens/choose_user.dart';
import 'package:ananya/screens/history/cohort.dart';
import 'package:ananya/screens/history/individual.dart';
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => PeriodState(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: Scheme.lightTheme,
      themeMode: ThemeMode.system,
      routes: {
        '/': (context) => const Landing(),
        '/signin': (context) => const SignIn(),
        '/signup': (context) => const SignUp(),
        '/add-user': (context) => const AddAUser(),
        '/choose-user': (context) => const ChooseUser(),
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
      },
    ),
  ));
}
