import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';

class HelpCard extends StatelessWidget {
  final String number, text;
  const HelpCard({required this.number, required this.text, super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Theme.of(context).insideCardPadding,
      margin: Theme.of(context).subSectionDividerPadding,
      decoration: BoxDecoration(
        color: PRIMARY_COLOR.withOpacity(0.5),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => _makePhoneCall(number),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.call,
                  size: 30,
                ),
                Text(
                  "Call now",
                  style: TextStyle(
                    fontSize: 14,
                    color: ACCENT,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  number,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  text,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
