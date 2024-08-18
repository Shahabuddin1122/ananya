import 'package:ananya/utils/constants.dart';
import 'package:ananya/widgets/calender.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeriodCycleInformation extends StatefulWidget {
  final Map<String, dynamic> data;
  const PeriodCycleInformation({required this.data, super.key});

  @override
  State<PeriodCycleInformation> createState() => _PeriodCycleInformationState();
}

class _PeriodCycleInformationState extends State<PeriodCycleInformation> {
  Map<String, dynamic> getData() {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');

    String startDate = widget.data['period_start_from'];
    String endDate = widget.data['period_start_to'];

    DateTime startDateTime = inputFormat.parse(startDate);
    DateTime endDateTime = inputFormat.parse(endDate);

    final int cycleLength = widget.data['days_between_period'];
    final int daysBetweenCycle = widget.data['length_of_period'];
    final DateTime ovulationDay =
        startDateTime.add(Duration(days: cycleLength ~/ 2));

    // Calculate ovulation days
    List<DateTime> ovulationDays = [
      ovulationDay.subtract(Duration(days: 1)),
      ovulationDay,
      ovulationDay.add(Duration(days: 1))
    ];

    // Calculate menstrual days
    List<DateTime> menstrualDays = [];
    for (int i = 0; i < daysBetweenCycle; i++) {
      menstrualDays.add(startDateTime.add(Duration(days: i)));
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

    print(periodData);
    return periodData;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> periodData = getData();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "PREDICTION OF NEXT CYCLE",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: ACCENT,
          ),
        ),
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
                    child: const Text(
                      'Menstrual Health Status',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                        const Icon(
                          Icons.arrow_upward,
                          size: 30,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.data['anomalies'],
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
                      const Text("Menstruation")
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
                      const Text("Ovulation")
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
            Navigator.pushNamed(context, '/unlock-process/4', arguments: true);
          },
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(SECONDARY_COLOR),
            minimumSize: WidgetStatePropertyAll(Size(double.infinity, 20)),
            shadowColor: WidgetStatePropertyAll(Colors.black),
          ),
          child: const Text(
            "LOG NEW PERIOD",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/unlock-process/1');
          },
          style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(ACCENT),
            minimumSize: WidgetStatePropertyAll(Size(double.infinity, 20)),
            shadowColor: WidgetStatePropertyAll(Colors.black),
          ),
          child: const Text(
            "RE-CALIBRATE PREDICTION",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
