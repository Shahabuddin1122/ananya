import 'package:ananya/widgets/web-view-screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Probahini extends StatelessWidget {
  const Probahini({super.key});

  void _navigateToWebView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WebViewScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/images/Anannya Anim 1.svg',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.08,
            top: MediaQuery.of(context).size.height * 0.07,
            child: Text(
              AppLocalizations.of(context)!
                  .hi_i_am_probahini_your_menstrual_companion_ask_me_anything,
              style: const TextStyle(
                fontSize: 11,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.035,
            left: MediaQuery.of(context).size.width * 0.035,
            child: ElevatedButton(
              onPressed: () => _navigateToWebView(context),
              child: Text(AppLocalizations.of(context)!.begin_chat),
            ),
          ),
        ],
      ),
    );
  }
}
