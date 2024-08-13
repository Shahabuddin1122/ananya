import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:ananya/widgets/dynamic_calender.dart';
import 'package:ananya/widgets/input_box.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class UnlockProcess3 extends StatelessWidget {
  const UnlockProcess3({super.key});

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
                    child: const DynamicCalender(),
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
                          const Text("Menstruation")
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
                          const Text("Ovulation")
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
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Log your periods to get ',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                        TextSpan(
                          text: 'accurate predictions',
                          style: TextStyle(
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
                  const Text(
                      "Logging your period when it happens in the Ananya App will get you accurate predictions of your next period cycle."),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/unlock-process4');
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
            )
          ],
        ),
      ),
    );
  }
}
