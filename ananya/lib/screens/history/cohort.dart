import 'package:ananya/utils/api_settings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/circle_image.dart';
import 'package:ananya/widgets/history_component.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CohortHistory extends StatefulWidget {
  const CohortHistory({super.key});

  @override
  State<CohortHistory> createState() => _CohortHistoryState();
}

class _CohortHistoryState extends State<CohortHistory> {
  late Future<String?> selectedUser = getSelectedUser();
  String? selectedUserId;
  bool _isPurgeLoading = false;

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
      selectedUser = Future.value(id);
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
    if (selectedUserId == null) {
      return {};
    }

    try {
      final response =
          await ApiSettings(endPoint: 'user/get-period-history/$selectedUserId')
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

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirm),
          content: Text(AppLocalizations.of(context)!.confirm_purge_message),
          actions: <Widget>[
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

  Future<void> requestDataPurge() async {
    setState(() {
      _isPurgeLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('cohort-user');
    if (id == null) {
      setState(() {
        _isPurgeLoading = false;
      });
      return;
    }

    final response =
        await ApiSettings(endPoint: 'user/request-data-purge/$id').getMethod();
    if (response.statusCode == 200) {
      Map<String, dynamic> cohortUsers = await getAllCohort();
      List<dynamic> users = cohortUsers['predicted'] ?? [];

      if (users.isNotEmpty) {
        String newUserId = users.first['id'].toString();
        await prefs.setString('cohort-user', newUserId);
        setState(() {
          selectedUserId = newUserId;
          selectedUser = Future.value(newUserId);
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.purge_request_successful),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushNamed(context, '/');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.purge_request_failed),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isPurgeLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.cohort_period_history),
      ),
      body: Stack(
        children: [
          FutureBuilder<String?>(
            future: selectedUser,
            builder: (context, selectedUserSnapshot) {
              if (selectedUserSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: LottieBuilder.asset(
                    'assets/json/horizontal_loading.json',
                    width: 100,
                  ),
                );
              }

              if (!selectedUserSnapshot.hasData ||
                  selectedUserSnapshot.data == null) {
                return Center(
                    child:
                        Text(AppLocalizations.of(context)!.no_user_selected));
              }

              return FutureBuilder<Map<String, List<dynamic>>>(
                future: getAllHistoryData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Image.asset(
                      'assets/gif/loading.gif',
                      height: 400,
                      fit: BoxFit.contain,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            AppLocalizations.of(context)!.error_loading_data));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text(AppLocalizations.of(context)!
                            .no_history_available));
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
                                      return Center(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .error_loading_data));
                                    } else {
                                      return Wrap(
                                        direction: Axis.horizontal,
                                        spacing: 15,
                                        runSpacing: 15,
                                        children: cohortSnapshot
                                            .data!['predicted']
                                            .map<Widget>((user) {
                                          return CircleImage(
                                            image:
                                                'assets/images/default_person.png',
                                            isHighlighted:
                                                selectedUserSnapshot.data ==
                                                    user['id'].toString(),
                                            id: user['id'].toString(),
                                            anomalies: "Regular",
                                            onSelect: onSelectUser,
                                          );
                                        }).toList(),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
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
                                    String monthName =
                                        monthNames[monthNumber - 1];
                                    return HistoryComponent(
                                      month: monthName,
                                      day:
                                          history['period_start'].split('-')[2],
                                      monthcycle: history['days_between_period']
                                          .toString(),
                                      anomalies:
                                          history['anomalies'] == 'Regular'
                                              ? 1
                                              : 2,
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 30),
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
          if (_isPurgeLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Image.asset(
                  'assets/gif/loading.gif',
                  height: 400,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: Theme.of(context).largemainPadding,
        child: ElevatedButton(
          onPressed: () {
            _showConfirmationDialog();
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
