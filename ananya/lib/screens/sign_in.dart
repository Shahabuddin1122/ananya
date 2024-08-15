import 'dart:convert';

import 'package:ananya/utils/api_sattings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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

    Map<String, dynamic> data = {
      'phone': phoneController.text,
      'password': passwordController.text,
    };
    print(data);

    try {
      final response = await api.postMethod(json.encode(data));
      if (response.statusCode == 200) {
        print('Data posted successfully: $response');
        await prefs.setString('userNumber', phoneController.text);
        Navigator.pushNamed(context, '/');
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
        print('Response body: $response');
      }
    } catch (e) {
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
      backgroundColor: Color.fromARGB(255, 255, 235, 239),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: Theme.of(context).largemainPadding,
          // color: PRIMARY_COLOR.withOpacity(0.2),
          child: Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  width: 200,
                ),
                const Text(
                  textAlign: TextAlign.center,
                  "Login with your mobile number and password",
                  style: TextStyle(
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
                      text: "Phone Number",
                      controller: phoneController,
                    ),
                    CustomTextField(
                      text: 'Password',
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
                      child: const Text(
                        "Log in",
                        style: TextStyle(
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
                      child: const Text(
                        "Don't have an account? Create a new account.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Forget Password? Set a new password.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
