import 'package:ananya/utils/api_sattings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/history_component.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IndividualHistory extends StatefulWidget {
  const IndividualHistory({super.key});

  @override
  State<IndividualHistory> createState() => _IndividualHistoryState();
}

class _IndividualHistoryState extends State<IndividualHistory> {
  int _selectedIndex = 0;

  final List<String> monthNames = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, List<dynamic>>> getAllHistoryData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('userId');
      final response =
          await ApiSettings(endPoint: 'user/get-period-history/$id')
              .getMethod();
      if (response.statusCode == 200) {
        List<dynamic> historyData = json.decode(response.body);

        Map<String, List<dynamic>> groupedData = {};
        for (var history in historyData) {
          String year = history['period_start'].split('-')[0];
          if (!groupedData.containsKey(year)) {
            groupedData[year] = [];
          }
          groupedData[year]!.add(history);
        }
        return groupedData;
      }
      return {};
    } catch (e) {
      print("Error $e");
      return {};
    }
  }

  Future<void> requestDataPurge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('userId');
    final response =
        await ApiSettings(endPoint: 'user/request-data-purge/$id').getMethod();
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(AppLocalizations.of(context)!.purge_request_successful)),
      );
      Navigator.pushNamed(context, '/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.purge_request_failed)),
      );
    }
  }

  void confirmPurge() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirm_purge_title),
          content: Text(AppLocalizations.of(context)!.confirm_purge_message),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.discard),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.confirm),
              onPressed: () {
                Navigator.of(context).pop();
                requestDataPurge();
              },
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.your_period_history),
      ),
      body: FutureBuilder<Map<String, List<dynamic>>>(
        future: getAllHistoryData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(AppLocalizations.of(context)!.error_loading_data));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child:
                    Text(AppLocalizations.of(context)!.no_history_available));
          } else {
            Map<String, List<dynamic>> groupedData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: Theme.of(context).largemainPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: groupedData.entries.map((entry) {
                    String year = entry.key;
                    List<dynamic> historyList = entry.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          year,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: ACCENT,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 15.0,
                          runSpacing: 15.0,
                          children: historyList.map((history) {
                            int monthNumber = int.parse(
                                history['period_start'].split('-')[1]);
                            String monthName = monthNames[monthNumber - 1];
                            return HistoryComponent(
                              month: monthName,
                              day: history['period_start'].split('-')[2],
                              monthcycle:
                                  history['days_between_period'].toString(),
                              anomalies:
                                  history['anomalies'] == 'Regular' ? 1 : 2,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[100],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: SECONDARY_COLOR,
        unselectedItemColor: Colors.grey[600],
        selectedFontSize: 16,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              size: 30,
              color: _selectedIndex == 0 ? SECONDARY_COLOR : Colors.grey[600],
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.language,
              size: 30,
              color: _selectedIndex == 1 ? SECONDARY_COLOR : Colors.grey[600],
            ),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              size: 30,
              color: _selectedIndex == 2 ? SECONDARY_COLOR : Colors.grey[600],
            ),
            label: "",
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: Theme.of(context).largemainPadding,
        child: ElevatedButton(
          onPressed: confirmPurge,
          style: ElevatedButton.styleFrom(
            backgroundColor: ACCENT,
            minimumSize: const Size(double.infinity, 50),
            shadowColor: Colors.black,
            side: const BorderSide(width: 1),
          ),
          child: Text(
            AppLocalizations.of(context)!.request_data_purge,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
