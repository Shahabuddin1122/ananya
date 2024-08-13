import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_drop_down.dart';
import 'package:ananya/widgets/custom_text_field.dart';
import 'package:ananya/widgets/input_box.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final List<String> district = [
    "Dhaka",
    "Khulna",
    "Sylhet",
  ];
  final List<String> projects = [
    "WaterAid",
    "Brac",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                    CustomTextField(text: "Name"),
                    CustomTextField(text: "Date of Birth"),
                    CustomTextField(text: "Phone Number"),
                    CustomTextField(text: "Email"),
                    CustomTextField(text: 'Password'),
                    CustomDropdown(
                      header: 'District',
                      options: district,
                    ),
                    CustomDropdown(
                      header: 'Project',
                      options: projects,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/unlock-process4');
                      },
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
                        "Create New Account",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Already have an account? Click here for login",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
