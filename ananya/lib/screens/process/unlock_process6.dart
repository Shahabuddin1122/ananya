import 'dart:convert';

import 'package:ananya/models/period_state_questionnaire.dart';
import 'package:ananya/screens/loading.dart';
import 'package:ananya/utils/api_sattings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/choice_item_with_radio_icon.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnlockProcess6 extends StatefulWidget {
  final bool update_period;
  const UnlockProcess6({required this.update_period, super.key});

  @override
  State<UnlockProcess6> createState() => _UnlockProcess6State();
}

class _UnlockProcess6State extends State<UnlockProcess6> {
  bool isLoading = false;
  void predictPeriod(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String URL =
        widget.update_period ? 'user/log-new-period/' : 'user/add-period-info/';
    String? id = prefs.getString('userId');
    ApiSettings api = ApiSettings(endPoint: '$URL$id');
    final periodState = context.read<PeriodState>();
    Map<String, dynamic> data = {
      "is_period_regular": periodState.isPeriodRegular,
      "days_between_period": periodState.daysBetweenPeriod,
      "length_of_period": periodState.lengthOfPeriod,
      "last_period_start": periodState.lastPeriodStart,
      "take_birth_control": periodState.takeBirthControl,
      "health_condition": {
        "yeast_infection": periodState.healthCondition["Yeast infection"],
        "urinary_track_infections":
            periodState.healthCondition["Urinary track infections"],
        "bacterial_vaginosis":
            periodState.healthCondition["Bacterial Vaginosis"],
        "polycystic_ovary_syndrome":
            periodState.healthCondition["Polycystic Ovary Syndrome"],
        "endometriosis": periodState.healthCondition["Endometriosis"],
        "fibroids": periodState.healthCondition["Fibroids"],
        "i_am_not_sure": periodState.healthCondition["I’m not sure"],
        "no_health_issue": periodState.healthCondition["No health issues"]
      }
    };

    try {
      Response response;
      if (widget.update_period) {
        response = await api.putMethod(json.encode(data));
      } else {
        response = await api.postMethod(json.encode(data));
      }
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Data posted successfully: ${responseData}');
        Navigator.pushNamed(
          context,
          '/period-date',
          arguments: responseData,
        );
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
        print('Response body: $response');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isLoading
          ? AppBar()
          : const CustomAppBarWithProgress(
              progressValue: 1,
              id: 6,
            ),
      body: Center(
        child: isLoading
            ? const Loading()
            : SingleChildScrollView(
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
                      const ChoiceItemWithRadioIcon(
                          text: 'Urinary track infections'),
                      const ChoiceItemWithRadioIcon(
                          text: 'Bacterial Vaginosis'),
                      const ChoiceItemWithRadioIcon(
                          text: 'Polycystic Ovary Syndrome'),
                      const ChoiceItemWithRadioIcon(text: 'Endometriosis'),
                      const ChoiceItemWithRadioIcon(text: 'Fibroids'),
                      const ChoiceItemWithRadioIcon(text: 'I’m not sure'),
                      const ChoiceItemWithRadioIcon(text: 'No health issues'),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () => predictPeriod(context),
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
      ),
    );
  }
}
