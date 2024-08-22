import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                          ? AppLocalizations.of(context)!.your_next_cycle_is_on
                          : AppLocalizations.of(context)!
                              .want_to_predict_when_your_next_period_will_happen,
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
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!
                        .check_out_our_curated_fertility_diet,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    'assets/images/hand_spoon.png',
                    width: 70,
                    fit: BoxFit.cover,
                  ),
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
                child: Text(
                  AppLocalizations.of(context)!.cycle_variations,
                  style: const TextStyle(
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
                        ? "${data['average_period_length']} ${AppLocalizations.of(context)!.days}"
                        : AppLocalizations.of(context)!
                            .unlocked_after_3rd_cycle_logged,
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
                child: Text(
                  AppLocalizations.of(context)!.average_cycle_interval,
                  style: const TextStyle(
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
                          ? "${data['average_period_cycle']} ${AppLocalizations.of(context)!.days}"
                          : AppLocalizations.of(context)!
                              .unlocked_after_3rd_cycle_logged,
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
