import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';

class UserPictureName extends StatelessWidget {
  final String name, image;
  const UserPictureName({required this.image, required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Theme.of(context).smallSubSectionDividerPadding,
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              image,
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ACCENT,
            ),
          ),
        ],
      ),
    );
  }
}
