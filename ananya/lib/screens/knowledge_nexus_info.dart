import 'package:ananya/models/knowledge_nexus_data.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/knowledge_container.dart';
import 'package:flutter/material.dart';

class KnowledgeNexusInfo extends StatelessWidget {
  final String id;
  const KnowledgeNexusInfo({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge nexus'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              width: double.infinity,
              knowledgeItems[int.parse(id) - 1]['hero_image']!,
              fit: BoxFit.fill,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: Theme.of(context).largemainPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    knowledgeItems[int.parse(id) - 1]['question']!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ACCENT,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    knowledgeItems[int.parse(id) - 1]['first_description']!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: ACCENT,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (knowledgeItems[int.parse(id) - 1]['second_description'] !=
                      null) ...[
                    Image.asset(
                      width: double.infinity,
                      knowledgeItems[int.parse(id) - 1]['additional_image_1']!,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      knowledgeItems[int.parse(id) - 1]['second_description']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: ACCENT,
                      ),
                    ),
                  ] else ...[
                    Container(),
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                  // const VideoPlayer(
                  //   id: 'dfd',
                  // ),
                  const Divider(
                    color: ACCENT,
                    thickness: 0.5,
                  ),
                  const Text(
                    "To learn more",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ACCENT,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: 3, // Limit to 3 items
                    itemBuilder: (context, index) {
                      return KnowledgeContainer(
                        text: knowledgeItems[index]['question']!,
                        image: knowledgeItems[index]['hero_image']!,
                        id: knowledgeItems[index]['id']!,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
