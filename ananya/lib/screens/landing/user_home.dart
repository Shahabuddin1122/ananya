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
import 'package:shared_preferences/shared_preferences.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
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
    String? id = prefs.getString('userId');
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
    String? id = prefs.getString('userId');
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
      return '${daysUntilStart.abs() + 1} - ${daysUntilEnd.abs() + 1} \nDAYS';
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    bool isProcessing = false;

    showDialog(
      context: context,
      barrierDismissible: !isProcessing,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Stack(
              children: [
                AlertDialog(
                  title: const Text('Period Start Today'),
                  content:
                      const Text('Your period starts today. Please confirm.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: isProcessing
                          ? null
                          : () async {
                              setState(() {
                                isProcessing = true;
                              });

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? id = prefs.getString('userId');
                              Map<String, String> data = {
                                "period_date": DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now())
                              };
                              await ApiSettings(
                                      endPoint: 'user/confim-period/$id')
                                  .putMethod(json.encode(data));

                              setState(() {
                                isProcessing = false;
                              });

                              Navigator.of(context).pop();
                            },
                      child: const Text('Confirm'),
                    ),
                    TextButton(
                      onPressed: isProcessing
                          ? null
                          : () async {
                              setState(() {
                                isProcessing = true;
                              });

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? id = prefs.getString('userId');
                              await ApiSettings(
                                      endPoint:
                                          'user/update-period-information/$id')
                                  .getMethod();

                              setState(() {
                                isProcessing = false;
                              });

                              Navigator.of(context).pop();
                            },
                      child: const Text('Postpone'),
                    ),
                    TextButton(
                      onPressed: isProcessing
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      child: const Text('Discard'),
                    ),
                  ],
                ),
                if (isProcessing)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          },
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
                stream: getPeriodDataStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return PeriodCycleInformation(data: snapshot.data!);
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
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? id = prefs.getString('userId');

                              if (id == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('You need to log in first.'),
                                  ),
                                );
                              } else {
                                Navigator.pushNamed(
                                    context, '/unlock-process/1');
                              }
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
