import 'dart:io';

import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/knowledge_container.dart';
import 'package:ananya/widgets/pdf-viewer-screen.dart';
import 'package:flutter/material.dart';
import 'package:ananya/models/knowledge_nexus_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class KnowledgeNexus extends StatefulWidget {
  const KnowledgeNexus({super.key});

  @override
  State<KnowledgeNexus> createState() => _KnowledgeNexusState();
}

class _KnowledgeNexusState extends State<KnowledgeNexus> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, String>> knowledgeItems = [];
  List<Map<String, String>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final knowledgeItemsData =
          KnowledgeItemProvider.getKnowledgeItems(context);
      setState(() {
        knowledgeItems = knowledgeItemsData;
        filteredItems = List.from(knowledgeItemsData);
      });
    });
    searchController.addListener(_filterKnowledgeItems);
  }

  Future<void> _makeMHMCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '16263',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch 16263';
    }
  }

  Future<String?> downloadPDF() async {
    try {
      final byteData = await rootBundle.load('assets/pdf/nmhmsbn.pdf');
      final buffer = byteData.buffer;

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/mhm.pdf';

      final file = File(filePath);
      await file.writeAsBytes(buffer.asUint8List());

      print('PDF saved to: $filePath');
      return filePath;
    } catch (e) {
      print('Error downloading PDF: $e');
      return null;
    }
  }

  void _filterKnowledgeItems() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredItems = knowledgeItems.where((item) {
        final question = item['question']?.toLowerCase() ?? '';
        return question.contains(query);
      }).toList();
    });
  }

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
              controller: searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search,
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
            Text(
              AppLocalizations.of(context)!
                  .common_asked_question_on_menstruation,
              style: const TextStyle(
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
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return KnowledgeContainer(
                  id: filteredItems[index]['id']!,
                  data: filteredItems[index],
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
                  Text(
                    AppLocalizations.of(context)!
                        .do_you_know_we_have_governmental_regulation_about_menstrual,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
                        height: MediaQuery.of(context).size.width * 0.35,
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
                              child: Text(
                                AppLocalizations.of(context)!
                                    .national_mhm_strategies,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
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
                                onPressed: () async {
                                  await downloadPDF();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Pdf Downloaded'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                child: Text(AppLocalizations.of(context)!.view),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.width * 0.35,
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
                              child: Text(
                                AppLocalizations.of(context)!
                                    .call_to_learn_more,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
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
                                onPressed: () {
                                  _makeMHMCall();
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.click),
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
