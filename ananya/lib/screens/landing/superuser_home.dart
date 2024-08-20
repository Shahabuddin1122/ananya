import 'dart:convert';

import 'package:ananya/utils/api_sattings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/advance_info.dart';
import 'package:ananya/widgets/help.dart';
import 'package:ananya/widgets/knowledge_nexus.dart';
import 'package:ananya/widgets/period_cycle_information.dart';
import 'package:ananya/widgets/probahini.dart';
import 'package:ananya/widgets/shop.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuperuserHome extends StatefulWidget {
  const SuperuserHome({super.key});

  @override
  State<SuperuserHome> createState() => _SuperuserHomeState();
}

class _SuperuserHomeState extends State<SuperuserHome> {
  late Future<bool> numberPresent;
  bool get_data = false;
  Future<Map<String, dynamic>>? _get_data;

  @override
  void initState() {
    super.initState();
    _get_data = getPeriodData();
  }

  Future<Map<String, dynamic>> getPeriodData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('cohort-user');
    print(id);
    ApiSettings api = ApiSettings(endPoint: 'user/get-prediction-period/$id');

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

  Stream<Map<String, dynamic>> getPeriodDataStream() async* {
    while (true) {
      yield await getPeriodData();
      await Future.delayed(Duration(seconds: 1));
    }
  }

  Stream<Map<String, dynamic>> getAdvanceInfoStream() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('cohort-user');
    ApiSettings api =
        ApiSettings(endPoint: 'user/advance-period-information/$id');

    try {
      final response = await api.getMethod();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        yield responseData;
      } else {
        yield {};
      }
    } catch (e) {
      yield {};
    }
  }

  String _formatPeriodDate(Map<String, dynamic>? data) {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');

    String startDate = data?['period_start_from'];
    String endDate = data?['period_start_to'];

    DateTime startDateTime = inputFormat.parse(startDate);
    DateTime endDateTime = inputFormat.parse(endDate);
    DateTime currentDate = DateTime.now();

    int daysUntilStart = startDateTime.difference(currentDate).inDays;
    int daysUntilEnd = endDateTime.difference(currentDate).inDays;

    if (startDate == endDate) {
      return "${daysUntilStart.abs() + 1} DAYS";
    } else {
      return "${daysUntilStart.abs() + 1} - ${daysUntilEnd.abs() + 1} DAYS";
    }
  }

  Stream<Map<String, dynamic>> getAllCohort() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('userId');
    ApiSettings api = ApiSettings(endPoint: 'user/get-cohort/$id');

    try {
      final response = await api.getMethod();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        yield responseData;
      } else {
        yield {};
      }
    } catch (e) {
      yield {};
    }
  }

  Stream<Map<String, dynamic>> getCombinedStream() {
    return Rx.zip2(
      getPeriodDataStream(),
      getAllCohort(),
      (periodData, cohortData) {
        return {
          'periodData': periodData,
          'cohortData': cohortData,
        };
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Period Start Today'),
          content: const Text('Your period starts today. Please confirm.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Discard'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? id = prefs.getString('cohort-user');
                await ApiSettings(
                        endPoint: 'user/update-period-information/$id')
                    .getMethod();

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? id = prefs.getString('userId');
                Map<String, String> data = {
                  "period_date": DateFormat('yyyy-MM-dd').format(DateTime.now())
                };
                final response =
                    await ApiSettings(endPoint: 'user/confim-period/$id')
                        .putMethod(json.encode(data));
                print(response.statusCode);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, PRIMARY_COLOR],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: Theme.of(context).largemainPadding,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<Map<String, dynamic>>(
                stream: getPeriodDataStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    DateFormat inputFormat = DateFormat('yyyy-MM-dd');
                    DateTime startDateTime =
                        inputFormat.parse(snapshot.data!['period_start_from']);
                    DateTime currentDate = DateTime.now();

                    int daysUntilStart =
                        startDateTime.difference(currentDate).inDays + 1;

                    if (daysUntilStart == 0) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _showConfirmationDialog(context);
                      });
                    }

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          child: SvgPicture.asset(
                              'assets/images/pink_ellipse.svg'),
                        ),
                        Positioned(
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(children: [
                              const TextSpan(
                                text: 'PERIOD IN\n',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: ACCENT,
                                ),
                              ),
                              TextSpan(
                                text: _formatPeriodDate(snapshot.data),
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _showConfirmationDialog(context);
                                  },
                              ),
                            ]),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          child: SvgPicture.asset(
                              'assets/images/pink_ellipse.svg'),
                        ),
                        const Positioned(
                          child: Text(
                            'Welcome \nto Ananya',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    );
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StreamBuilder<Map<String, dynamic>>(
                  stream: getAdvanceInfoStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    } else {
                      return AdvanceInfo(
                        data: snapshot.data!,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              StreamBuilder<Map<String, dynamic>>(
                stream: getCombinedStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else if (snapshot.hasData &&
                      snapshot.data!['periodData']!.isNotEmpty &&
                      snapshot.data!['cohortData']!.isNotEmpty) {
                    return PeriodCycleInformation(
                      data: snapshot.data!['periodData'],
                      cohort: snapshot.data!['cohortData'],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/period_cycle.svg',
                            width: 150,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/choose-user');
                            },
                            child: const Text('UNLOCK PERIOD PREDICTION'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              const Probahini(),
              const KnowledgeNexus(),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shop(),
                  SizedBox(width: 10),
                  Help(),
                  SizedBox(width: 10),
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
