import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_app_bar_with_progress.dart';
import 'package:ananya/widgets/user_picture_name.dart';
import 'package:flutter/material.dart';

class ChooseUser extends StatelessWidget {
  const ChooseUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWithProgress(
        progressValue: 0.167,
        id: 2,
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
              SizedBox(
                height: 20,
              ),
              UserPictureName(
                name: 'Shahabuddin',
                image: 'assets/images/me.png',
              ),
              UserPictureName(
                name: 'Akhon',
                image: 'assets/images/default_person.png',
              ),
              UserPictureName(
                name: 'Shahabuddin',
                image: 'assets/images/me.png',
              ),
              UserPictureName(
                name: 'Akhon',
                image: 'assets/images/default_person.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
