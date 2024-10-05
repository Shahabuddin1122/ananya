import 'dart:convert';

import 'package:ananya/utils/api_settings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:ananya/widgets/user_picture_name.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseUser extends StatelessWidget {
  final bool updateperiod;
  const ChooseUser({required this.updateperiod, super.key});

  Stream<Map<String, dynamic>> getCohort() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('userId');
    ApiSettings api = ApiSettings(endPoint: 'user/get-cohort-user/$id');

    try {
      final response = await api.getMethod();

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        yield responseData;
      } else {
        yield {};
      }
    } catch (e) {
      yield {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithProgress(
        progressValue: 0.1,
        id: 2,
      ),
      body: Padding(
        padding: Theme.of(context).largemainPadding,
        child: StreamBuilder<Map<String, dynamic>>(
          stream: getCohort(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Image.asset(
                  'assets/gif/loading.gif',
                  height: 400,
                  fit: BoxFit.contain,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                  child:
                      Text(AppLocalizations.of(context)!.error_loading_data));
            } else if (snapshot.hasData &&
                snapshot.data!.isNotEmpty &&
                (snapshot.data!['predicted'].isNotEmpty ||
                    snapshot.data!['not_predicted'].isNotEmpty)) {
              final data = snapshot.data!;
              final predictedUsers = data['predicted'] ?? [];
              final notPredictedUsers = data['not_predicted'] ?? [];

              if (predictedUsers.isEmpty && notPredictedUsers.isEmpty) {
                return Center(
                  child: Text(AppLocalizations.of(context)!.no_users_found),
                );
              }

              return ListView(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .which_user_do_you_want_to,
                          style: TextStyle(
                            fontSize: 32,
                          ),
                        ),
                        TextSpan(
                          text: AppLocalizations.of(context)!.log_period_of,
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
                  const SizedBox(height: 20),
                  ...predictedUsers.map((user) {
                    return UserPictureName(
                      image: 'assets/images/default_person.png',
                      name: user['name'],
                      id: user['id'].toString(),
                      grey: false,
                      updateperiod: updateperiod,
                    );
                  }).toList(),
                  ...notPredictedUsers.map((user) {
                    return UserPictureName(
                      image: 'assets/images/default_person.png',
                      name: user['name'],
                      id: user['id'].toString(),
                      grey: updateperiod ? true : false,
                      updateperiod: updateperiod,
                    );
                  }).toList(),
                ],
              );
            } else {
              return Center(
                  child: Text(AppLocalizations.of(context)!.no_data_available));
            }
          },
        ),
      ),
    );
  }
}
