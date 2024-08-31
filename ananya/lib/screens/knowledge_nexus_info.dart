import 'package:ananya/models/knowledge_nexus_data.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/knowledge_container.dart';
import 'package:ananya/widgets/video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KnowledgeNexusInfo extends StatelessWidget {
  final String id;
  final Map<String, String> data;
  const KnowledgeNexusInfo({required this.data, required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    final relatedInfo = KnowledgeItemProvider.getAdditionalInfo(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.knowledge_nexus),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              width: double.infinity,
              height: 300,
              data['hero_image']!,
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
                    data['question']!,
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
                    data['first_description']!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: ACCENT,
                    ),
                  ),
                  if (data['second_description'] != null) ...[
                    const SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                      width: double.infinity,
                      data['additional_image_1']!,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      data['second_description']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: ACCENT,
                      ),
                    ),
                  ] else ...[
                    Container(),
                  ],
                  if (data['video_id'] != null) ...[
                    const SizedBox(
                      height: 20,
                    ),
                    VideoPlayer(id: data['video_id']),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      data['third_description']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: ACCENT,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ] else ...[
                    Container(),
                  ],
                  const Divider(
                    color: ACCENT,
                    thickness: 0.5,
                  ),
                  Text(
                    AppLocalizations.of(context)!.recomended_reading_for_you,
                    style: const TextStyle(
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
                        id: relatedInfo[index]['id']!,
                        data: relatedInfo[index],
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
