import 'package:ananya/models/period_state_questionnaire.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/calender.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:ananya/widgets/dynamic_calender.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnlockProcess4 extends StatelessWidget {
  final bool update_period;
  const UnlockProcess4({required this.update_period, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBarWithProgress(
          progressValue: 0.67,
          id: 4,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: Theme.of(context).largemainPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'When did your \n',
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      TextSpan(
                        text: 'last period ',
                        style: TextStyle(
                          fontSize: 32,
                          color: PRIMARY_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'start?',
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const DynamicCalendar(),
                const SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (update_period) {
                      Navigator.pushNamed(context, '/unlock-process/6',
                          arguments: update_period);
                    } else {
                      Navigator.pushNamed(context, '/unlock-process/5');
                    }
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    minimumSize:
                        WidgetStatePropertyAll(Size(double.infinity, 20)),
                    shadowColor: WidgetStatePropertyAll(Colors.black),
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    "I don't know",
                    style: TextStyle(
                      color: ACCENT,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (update_period) {
                      Navigator.pushNamed(context, '/unlock-process/6',
                          arguments: update_period);
                    } else {
                      Navigator.pushNamed(context, '/unlock-process/5');
                    }
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(ACCENT),
                    minimumSize:
                        WidgetStatePropertyAll(Size(double.infinity, 20)),
                    shadowColor: WidgetStatePropertyAll(Colors.black),
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
