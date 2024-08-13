import 'package:ananya/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DynamicCalender extends StatelessWidget {
  const DynamicCalender({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime focusedDay = DateTime.now();

    // Define the dates you want to mark
    final List<DateTime> redDates = [
      DateTime.utc(2024, 8, 14),
      DateTime.utc(2024, 8, 15),
      DateTime.utc(2024, 8, 16),
    ];

    final List<DateTime> greenDates = [
      DateTime.utc(2024, 8, 20),
      DateTime.utc(2024, 8, 21),
      DateTime.utc(2024, 8, 22),
    ];

    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: focusedDay,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          if (redDates.contains(day)) {
            return Container(
              decoration: const BoxDecoration(
                color: PRIMARY_COLOR,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              margin: const EdgeInsets.all(12.0),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (greenDates.contains(day)) {
            return Container(
              decoration: const BoxDecoration(
                color: SECONDARY_COLOR,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              margin: const EdgeInsets.all(12.0),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
