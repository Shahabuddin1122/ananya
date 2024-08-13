import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/choice_item.dart';
import 'package:ananya/widgets/choice_item_with_radio_icon.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:flutter/material.dart';

class UnlockProcess6 extends StatelessWidget {
  const UnlockProcess6({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithProgress(
        progressValue: 1,
        id: 6,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Theme.of(context).largemainPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Do you have any of these ',
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: 'health conditions',
                      style: TextStyle(
                        fontSize: 32,
                        color: PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '?',
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Choose all that apply.",
              ),
              const SizedBox(
                height: 10,
              ),
              const ChoiceItemWithRadioIcon(text: 'Yeast infection'),
              const ChoiceItemWithRadioIcon(text: 'Urinary track infections'),
              const ChoiceItemWithRadioIcon(text: 'Bacterial Vaginosis'),
              const ChoiceItemWithRadioIcon(text: 'Polycystic Ovary Syndrome'),
              const ChoiceItemWithRadioIcon(text: 'Endometriosis'),
              const ChoiceItemWithRadioIcon(text: 'Fibroids'),
              const ChoiceItemWithRadioIcon(text: 'I’m not sure'),
              const ChoiceItemWithRadioIcon(text: 'No health issues'),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/period-date');
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(ACCENT),
                  minimumSize:
                      WidgetStatePropertyAll(Size(double.infinity, 20)),
                  shadowColor: WidgetStatePropertyAll(Colors.black),
                  side: WidgetStatePropertyAll(
                    BorderSide(
                      width: 1,
                    ),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
