import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/help_card.dart';
import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help'),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: Theme.of(context).largemainPadding,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Help number list",
              style: TextStyle(
                fontSize: 16,
                color: ACCENT,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            HelpCard(
              number: '16263',
              text:
                  'Health related call center. Dial this number to get 24 hour support from doctor.',
            ),
            HelpCard(
              number: '109',
              text:
                  'Governmental helpline to protect Woman agaist crime/early marriage',
            ),
          ],
        ),
      )),
    );
  }
}
