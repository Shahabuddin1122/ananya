import 'dart:convert';

import 'package:ananya/screens/loading.dart';
import 'package:ananya/utils/api_sattings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  ApiSettings api = ApiSettings(endPoint: 'user/login');

  void check() async {
    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {
      print('Failed to load SharedPreferences: $e');
      return;
    }
    if (passwordController.text.isEmpty) {
      _showErrorMessage("Password is required.");
      return;
    }
    if (phoneController.text.isEmpty) {
      _showErrorMessage("Phone Number is required.");
      return;
    }
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      'phone': phoneController.text,
      'password': passwordController.text,
    };

    try {
      final response = await api.postMethod(json.encode(data));
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final Map<String, dynamic> user = responseData['user'];
        await prefs.setString('userNumber', phoneController.text);
        await prefs.setString('userId', user['id'].toString());
        await prefs.setBool('is_superuser', user['is_superuser']);
        if (responseData['managed_users'].isNotEmpty) {
          await prefs.setString(
              "cohort-user", responseData['managed_users'][0].toString());
        }

        Navigator.pushNamed(context, '/');
      } else {
        _showErrorMessage("Invalid Credentials");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorMessage("Invalid Credentials");
      print('Error occurred: $e');
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 235, 239),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: Theme.of(context).largemainPadding,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        width: 200,
                      ),
                      Text(
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)!
                            .login_with_your_mobile_number_and_password,
                        style: const TextStyle(
                          fontSize: 32,
                          color: ACCENT,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      CustomTextField(
                        text: AppLocalizations.of(context)!.phone_number,
                        controller: phoneController,
                      ),
                      CustomTextField(
                        text: AppLocalizations.of(context)!.password,
                        controller: passwordController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: check,
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
                        child: Text(
                          AppLocalizations.of(context)!.log_in,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .dont_have_an_account_create_a_new_account,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.indigo,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .forget_password_set_a_new_password,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.indigo,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
