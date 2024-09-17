import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  Future<void> _searchInMaps() async {
    const String query = 'hospitals,pharmacies';
    final Uri url =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: Theme.of(context).insideCardPadding,
        decoration: const BoxDecoration(
          color: Color(0xFF405070),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/Sanitary Pads 1.svg',
              height: 100,
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.shop,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              AppLocalizations.of(context)!.for_menstrual_health_products,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _searchInMaps,
              child: Text(
                AppLocalizations.of(context)!.view_product,
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
