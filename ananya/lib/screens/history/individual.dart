import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/history_component.dart';
import 'package:flutter/material.dart';

class IndividualHistory extends StatelessWidget {
  const IndividualHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YOUR PERIOD HISTORY'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: Theme.of(context).largemainPadding,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "2022",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ACCENT,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 15.0,
                      runSpacing: 15.0,
                      children: [
                        HistoryComponent(
                          month: 'JUN',
                          day: '06',
                          monthcycle: '28',
                          anomalies: 1,
                        ),
                        HistoryComponent(
                          month: 'APR',
                          day: '01',
                          monthcycle: '29',
                          anomalies: 2,
                        ),
                        HistoryComponent(
                          month: 'MAR',
                          day: '03',
                          monthcycle: '29',
                          anomalies: 1,
                        ),
                        HistoryComponent(
                          month: 'FEB',
                          day: '03',
                          monthcycle: '28',
                          anomalies: 1,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "2021",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: ACCENT,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: [
                        HistoryComponent(
                          month: 'DEC',
                          day: '06',
                          monthcycle: '28',
                          anomalies: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: Theme.of(context).largemainPadding,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ACCENT,
                minimumSize: const Size(double.infinity, 50),
                shadowColor: Colors.black,
                side: const BorderSide(
                  width: 1,
                ),
              ),
              child: const Text(
                "Request Data Purge",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
