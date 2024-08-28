import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';

class KnowledgeContainer extends StatelessWidget {
  final String text;
  const KnowledgeContainer({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/knowledge-nexus');
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 100,
              color: PRIMARY_COLOR,
            ),
            Container(
              color: ACCENT,
              padding: Theme.of(context).insideCardPadding,
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
