import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: Theme.of(context).largemainPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/gif/loading.gif',
              width: 400,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: Theme.of(context).largemainPadding,
              child: const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Calculating ',
                      style: TextStyle(
                        fontSize: 32,
                        color: ACCENT,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'your cycle prediction...',
                      style: TextStyle(
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
