import 'package:ananya/models/period_state_questionnaire.dart';
import 'package:ananya/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class DynamicCalendar extends StatefulWidget {
  const DynamicCalendar({super.key});

  @override
  State<DynamicCalendar> createState() => _DynamicCalendarState();
}

class _DynamicCalendarState extends State<DynamicCalendar> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime previourMonth = DateTime(now.year, now.month - 1, 1);

    return TableCalendar(
      firstDay: previourMonth,
      lastDay: now,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDay!);
        Provider.of<PeriodState>(context, listen: false)
            .updateLastPeriodStart(formattedDate);
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(),
        selectedDecoration: BoxDecoration(
          color: PRIMARY_COLOR,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(color: Colors.black),
        defaultTextStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}
