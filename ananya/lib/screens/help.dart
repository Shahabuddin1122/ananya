import 'package:ananya/models/help_data.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/help_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    final helpData = HelpProvider.helpData(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.help),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: Theme.of(context).largemainPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.help_number_list,
              style: const TextStyle(
                fontSize: 16,
                color: ACCENT,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ...helpData.map((item) {
              return HelpCard(
                number: item['number']!,
                text: item['description']!,
              );
            }),
          ],
        ),
      )),
    );
  }
}
