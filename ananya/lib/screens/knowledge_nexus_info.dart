import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/knowledge_container.dart';
import 'package:ananya/widgets/video_player.dart';
import 'package:flutter/material.dart';

class KnowledgeNexusInfo extends StatelessWidget {
  const KnowledgeNexusInfo({super.key});

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
            Container(
              width: double.infinity,
              height: 250,
              color: PRIMARY_COLOR,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: Theme.of(context).largemainPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What is mestrual cycle?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ACCENT,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Menstrual Cycle is the time period between first day of menstuation to first day of next period.\n\nTypically menstrual cycle are 28 days long. But it can vary from 21 to 35 days",
                    style: TextStyle(
                      fontSize: 16,
                      color: ACCENT,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: PRIMARY_COLOR,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Menstrual Cycle is the time period between first day of menstuation to first day of next period.\n\nTypically menstrual cycle are 28 days long. But it can vary from 21 to 35 days",
                    style: TextStyle(
                      fontSize: 16,
                      color: ACCENT,
                    ),
                  ),
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
                  const SizedBox(
                    height: 20,
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
                    height: 20,
                  ),
                  const Wrap(
                    direction: Axis.horizontal,
                    spacing: 15.0,
                    runSpacing: 15.0,
                    children: [
                      KnowledgeContainer(
                        text: "What is menstrution?",
                        image: 'assets/images/menstruation.jpg',
                      ),
                      KnowledgeContainer(
                        text: "What is menstrution?",
                        image: 'assets/images/menstruation.jpg',
                      ),
                      KnowledgeContainer(
                        text: "What is menstrution?",
                        image: 'assets/images/menstruation.jpg',
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
