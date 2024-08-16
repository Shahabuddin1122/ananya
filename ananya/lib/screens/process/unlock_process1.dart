import 'package:ananya/models/period_state_questionnaire.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/choice_item.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnlockProcess1 extends StatefulWidget {
  const UnlockProcess1({super.key});

  @override
  State<UnlockProcess1> createState() => _UnlockProcess1State();
}

class _UnlockProcess1State extends State<UnlockProcess1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithProgress(
        progressValue: 0.167,
        id: 1,
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
                      text: 'Are your periods ',
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: 'regular',
                      style: TextStyle(
                        fontSize: 32,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '?',
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
                "Regular means that the gap between your periods is around the same number of days each month",
              ),
              const SizedBox(
                height: 10,
              ),
              ChoiceItem(
                text: 'Yes',
                onSelected: (choice) {
                  context.read<PeriodState>().updatePeriodRegularity(true);
                  Navigator.pushNamed(context, '/unlock-process/2');
                },
              ),
              ChoiceItem(
                text: 'No',
                onSelected: (choice) {
                  context.read<PeriodState>().updatePeriodRegularity(false);
                  Navigator.pushNamed(context, '/unlock-process/2');
                },
              ),
              ChoiceItem(
                text: 'I don\'t Know',
                onSelected: (choice) {
                  context.read<PeriodState>().updatePeriodRegularity(false);
                  Navigator.pushNamed(context, '/unlock-process/2');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
