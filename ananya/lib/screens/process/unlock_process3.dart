import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/calender.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnlockProcess3 extends StatelessWidget {
  UnlockProcess3({super.key});

  final List<DateTime> redDates = [
    DateTime.utc(2024, 8, 14),
    DateTime.utc(2024, 8, 15),
    DateTime.utc(2024, 8, 16),
  ];

  final List<DateTime> greenDates = [
    DateTime.utc(2024, 8, 20),
    DateTime.utc(2024, 8, 21),
    DateTime.utc(2024, 8, 22),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithProgress(
        progressValue: 0.5,
        id: 3,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: Theme.of(context).largemainPadding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    PRIMARY_COLOR.withOpacity(0.2),
                    PRIMARY_COLOR.withOpacity(0.4),
                    PRIMARY_COLOR.withOpacity(0.6)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    color: Colors.white,
                    child: Calender(
                      menstrual: redDates,
                      ovulation: greenDates,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: PRIMARY_COLOR,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(AppLocalizations.of(context)!.menstruation)
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            color: SECONDARY_COLOR,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(AppLocalizations.of(context)!.ovulation)
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              padding: Theme.of(context).largemainPadding,
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .log_your_periods_to_get,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .accurate_predictions,
                          style: const TextStyle(
                            fontSize: 32,
                            color: ACCENT,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(AppLocalizations.of(context)!
                      .logging_your_period_when_it_happens_in_the_ananya_app_will_get_you_accurate_predictions_of_your_next_period_cycle),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/unlock-process/4',
                        arguments: false,
                      );
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
                    child: Text(
                      AppLocalizations.of(context)!.continues,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
