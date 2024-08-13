import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:ananya/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
                    const CustomTextField(text: "Phone Number"),
                    const CustomTextField(text: 'Password'),
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
                        "Log in",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Don't have an account? Create a new account.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
