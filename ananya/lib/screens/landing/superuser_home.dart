import 'dart:async';
import 'dart:convert';

import 'package:ananya/main.dart';
import 'package:ananya/utils/api_sattings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/advance_info.dart';
import 'package:ananya/widgets/help.dart';
import 'package:ananya/widgets/hospital_pharmacy.dart';
import 'package:ananya/widgets/knowledge_nexus_component.dart';
import 'package:ananya/widgets/period_cycle_information.dart';
import 'package:ananya/widgets/probahini.dart';
import 'package:ananya/widgets/shop.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SuperuserHome extends StatefulWidget {
  final Function(int) onselect;
  const SuperuserHome({required this.onselect, super.key});

  @override
  State<SuperuserHome> createState() => _SuperuserHomeState();
}

class _SuperuserHomeState extends State<SuperuserHome> {
  late StreamController<void> _updateStreamController;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _updateStreamController = StreamController<void>.broadcast();
    _initializePreferences();
    _startPolling();
  }

  Future<void> _initializePreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void _startPolling() {
    Timer.periodic(const Duration(seconds: 5), (_) async {
      final String? cohortUser = _prefs.getString('cohort-user');
      if (cohortUser != null) {
        _updateStreamController.add(null);
      }
    });
  }

  Stream<Map<String, dynamic>> _fetchData(
      String endpoint, bool superuser) async* {
    while (true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = superuser
          ? prefs.getString('cohort-user')
          : prefs.getString('userId');
      ApiSettings api = ApiSettings(endPoint: '$endpoint/$id');

      try {
        final response = await api.getMethod();
        if (response.statusCode == 200) {
          yield json.decode(response.body);
        } else {
          yield {};
        }
      } catch (e) {
        yield {};
      }

      await _updateStreamController.stream.firstWhere((_) => true);
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

    if (daysUntilStart < 8 && daysUntilStart >= 0) {
      _sendNotificationOncePerDay(daysUntilStart.abs() + 1);
    }

    if (startDate == endDate) {
      return "${daysUntilStart.abs() + 1} ";
    } else {
      return "${daysUntilStart.abs() + 1} - ${daysUntilEnd.abs() + 1} ";
    }
  }

  Future<void> _sendNotificationOncePerDay(int daysUntilStart) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastNotificationDate = prefs.getString('last_notification_date');
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    String? token = prefs.getString('token');
    if (token == null) {
      return;
    }

    if (lastNotificationDate != today) {
      var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'ananya',
        'your menstrual partner',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );
      var platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0,
        AppLocalizations.of(context)!.period_reminder,
        '${AppLocalizations.of(context)!.your_period_starts_in} $daysUntilStart ${AppLocalizations.of(context)!.days}',
        platformChannelSpecifics,
        payload: 'item x',
      );

      await prefs.setString('last_notification_date', today);
    }
  }

  Stream<Map<String, dynamic>> getCombinedStream() {
    return Rx.zip2(
      _fetchData('user/get-prediction-period', true),
      _fetchData('user/get-cohort-user', false),
      (periodData, cohortData) {
        return {
          'periodData': periodData,
          'cohortData': cohortData,
        };
      },
    );
  }

  @override
  void dispose() {
    _updateStreamController.close();
    super.dispose();
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
                  title: Text(AppLocalizations.of(context)!.period_start_today),
                  content: Text(AppLocalizations.of(context)!
                      .your_period_starts_today_please_confirm),
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
                              String? id = prefs.getString('cohort-user');
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
                      child: Text(AppLocalizations.of(context)!.confirm),
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
                              String? id = prefs.getString('cohort-user');
                              await ApiSettings(
                                      endPoint:
                                          'user/update-period-information/$id')
                                  .getMethod();

                              setState(() {
                                isProcessing = false;
                              });

                              Navigator.of(context).pop();
                            },
                      child: Text(AppLocalizations.of(context)!.postpone),
                    ),
                    TextButton(
                      onPressed: isProcessing
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      child: Text(AppLocalizations.of(context)!.discard),
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
                stream: _fetchData('user/get-prediction-period', true),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
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
                              TextSpan(
                                text: snapshot.data!['user']['name'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: ACCENT,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '\n${AppLocalizations.of(context)!.period_in}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: ACCENT,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${_formatPeriodDate(snapshot.data)} ${AppLocalizations.of(context)!.days}',
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
                        Positioned(
                          child: Text(
                            AppLocalizations.of(context)!.welcome_to_ananye,
                            style: const TextStyle(
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
                  stream: _fetchData('user/advance-period-information', true),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return AdvanceInfo(
                        data: snapshot.data!,
                      );
                    } else {
                      return Container();
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
                      issuperuser: true,
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
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String? id = prefs.getString('userId');
                              ApiSettings api =
                                  ApiSettings(endPoint: 'user/get-user/$id');
                              final response = await api.getMethod();

                              if (response.statusCode != 200) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .you_need_to_log_in_first),
                                  ),
                                );
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  '/choose-user',
                                  arguments: false,
                                );
                              }
                            },
                            child: Text(AppLocalizations.of(context)!
                                .unlock_period_prediction),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              const Probahini(),
              const KnowledgeNexusComponent(),
              const SizedBox(
                height: 10,
              ),
              HospitalPharmacyComponent(),
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
