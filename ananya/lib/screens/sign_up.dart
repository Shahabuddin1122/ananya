import 'dart:convert';

import 'package:ananya/utils/api_sattings.dart';
import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_drop_down.dart';
import 'package:ananya/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

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

  bool isLoading = false;

  ApiSettings api = ApiSettings(endPoint: 'user/signup');

  final List<String> district = [
    "Dhaka",
    "Khulna",
    "Sylhet",
  ];
  final List<String> projects = [
    "WaterAid",
    "Brac",
  ];
  void check() async {
    if (nameController.text.isEmpty) {
      _showErrorMessage("Name is required.");
      return;
    }
    if (dobController.text.isEmpty) {
      _showErrorMessage("Date of Birth is required.");
      return;
    }
    if (phoneController.text.isEmpty) {
      _showErrorMessage("Phone Number is required.");
      return;
    }
    if (emailController.text.isEmpty) {
      _showErrorMessage("Email is required.");
      return;
    }
    if (passwordController.text.isEmpty) {
      _showErrorMessage("Password is required.");
      return;
    }
    if (selectedDistrict == null || selectedDistrict!.isEmpty) {
      _showErrorMessage("District is required.");
      return;
    }
    if (selectedProject == null || selectedProject!.isEmpty) {
      _showErrorMessage("Project is required.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      'name': nameController.text,
      'email': emailController.text,
      'date_of_birth': dobController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
      'district': selectedDistrict,
      'project': selectedProject,
      'is_superuser': false,
    };

    try {
      final response = await api.postMethod(json.encode(data));
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 201) {
        print('Data posted successfully: $response');
        Navigator.pushNamed(context, '/signin');
      } else {
        _showErrorMessage("Invalid Credentials");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorMessage("Invalid Credentials");
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
                        const Text(
                          textAlign: TextAlign.center,
                          "Create a new account",
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
                              text: "Name",
                              controller: nameController,
                            ),
                            CustomTextField(
                              text: "Date of Birth",
                              controller: dobController,
                            ),
                            CustomTextField(
                              text: "Phone Number",
                              controller: phoneController,
                            ),
                            CustomTextField(
                              text: "Email",
                              controller: emailController,
                            ),
                            CustomTextField(
                              text: 'Password',
                              controller: passwordController,
                            ),
                            CustomDropdown(
                              header: 'District',
                              options: district,
                              onChanged: (value) {
                                selectedDistrict = value;
                              },
                            ),
                            CustomDropdown(
                              header: 'Project',
                              options: projects,
                              onChanged: (value) {
                                selectedProject = value;
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
                              child: const Text(
                                "Create New Account",
                                style: TextStyle(
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
                              child: const Text(
                                "Already have an account? Click here for login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
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
