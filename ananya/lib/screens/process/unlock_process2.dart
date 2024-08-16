import 'package:ananya/models/period_state_questionnaire.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:ananya/widgets/input_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnlockProcess2 extends StatefulWidget {
  const UnlockProcess2({super.key});

  @override
  State<UnlockProcess2> createState() => _UnlockProcess2State();
}

class _UnlockProcess2State extends State<UnlockProcess2> {
  final TextEditingController _daysBetweenPeriodController =
      TextEditingController();
  final TextEditingController _lengthOfPeriodController =
      TextEditingController();

  void _onContinuePressed(BuildContext context) {
    final periodState = context.read<PeriodState>();

    final int? daysBetweenPeriod =
        int.tryParse(_daysBetweenPeriodController.text);
    final int? lengthOfPeriod = int.tryParse(_lengthOfPeriodController.text);

    if (daysBetweenPeriod != null) {
      periodState.updateDaysBetweenPeriod(daysBetweenPeriod);
    }
    if (lengthOfPeriod != null) {
      periodState.updateLengthOfPeriod(lengthOfPeriod);
    }

    Navigator.pushNamed(context, '/unlock-process/3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithProgress(
        progressValue: 0.33,
        id: 2,
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
                      text: 'What is the\n',
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: 'number of days\n',
                      style: TextStyle(
                        fontSize: 32,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'between your periods and \n',
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: 'how long ',
                      style: TextStyle(
                        fontSize: 32,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'does it last?',
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Generally, periods occur every 21 to 35 days and last 2 to 7 days.",
              ),
              const SizedBox(
                height: 10,
              ),
              InputBox(
                text: 'Number of days between period e.g 27 days',
                controller: _daysBetweenPeriodController,
              ),
              InputBox(
                text: 'Length of your period e.g 6 days...',
                controller: _lengthOfPeriodController,
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/unlock-process/3');
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
                onPressed: () => _onContinuePressed(context),
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(ACCENT),
                  minimumSize:
                      WidgetStatePropertyAll(Size(double.infinity, 20)),
                  side: WidgetStatePropertyAll(
                    BorderSide(
                      width: 1,
                    ),
                  ),
                ),
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
