import 'dart:io';

import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/knowledge_container.dart';
import 'package:flutter/material.dart';
import 'package:ananya/models/knowledge_nexus_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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

  Future<void> downloadPDF(BuildContext context) async {
    try {
      if (Platform.isAndroid) {
        if (await Permission.manageExternalStorage.request().isGranted) {
          await _savePDFToStorage(context);
        } else if (await Permission.storage.request().isGranted) {
          await _savePDFToStorage(context);
        } else {
          print('Permission denied');
          _showSnackBar(context,
              AppLocalizations.of(context)!.permission_denied, Colors.red);
        }
      } else {
        // Handle iOS or other platforms if necessary
        if (await Permission.storage.request().isGranted) {
          await _savePDFToStorage(context);
        } else {
          print('Permission denied');
          _showSnackBar(context,
              AppLocalizations.of(context)!.permission_denied, Colors.red);
        }
      }
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }

  Future<void> _savePDFToStorage(BuildContext context) async {
    final byteData = await rootBundle.load('assets/pdf/nmhmsbn.pdf');
    final buffer = byteData.buffer;

    // Save to external downloads directory (public folder)
    final downloadsPath = '/storage/emulated/0/Download';
    final downloadDirectory = Directory(downloadsPath);

    if (!(await downloadDirectory.exists())) {
      await downloadDirectory.create(recursive: true);
    }

    final filePath =
        '$downloadsPath/National_Menstrual_Hygiene_Management_Strategy.pdf';
    final file = File(filePath);
    await file.writeAsBytes(buffer.asUint8List());
    print('PDF saved to: $downloadsPath');
    _showSnackBar(
        context, AppLocalizations.of(context)!.pdf_downloaded, Colors.green);
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
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
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
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
                                      await downloadPDF(context);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.view),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            width: 15), // Optional spacing between containers
                        Expanded(
                          child: Container(
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
                                    child: Text(
                                        AppLocalizations.of(context)!.click),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
