import 'dart:convert';

import 'package:ananya/utils/api_sattings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:ananya/widgets/user_picture_name.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseUser extends StatelessWidget {
  const ChooseUser({super.key});

  Stream<Map<String, dynamic>> getCohort() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('userId');
    ApiSettings api = ApiSettings(endPoint: 'user/get-cohort/$id');

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
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              List<dynamic> managedUsers = snapshot.data!['managed_users'];
              return ListView(
                children: [
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Which user do you want to ',
                          style: TextStyle(
                            fontSize: 32,
                          ),
                        ),
                        TextSpan(
                          text: 'log period of',
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
                  ...managedUsers.map((user) {
                    return UserPictureName(
                      image: 'assets/images/default_person.png',
                      name: user['name'],
                      id: user['id'].toString(),
                    );
                  }).toList(),
                ],
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
