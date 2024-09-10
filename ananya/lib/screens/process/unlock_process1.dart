import 'package:ananya/models/period_state_questionnaire.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/choice_item.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: AppLocalizations.of(context)!.are_your_periods,
                      style: const TextStyle(
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: AppLocalizations.of(context)!.regular,
                      style: const TextStyle(
                        fontSize: 32,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
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
              Text(
                AppLocalizations.of(context)!
                    .regular_means_that_the_gap_between_your_periods_is_around_the_same_number_of_days_each_month,
              ),
              const SizedBox(
                height: 10,
              ),
              ChoiceItem(
                text: AppLocalizations.of(context)!.yes,
                onSelected: (choice) {
                  context.read<PeriodState>().updatePeriodRegularity(true);
                  Navigator.pushNamed(context, '/unlock-process/2');
                },
              ),
              ChoiceItem(
                text: AppLocalizations.of(context)!.no,
                onSelected: (choice) {
                  context.read<PeriodState>().updatePeriodRegularity(false);
                  Navigator.pushNamed(context, '/unlock-process/2');
                },
              ),
              ChoiceItem(
                text: AppLocalizations.of(context)!.dont_know,
                onSelected: (choice) {
                  context.read<PeriodState>().updatePeriodRegularity(true);
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
