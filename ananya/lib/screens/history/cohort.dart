import 'package:ananya/utils/api_sattings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/circle_image.dart';
import 'package:ananya/widgets/history_component.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CohortHistory extends StatefulWidget {
  const CohortHistory({super.key});

  @override
  State<CohortHistory> createState() => _CohortHistoryState();
}

class _CohortHistoryState extends State<CohortHistory> {
  int _selectedIndex = 0;
  late Future<String?> selectedUser = getSelectedUser();
  String? selectedUserId;

  @override
  void initState() {
    super.initState();
    selectedUser = getSelectedUser();
    getSelectedUser().then((id) {
      setState(() {
        selectedUserId = id;
      });
    });
  }

  void onSelectUser(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cohort-user', id);
    setState(() {
      selectedUserId = id;
    });
  }

  Future<String?> getSelectedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('cohort-user');
    return id;
  }

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

  Future<Map<String, List<dynamic>>> getAllHistoryData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString('cohort-user');
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

  Future<Map<String, dynamic>> getAllCohort() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('userId');
    ApiSettings api = ApiSettings(endPoint: 'user/get-cohort-user/$id');

    try {
      final response = await api.getMethod();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
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
        title: Text(AppLocalizations.of(context)!.cohort_period_history),
      ),
      body: FutureBuilder<String?>(
        future: selectedUser,
        builder: (context, selectedUserSnapshot) {
          if (selectedUserSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return FutureBuilder<Map<String, List<dynamic>>>(
            future: getAllHistoryData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error loading data"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No history available"));
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
                            FutureBuilder<Map<String, dynamic>>(
                              future: getAllCohort(),
                              builder: (context, cohortSnapshot) {
                                if (cohortSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (cohortSnapshot.hasError) {
                                  return const Center(
                                      child: Text('Error loading data'));
                                } else {
                                  return Wrap(
                                    direction: Axis.horizontal,
                                    spacing: 15,
                                    runSpacing: 15,
                                    children: cohortSnapshot.data!['predicted']
                                        .map<Widget>((user) {
                                      return CircleImage(
                                        image:
                                            'assets/images/default_person.png',
                                        isHighlighted:
                                            selectedUserSnapshot.data ==
                                                    user['id'].toString()
                                                ? true
                                                : false,
                                        id: user['id'].toString(),
                                        onSelect: onSelectUser,
                                      );
                                    }).toList(),
                                  );
                                }
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
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
          );
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
              size: _selectedIndex == 0 ? 40 : 30,
              color: _selectedIndex == 0 ? SECONDARY_COLOR : Colors.grey[600],
            ),
            label: "Tracker",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.language,
              size: _selectedIndex == 1 ? 40 : 30,
              color: _selectedIndex == 1 ? SECONDARY_COLOR : Colors.grey[600],
            ),
            label: "Knowledge Nexus",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              size: _selectedIndex == 2 ? 40 : 30,
              color: _selectedIndex == 2 ? SECONDARY_COLOR : Colors.grey[600],
            ),
            label: "Shop",
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: Theme.of(context).largemainPadding,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
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
