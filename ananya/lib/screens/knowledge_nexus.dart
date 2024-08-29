import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/knowledge_container.dart';
import 'package:flutter/material.dart';

class KnowledgeNexus extends StatelessWidget {
  KnowledgeNexus({super.key});

  final List<Map<String, String>> knowledgeItems = [
    {
      "text": "What is Menstruation?",
      "image": "assets/images/menstruation.jpg"
    },
    {
      "text": "What is Menstruation Cycle?",
      "image": "assets/images/periodcycle1.jpg"
    },
    {
      "text": "Learn about the common symptoms of Menstruation",
      "image": "assets/images/menssymp.jpg"
    },
    {
      "text": "What are the steps of Menstruation Cycle?",
      "image": "assets/images/stagesofmens.jpg"
    },
    {
      "text": "What is abnormal Menstruation?",
      "image": "assets/images/abnormalmens.jpg"
    },
    {
      "text": "What are the common misconceptions about menstruation?",
      "image": "assets/images/missperiod.jpg"
    },
    {
      "text": "What is PMS or Premenstrual Syndrome?",
      "image": "assets/images/pmsimage.jpg"
    },
    {
      "text": "When should a doctor be consulted?",
      "image": "assets/images/doctorsadvise.jpg"
    },
    {
      "text": "What should be the food habit during menstruation?",
      "image": "assets/images/foodhabitttt.jpg"
    },
    {
      "text": "Why is iron important for girls?",
      "image": "assets/images/ironneed.jpg"
    },
    {
      "text": "Necessary hygiene measures during menstruation",
      "image": "assets/images/img_image7.png"
    },
    {
      "text":
          "What are the pillars of menstrual health and menstrual hygiene management?",
      "image": "assets/images/menstruationmisconception.jpg"
    },
    {
      "text": "What are the things needed during menstruation?",
      "image": "assets/images/thingsneeded.jpg"
    },
    {
      "text": "Menstrual health care is a human right",
      "image": "assets/images/humanright.jpg"
    },
    {
      "text": "What Could Cause a Late or Missed Period?",
      "image": "assets/images/latepriod.jpg"
    },
    {
      "text": "Why should a girl know about this before menstruation?",
      "image": "assets/images/thingstoknowbeforefirstperiod.jpg"
    },
    {
      "text": "What to do on first period?",
      "image": "assets/images/firstperiod.jpg"
    },
    {
      "text":
          "What preparations should girls take so that menstruation does not interfere with daily life?",
      "image": "assets/images/regularprep.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: Theme.of(context).largemainPadding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, PRIMARY_COLOR.withOpacity(0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Common asked question on Menstruation',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: ACCENT,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 0.75,
              ),
              itemCount: knowledgeItems.length,
              itemBuilder: (context, index) {
                return KnowledgeContainer(
                  text: knowledgeItems[index]['text']!,
                  image: knowledgeItems[index]['image']!,
                );
              },
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: Theme.of(context).insideCardPadding,
              decoration: BoxDecoration(
                color: PRIMARY_COLOR.withOpacity(0.4),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Do you know we have governmental regulation about menstrual?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ACCENT,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.width * 0.30,
                        decoration: BoxDecoration(
                          color: PRIMARY_COLOR,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: Theme.of(context).insideCardPadding,
                              child: const Text(
                                "National MHM Strategies",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 35,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text("VIEW"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.width * 0.30,
                        decoration: BoxDecoration(
                          color: SECONDARY_COLOR,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: Theme.of(context).insideCardPadding,
                              child: const Text(
                                "Call to Learn More",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 35,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                  ),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text("CLICK NOW..."),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
