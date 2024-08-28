import 'package:ananya/models/period_state_questionnaire.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/choice_item.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.do_you_take,
                      style: const TextStyle(
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.birth_control,
                      style: const TextStyle(
                        fontSize: 32,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.measures,
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
                    .we_are_asking_because_some_type_of_birth_control_measures_can_potentially_impact_your_menstrual_cycle,
              ),
              const SizedBox(
                height: 10,
              ),
              ChoiceItem(
                text: AppLocalizations.of(context)!.yes,
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
                text: AppLocalizations.of(context)!.no,
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
