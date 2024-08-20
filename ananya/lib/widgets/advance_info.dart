import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdvanceInfo extends StatelessWidget {
  final Map<String, dynamic> data;
  const AdvanceInfo({required this.data, super.key});

  String getDate(date) {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    DateFormat outputFormat = DateFormat('MMM d');

    String formattedDate = outputFormat.format(inputFormat.parse(date));

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: Theme.of(context).insideCardPadding,
                  decoration: BoxDecoration(
                    color: data.isNotEmpty ? PRIMARY_COLOR : Colors.black,
                    borderRadius: BorderRadius.vertical(
                      top: const Radius.circular(10),
                      bottom: data.isEmpty
                          ? const Radius.circular(10)
                          : const Radius.circular(0),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      data.isNotEmpty
                          ? "Your next \ncycle is on"
                          : 'Want to predict when your next period will happen?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
              if (data.isNotEmpty) ...[
                Center(
                  child: Padding(
                    padding: Theme.of(context).insideCardPadding,
                    child: Text(
                      getDate(data["next_cycle"]),
                      style: const TextStyle(
                        color: ACCENT,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 130,
          height: 150,
          decoration: const BoxDecoration(
            color: Color(0xFF405070),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    'Check out our curated fertility diet',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Image.asset(
                  'assets/images/hand_spoon.png',
                  width: 70,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                height: 65,
                padding: Theme.of(context).insideCardPadding,
                decoration: BoxDecoration(
                  color: data.isNotEmpty ? SECONDARY_COLOR : Colors.black,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                child: const Text(
                  "Cycle \nvariations",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: Theme.of(context).insideCardPadding,
                  child: Text(
                    data.isNotEmpty
                        ? "${data['average_period_length']} days"
                        : "Unlocked after 3rd cycle logged",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: data.isNotEmpty ? 20 : 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Container(
          width: 160,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                height: 65,
                padding: Theme.of(context).insideCardPadding,
                decoration: BoxDecoration(
                  color: data.isNotEmpty ? PRIMARY_COLOR : Colors.black,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
                child: const Text(
                  "Average cycle interval",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: Theme.of(context).insideCardPadding,
                    child: Text(
                      data.isNotEmpty
                          ? "${data['average_period_length']} days"
                          : "Unlocked after 3rd cycle logged",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: data.isNotEmpty ? 20 : 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
