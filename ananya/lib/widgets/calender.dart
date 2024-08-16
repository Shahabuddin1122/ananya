import 'package:ananya/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatelessWidget {
  final List<DateTime> menstrual, ovulation;
  const Calender({required this.menstrual, required this.ovulation, super.key});

  @override
  Widget build(BuildContext context) {
    DateTime focusedDay = DateTime.now();

    return TableCalendar(
      firstDay: DateTime.utc(2020, 10, 16),
      lastDay: DateTime.utc(2025, 3, 14),
      focusedDay: focusedDay,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      // calendarStyle: const CalendarStyle(
      //   todayDecoration: BoxDecoration(),
      //   todayTextStyle: TextStyle(color: Colors.black),
      //   defaultTextStyle: TextStyle(color: Colors.black),
      // ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          DateTime normalizedDay = DateTime(day.year, day.month, day.day);

          if (menstrual
              .any((d) => DateTime(d.year, d.month, d.day) == normalizedDay)) {
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
          } else if (ovulation
              .any((d) => DateTime(d.year, d.month, d.day) == normalizedDay)) {
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
