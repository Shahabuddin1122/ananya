import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalizationsExtension on AppLocalizations {
  String translateCondition(String key) {
    switch (key) {
      case 'Yeast infection':
        return yeast_infection;
      case 'Urinary track infections':
        return urinary_track_infections;
      case 'Bacterial Vaginosis':
        return bacterial_vaginosis;
      case 'Polycystic Ovary Syndrome':
        return polycystic_ovary_syndrome;
      case 'Endometriosis':
        return endometriosis;
      case 'Fibroids':
        return fibroids;
      case 'I’m not sure':
        return i_m_not_sure;
      case 'No health issues':
        return no_health_issues;
      default:
        return key;
    }
  }
}
