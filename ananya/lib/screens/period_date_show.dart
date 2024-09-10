import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PeriodDateShow extends StatefulWidget {
  final Map<String, dynamic> data;
  const PeriodDateShow({required this.data, super.key});

  @override
  State<PeriodDateShow> createState() => _PeriodDateShowState();
}

class _PeriodDateShowState extends State<PeriodDateShow> {
  late String periodDate = getData();
  @override
  void initState() {
    super.initState();
    periodDate = getData();
  }

  String getData() {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    DateFormat outputFormat = DateFormat('MMM d');

    String startDate = widget.data['period_start_from'];
    String endDate = widget.data['period_start_to'];

    String formattedStartDate =
        outputFormat.format(inputFormat.parse(startDate));
    String formattedEndDate = outputFormat.format(inputFormat.parse(endDate));

    if (startDate == endDate) {
      return formattedStartDate;
    } else {
      return "$formattedStartDate - $formattedEndDate";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: Theme.of(context).largemainPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/gif/bell.gif',
                  width: 400,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${AppLocalizations.of(context)!.your_next_period_will_start_around} \n',
                        style: const TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      TextSpan(
                        text: periodDate,
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: PRIMARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(ACCENT),
                minimumSize: WidgetStatePropertyAll(Size(double.infinity, 20)),
                shadowColor: WidgetStatePropertyAll(Colors.black),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                AppLocalizations.of(context)!.continues,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
