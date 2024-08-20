import 'dart:convert';

import 'package:ananya/utils/api_sattings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAUser extends StatefulWidget {
  const AddAUser({super.key});

  @override
  State<AddAUser> createState() => _AddAUserState();
}

class _AddAUserState extends State<AddAUser> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  void addUser() async {
    SharedPreferences prefs;
    try {
      prefs = await SharedPreferences.getInstance();
    } catch (e) {
      print('Failed to load SharedPreferences: $e');
      return;
    }
    if (usernameController.text.isEmpty) {
      _showErrorMessage("Username is required.");
      return;
    }
    if (phoneController.text.isEmpty) {
      _showErrorMessage("Phone Number is required.");
      return;
    }
    setState(() {
      isLoading = true;
    });
    String? id = prefs.getString('userId');
    ApiSettings api = ApiSettings(endPoint: 'user/add-user/$id');
    Map<String, dynamic> data = {
      "name": usernameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
    };
    try {
      final response = await api.postMethod(json.encode(data));
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 201) {
        json.decode(response.body);
        Navigator.pushNamed(context, '/');
      } else {
        print('Failed to post data. Status code: ${response.statusCode}');
        print('Response body: $response');
        final Map<String, dynamic> responseMap = jsonDecode(response.body);
        if (responseMap.containsKey('phone') &&
            responseMap['phone'] is List &&
            responseMap['phone'].isNotEmpty) {
          _showErrorMessage(responseMap['phone'][0]);
        } else if (responseMap.containsKey('email') &&
            responseMap['email'] is List &&
            responseMap['email'].isNotEmpty) {
          _showErrorMessage(responseMap['email'][0]);
        } else {
          _showErrorMessage(responseMap['error']);
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
      appBar: AppBar(
        title: const Text("Add a user"),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
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
                      const Text(
                        textAlign: TextAlign.center,
                        "Add a user",
                        style: TextStyle(
                          fontSize: 32,
                          color: ACCENT,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      CustomTextField(
                        text: "Username",
                        controller: usernameController,
                      ),
                      CustomTextField(
                        text: 'Phone Number',
                        controller: phoneController,
                      ),
                      CustomTextField(
                        text: 'Email',
                        controller: emailController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: addUser,
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
                          "Add",
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
