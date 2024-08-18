import 'package:ananya/models/period_state_questionnaire.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/choice_item.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnlockProcess5 extends StatelessWidget {
  const UnlockProcess5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithProgress(
        progressValue: 0.83,
        id: 5,
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
                      text: 'Do you take \n',
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: 'birth control ',
                      style: TextStyle(
                        fontSize: 32,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'measures?',
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
                "We are asking because some type of birth control measures can potentially impact yout menstrual cycle.",
              ),
              const SizedBox(
                height: 10,
              ),
              ChoiceItem(
                text: 'Yes',
                onSelected: (choice) {
                  context.read<PeriodState>().updateBirthControl(true);
                  Navigator.pushNamed(
                    context,
                    '/unlock-process/6',
                    arguments: false,
                  );
                },
              ),
              ChoiceItem(
                text: 'No',
                onSelected: (choice) {
                  context.read<PeriodState>().updateBirthControl(false);
                  Navigator.pushNamed(
                    context,
                    '/unlock-process/6',
                    arguments: false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
