import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';

class KnowledgeContainer extends StatelessWidget {
  final String text, image;
  const KnowledgeContainer({
    required this.image,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/knowledge-nexus');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              image,
              fit: BoxFit.fill,
            ),
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
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
