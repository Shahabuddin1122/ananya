import 'package:ananya/utils/constants.dart';
import 'package:ananya/widgets/calender.dart';
import 'package:ananya/widgets/dynamic_calender.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

class PeriodCycleInformation extends StatelessWidget {
  const PeriodCycleInformation({super.key});

  @override
  Widget build(BuildContext context) {
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
                    child: const Text(
                      'JUL',
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
                    child: const Text(
                      '26',
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          size: 30,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Healthy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
              const Calender(),
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
            Navigator.pushNamed(context, '/unlock-process/3');
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
            Navigator.pushNamed(context, '/unlock-process/3');
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
