import 'package:ananya/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  final List<DateTime> menstrual, ovulation;
  const Calender({required this.menstrual, required this.ovulation, super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(DateTime.now().year - 1, 1, 1),
      lastDay: DateTime.utc(DateTime.now().year + 1, 12, 31),
      focusedDay: focusedDay,
      onPageChanged: (newFocusedDay) {
        setState(() {
          focusedDay = newFocusedDay;
        });
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          DateTime normalizedDay = DateTime(day.year, day.month, day.day);

          if (widget.menstrual
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
          } else if (widget.ovulation
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
