import 'dart:convert';

import 'package:ananya/utils/api_sattings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/period_cycle_information.dart';
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
                String? id = prefs.getString('userId');
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
                  stream: getPeriodDataStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading data'));
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return Row(
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 65,
                                  padding: Theme.of(context).insideCardPadding,
                                  decoration: const BoxDecoration(
                                    color: PRIMARY_COLOR,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Your next \ncycle is on",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: Theme.of(context).insideCardPadding,
                                  child: const Text(
                                    "26 Jul",
                                    style: TextStyle(
                                      color: ACCENT,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 130,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Color(0xFF405070),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Check out our curated fertility diet',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Image.asset(
                                    'assets/images/hand_spoon.png',
                                    width: 70,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 65,
                                  padding: Theme.of(context).insideCardPadding,
                                  decoration: const BoxDecoration(
                                    color: SECONDARY_COLOR,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Cycle \nvariations",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: Theme.of(context).insideCardPadding,
                                  child: const Text(
                                    "Unlocked after 3rd cycle logged",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 160,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 65,
                                  padding: Theme.of(context).insideCardPadding,
                                  decoration: const BoxDecoration(
                                    color: PRIMARY_COLOR,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Average cycle interval",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        Theme.of(context).insideCardPadding,
                                    child: const Text(
                                      "Unlocked after calibrating period prediction",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Container(
                            width: 130,
                            height: 150,
                            padding: Theme.of(context).insideCardPadding,
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                            child: const Text(
                              'Want to predict when your next period will happen?',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 130,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Color(0xFF405070),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      'Check out our curated fertility diet',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Image.asset(
                                    'assets/images/hand_spoon.png',
                                    width: 70,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 65,
                                  padding: Theme.of(context).insideCardPadding,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Cycle \nvariations",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: Theme.of(context).insideCardPadding,
                                  child: const Text(
                                    "Unlocked after 3rd cycle logged",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: 160,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 65,
                                  padding: Theme.of(context).insideCardPadding,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    "Average cycle interval",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        Theme.of(context).insideCardPadding,
                                    child: const Text(
                                      "Unlocked after calibrating period prediction",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                            onPressed: () {
                              Navigator.pushNamed(context, '/unlock-process/1');
                            },
                            child: const Text('UNLOCK PERIOD PREDICTION'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: SvgPicture.asset(
                        'assets/images/Anannya Anim 1.svg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.08,
                      top: MediaQuery.of(context).size.height * 0.07,
                      child: const Text(
                        "Hi, I am Probahini,\nyour menstrual \ncompanion. Ask \nme anything...",
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).size.height * 0.05,
                      left: MediaQuery.of(context).size.width * 0.07,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('BEGIN CHAT'),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: Theme.of(context).insideCardPadding,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/images/knowledge_nexus.svg',
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "KNOWLEDGE \nNEXUS",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "GET TO KNOW YOUR \nBODY BETTER",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('GO TO NEXUS'),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: Theme.of(context).insideCardPadding,
                      decoration: const BoxDecoration(
                        color: Color(0xFF405070),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/Sanitary Pads 1.svg',
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'SHOP',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'FOR MENSTRUAL HEALTH PRODUCTS',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              'VIEW PRODUCT',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: Theme.of(context).insideCardPadding,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/hotline.png'),
                          const SizedBox(height: 10),
                          const Text(
                            'HELP',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'CALL EMERGENCY HELPLINE',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text(
                              'CALL NOW',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
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
