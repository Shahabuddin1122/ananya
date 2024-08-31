import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HelpProvider {
  static List<Map<String, String>> helpData(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [
      {
        "number": localizations.help_number_16263,
        "description": localizations.help_description_16263,
      },
      {
        "number": localizations.help_number_109,
        "description": localizations.help_description_109,
      },
      {
        "number": localizations.help_number_10921,
        "description": localizations.help_description_10921,
      },
      {
        "number": localizations.help_number_333,
        "description": localizations.help_description_333,
      },
      {
        "number": localizations.help_number_01779554391_01779554392,
        "description": localizations.help_description_01779554391_01779554392,
      },
      {
        "number": localizations.help_number_01776632344,
        "description": localizations.help_description_01776632344,
      },
      {
        "number": localizations.help_number_09678771511,
        "description": localizations.help_description_09678771511,
      },
      {
        "number": localizations.help_number_09612600600,
        "description": localizations.help_description_09612600600,
      },
    ];
  }
}
