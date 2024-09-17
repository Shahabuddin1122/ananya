import 'dart:convert';

import 'package:ananya/utils/api_sattings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_drop_down.dart';
import 'package:ananya/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedDistrict;
  String? selectedProject;
  String? selectUserType;
  List<String> district = [];
  List<String> projects = [];
  List<String> userTypes = [];

  bool isLoading = false;

  void check() async {
    if (nameController.text.isEmpty) {
      _showErrorMessage(
          '${AppLocalizations.of(context)!.name} ${AppLocalizations.of(context)!.is_required}');
      return;
    }
    if (dobController.text.isEmpty) {
      _showErrorMessage(
          '${AppLocalizations.of(context)!.date_of_birth} ${AppLocalizations.of(context)!.is_required}');
      return;
    }
    if (phoneController.text.isEmpty) {
      _showErrorMessage(
          '${AppLocalizations.of(context)!.phone_number} ${AppLocalizations.of(context)!.is_required}');
      return;
    }
    if (emailController.text.isEmpty) {
      _showErrorMessage(
          '${AppLocalizations.of(context)!.email} ${AppLocalizations.of(context)!.is_required}');
      return;
    }
    if (passwordController.text.isEmpty) {
      _showErrorMessage(
          '${AppLocalizations.of(context)!.password} ${AppLocalizations.of(context)!.is_required}');
      return;
    }
    if (selectedDistrict == null || selectedDistrict!.isEmpty) {
      _showErrorMessage(
          '${AppLocalizations.of(context)!.district} ${AppLocalizations.of(context)!.is_required}');
      return;
    }
    if (selectedProject == null || selectedProject!.isEmpty) {
      _showErrorMessage(
          '${AppLocalizations.of(context)!.project} ${AppLocalizations.of(context)!.is_required}');
      return;
    }
    if (selectUserType == null || selectUserType!.isEmpty) {
      _showErrorMessage(
          '${AppLocalizations.of(context)!.user_type} ${AppLocalizations.of(context)!.is_required}');
      return;
    }

    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> data;
    ApiSettings api;
    if (selectUserType == 'superuser' || selectUserType == 'দল') {
      api = ApiSettings(endPoint: 'user/superuser/signup');
      data = {
        "user": {
          'name': nameController.text,
          'email': emailController.text,
          'date_of_birth': dobController.text,
          'phone': phoneController.text,
          'password': passwordController.text,
          'district': selectedDistrict,
          'project': selectedProject,
          'is_superuser': true,
        },
        "managed_users": []
      };
    } else {
      api = ApiSettings(endPoint: 'user/signup');
      data = {
        'name': nameController.text,
        'email': emailController.text,
        'date_of_birth': dobController.text,
        'phone': phoneController.text,
        'password': passwordController.text,
        'district': selectedDistrict,
        'project': selectedProject,
        'is_superuser': false,
      };
    }

    try {
      final response = await api.postMethodWithoutToken(json.encode(data));
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.account_created_successfully),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushNamed(context, '/signin');
      } else {
        final Map<String, dynamic> responseData = json.decode(response.body);
        _showErrorMessage(responseData['error']);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorMessage(AppLocalizations.of(context)!.invalid_credentials);
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.error),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    district = [
      AppLocalizations.of(context)!.dhaka,
      AppLocalizations.of(context)!.khulna,
      AppLocalizations.of(context)!.sylhet,
    ];
    projects = [
      AppLocalizations.of(context)!.sts_project,
      AppLocalizations.of(context)!.others,
    ];
    userTypes = [
      AppLocalizations.of(context)!.user,
      AppLocalizations.of(context)!.superuser,
    ];
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: Theme.of(context).largemainPadding,
                  decoration: BoxDecoration(
                    color: PRIMARY_COLOR.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          width: 200,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          AppLocalizations.of(context)!.create_a_new_account,
                          style: const TextStyle(
                            fontSize: 32,
                            color: ACCENT,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Column(
                          children: [
                            CustomTextField(
                              text: AppLocalizations.of(context)!.name,
                              controller: nameController,
                            ),
                            CustomTextField(
                              text: AppLocalizations.of(context)!.date_of_birth,
                              controller: dobController,
                            ),
                            CustomTextField(
                              text: AppLocalizations.of(context)!.phone_number,
                              controller: phoneController,
                            ),
                            CustomTextField(
                              text: AppLocalizations.of(context)!.email,
                              controller: emailController,
                            ),
                            CustomTextField(
                              text: AppLocalizations.of(context)!.password,
                              controller: passwordController,
                            ),
                            CustomDropdown(
                              header: AppLocalizations.of(context)!.district,
                              options: district,
                              onChanged: (value) {
                                selectedDistrict = value;
                              },
                            ),
                            CustomDropdown(
                              header: AppLocalizations.of(context)!.project,
                              options: projects,
                              onChanged: (value) {
                                selectedProject = value;
                              },
                            ),
                            CustomDropdown(
                              header: AppLocalizations.of(context)!.user_type,
                              options: userTypes,
                              onChanged: (value) {
                                selectUserType = value;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: check,
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(ACCENT),
                                minimumSize: WidgetStatePropertyAll(
                                    Size(double.infinity, 20)),
                                shadowColor:
                                    WidgetStatePropertyAll(Colors.black),
                                side: WidgetStatePropertyAll(
                                  BorderSide(
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .create_a_new_account,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/signin');
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .already_have_an_account_click_here_for_login,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
