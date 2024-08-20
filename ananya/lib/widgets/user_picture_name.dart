import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPictureName extends StatelessWidget {
  final String name, image, id;
  const UserPictureName(
      {required this.id, required this.image, required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("cohort-user", id);
        Navigator.pushNamed(context, '/unlock-process/1');
      },
      child: Padding(
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
            Expanded(
              child: Text(
                name,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ACCENT,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
