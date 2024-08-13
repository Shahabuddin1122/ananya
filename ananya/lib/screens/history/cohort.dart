import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/circle_image.dart';
import 'package:ananya/widgets/history_component.dart';
import 'package:flutter/material.dart';

class CohortHistory extends StatefulWidget {
  const CohortHistory({super.key});

  @override
  State<CohortHistory> createState() => _CohortHistoryState();
}

class _CohortHistoryState extends State<CohortHistory> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COHORT PERIOD HISTORY'),
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
                    Wrap(
                      direction: Axis.horizontal,
                      spacing: 15,
                      runSpacing: 10,
                      children: [
                        CircleImage(
                          image: "assets/images/me.png",
                        ),
                        CircleImage(
                          image: "assets/images/default_person.png",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
    );
  }
}
