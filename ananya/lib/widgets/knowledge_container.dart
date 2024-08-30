import 'package:ananya/models/knowledge_nexus_data.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';

class KnowledgeContainer extends StatelessWidget {
  final String id;
  final Map<String, String> data;
  const KnowledgeContainer({
    required this.id,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/knowledge-nexus-info',
          arguments: [id, data],
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              data['hero_image']!,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            color: ACCENT,
            padding: Theme.of(context).insideCardPadding,
            child: Text(
              data['question']!,
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
