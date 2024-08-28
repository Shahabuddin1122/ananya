import 'package:ananya/models/period_state_questionnaire.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:ananya/widgets/input_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.what_is_the,
                      style: const TextStyle(
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.number_of_days,
                      style: const TextStyle(
                        fontSize: 32,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!
                          .between_your_periods_and,
                      style: const TextStyle(
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.how_long,
                      style: const TextStyle(
                        fontSize: 32,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.does_it_last,
                      style: const TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!
                    .generally_periods_occur_every_21_to_35_days_and_last_2_to_7_days,
              ),
              const SizedBox(
                height: 10,
              ),
              InputBox(
                text: AppLocalizations.of(context)!
                    .number_of_days_between_period_eg_27_days,
                controller: _daysBetweenPeriodController,
              ),
              InputBox(
                text: AppLocalizations.of(context)!
                    .length_of_your_period_eg_6_days,
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
                child: Text(
                  AppLocalizations.of(context)!.i_dont_know,
                  style: const TextStyle(
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
                child: Text(AppLocalizations.of(context)!.continues),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
