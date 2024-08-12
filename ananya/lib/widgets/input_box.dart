import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  final String text;
  const InputBox({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Theme.of(context).smallSubSectionDividerPadding,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: TextStyle(
                color: Colors.grey[200],
              ),
              decoration: InputDecoration(
                hintText: text,
                border: InputBorder.none,
              ),
            )
          ],
        ),
      ),
    );
  }
}
