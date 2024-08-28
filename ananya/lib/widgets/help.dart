import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: Theme.of(context).insideCardPadding,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/hotline.png'),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.help,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              AppLocalizations.of(context)!.call_emergency_helpline,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/help');
              },
              child: Text(
                AppLocalizations.of(context)!.call_now,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
