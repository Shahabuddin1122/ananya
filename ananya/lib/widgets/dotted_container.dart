import 'package:flutter/material.dart';

class DottedContainer extends StatelessWidget {
  const DottedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 20,
        alignment: WrapAlignment.center,
        children: List.generate(
          10,
          (index) => Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
