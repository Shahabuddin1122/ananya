import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String translateAnnomalies(BuildContext context, String text) {
  switch (text) {
    case 'Regular':
      return AppLocalizations.of(context)!.regular;
    case 'Irregular':
      return AppLocalizations.of(context)!.irregular;
    default:
      return text;
  }
}
