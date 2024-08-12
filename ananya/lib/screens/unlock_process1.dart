import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/choice_item.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:flutter/material.dart';

class UnlockProcess1 extends StatelessWidget {
  const UnlockProcess1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithProgress(
        progressValue: 0.167,
        id: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Theme.of(context).largemainPadding,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Are your periods ',
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: 'regular',
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
              SizedBox(
                height: 10,
              ),
              Text(
                "Regular means that the gap between your periods is around the same number of days each month",
              ),
              SizedBox(
                height: 10,
              ),
              ChoiceItem(
                text: 'Yes',
              ),
              ChoiceItem(
                text: 'No',
              ),
              ChoiceItem(text: 'I don\'t Know')
            ],
          ),
        ),
      ),
    );
  }
}
