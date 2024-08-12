import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';

class ChoiceItemWithRadioIcon extends StatelessWidget {
  final String text;

  const ChoiceItemWithRadioIcon({required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: Theme.of(context).smallSubSectionDividerPadding,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Radio(
              value: true,
              groupValue: true,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
