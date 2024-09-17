import 'dart:convert';

import 'package:ananya/utils/api_sattings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void changePassword() async {
    if (passwordController.text.isEmpty) {
      _showErrorMessage(
          '${AppLocalizations.of(context)!.password} ${AppLocalizations.of(context)!.is_required}');
      return;
    }
    if (phoneController.text.isEmpty) {
      _showErrorMessage(
          '${AppLocalizations.of(context)!.phone_number} ${AppLocalizations.of(context)!.is_required}');
      return;
    }
    setState(() {
      isLoading = true;
    });

    Map<String, String> data = {
      "number": phoneController.text,
      "password": passwordController.text,
    };
    ApiSettings api = ApiSettings(endPoint: 'user/forget-password');
    try {
      final response = await api.postMethodWithoutToken(json.encode(data));
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        print("Successfully changed the password");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.password_changed_successfully),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushNamed('/signin');
      } else {
        print("Error to change the password");
        _showErrorMessage(AppLocalizations.of(context)!.invalid_credentials);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      return;
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.ok),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.error),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 235, 239),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.forget_password),
      ),
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
                            .reset_your_account_password,
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
                        text: AppLocalizations.of(context)!.new_password,
                        controller: passwordController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: changePassword,
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
                          AppLocalizations.of(context)!.change,
                          style: const TextStyle(
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
