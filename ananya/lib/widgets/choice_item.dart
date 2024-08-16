import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';

class ChoiceItem extends StatelessWidget {
  final String text;
  final ValueChanged<String>? onSelected;

  const ChoiceItem({
    required this.text,
    this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Theme.of(context).smallSubSectionDividerPadding,
      child: GestureDetector(
        onTap: () => onSelected!(text),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            left: 20,
            top: 15,
            bottom: 15,
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
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
