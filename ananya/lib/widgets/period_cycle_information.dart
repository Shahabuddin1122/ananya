import 'package:ananya/l10n/dynamic_translation.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/widgets/calender.dart';
import 'package:ananya/widgets/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PeriodCycleInformation extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic>? cohort;
  final bool issuperuser;
  const PeriodCycleInformation(
      {required this.issuperuser, this.cohort, required this.data, super.key});

  @override
  State<PeriodCycleInformation> createState() => _PeriodCycleInformationState();
}

class _PeriodCycleInformationState extends State<PeriodCycleInformation> {
  String? selectedUserId;

  @override
  void initState() {
    super.initState();
    getSelectedUser().then((id) {
      setState(() {
        selectedUserId = id;
      });
    });
  }

  Future<String?> getSelectedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cohort-user');
  }

  void onSelectUser(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cohort-user', id);
    setState(() {
      selectedUserId = id;
    });
  }

  Map<String, dynamic> getData() {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');

    String startDate = widget.data['period_start_from'];
    String endDate = widget.data['period_start_to'];

    DateTime startDateTime = inputFormat.parse(startDate);
    DateTime endDateTime = inputFormat.parse(endDate);

    final int daysBetweenCycle = widget.data['days_between_period'];
    final int cycleLength = widget.data['length_of_period'];

    // Initialize lists for ovulation and menstrual days
    List<DateTime> ovulationDays = [];
    List<DateTime> menstrualDays = [];

    // Loop through three cycles to calculate days
    for (int j = 0; j < 3; j++) {
      DateTime currentCycleStartDate =
          startDateTime.add(Duration(days: j * daysBetweenCycle));
      DateTime ovulationDay =
          currentCycleStartDate.add(Duration(days: daysBetweenCycle ~/ 2));

      // Calculate ovulation days for this cycle
      ovulationDays.add(ovulationDay.subtract(const Duration(days: 1)));
      ovulationDays.add(ovulationDay);
      ovulationDays.add(ovulationDay.add(const Duration(days: 1)));

      // Calculate menstrual days for this cycle
      for (int i = 0; i < cycleLength; i++) {
        menstrualDays.add(currentCycleStartDate.add(Duration(days: i)));
      }
    }

    Map<String, dynamic> periodData = {
      'next_period_month': startDate == endDate
          ? DateFormat('MMM').format(startDateTime)
          : "${DateFormat('MMM').format(startDateTime)} - ${DateFormat('MMM').format(endDateTime)}",
      'next_period_day': startDate == endDate
          ? DateFormat('d').format(startDateTime)
          : "${DateFormat('d').format(startDateTime)} - ${DateFormat('d').format(endDateTime)}",
      'period_date_range': startDate == endDate
          ? DateFormat('MMM d').format(startDateTime)
          : "From ${DateFormat('MMM d').format(startDateTime)} to ${DateFormat('MMM d').format(endDateTime)}",
      'ovulation_days': ovulationDays,
      'menstrual_days': menstrualDays,
    };

    return periodData;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> periodData = getData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.prediction_of_next_cycle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: ACCENT,
          ),
        ),
        if (widget.cohort != null && widget.cohort!['predicted'] != null) ...[
          const SizedBox(height: 15),
          Wrap(
            direction: Axis.horizontal,
            spacing: 15,
            runSpacing: 15,
            children: widget.cohort!['predicted'].map<Widget>((user) {
              return CircleImage(
                image: 'assets/images/default_person.png',
                isHighlighted: user['id'].toString() == selectedUserId,
                id: user['id'].toString(),
                anomalies: widget.data['anomalies'],
                onSelect: onSelectUser,
              );
            }).toList(),
          ),
        ],
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: const BoxDecoration(
                      color: SECONDARY_COLOR,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      periodData['next_period_month'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      periodData['next_period_day'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: ACCENT,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: const BoxDecoration(
                      color: SECONDARY_COLOR,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.menstrual_health_status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          widget.data['anomalies'] == 'Regular'
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 30,
                          color: widget.data['anomalies'] == 'Regular'
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          translateAnnomalies(
                              context, widget.data['anomalies']),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: ACCENT,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: Column(
            children: [
              Calender(
                menstrual: periodData['menstrual_days'],
                ovulation: periodData['ovulation_days'],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: PRIMARY_COLOR,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(AppLocalizations.of(context)!.menstruation)
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: SECONDARY_COLOR,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(AppLocalizations.of(context)!.ovulation)
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.issuperuser) {
              Navigator.pushNamed(
                context,
                '/choose-user',
                arguments: true,
              );
            } else {
              Navigator.pushNamed(context, '/unlock-process/4',
                  arguments: true);
            }
          },
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(SECONDARY_COLOR),
            minimumSize: WidgetStatePropertyAll(Size(double.infinity, 20)),
            shadowColor: WidgetStatePropertyAll(Colors.black),
          ),
          child: Text(
            AppLocalizations.of(context)!.log_new_period,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.issuperuser) {
              Navigator.pushNamed(
                context,
                '/choose-user',
                arguments: false,
              );
            } else {
              Navigator.pushNamed(context, '/unlock-process/1',
                  arguments: true);
            }
          },
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(ACCENT),
            minimumSize: WidgetStatePropertyAll(Size(double.infinity, 20)),
            shadowColor: WidgetStatePropertyAll(Colors.black),
          ),
          child: Text(
            AppLocalizations.of(context)!.re_calibrate_prediction,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
