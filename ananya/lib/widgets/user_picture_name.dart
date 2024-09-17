import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserPictureName extends StatelessWidget {
  final String name, image, id;
  final bool grey, updateperiod;

  const UserPictureName(
      {required this.updateperiod,
      required this.grey,
      required this.id,
      required this.image,
      required this.name,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("cohort-user", id);
        if (!updateperiod) {
          Navigator.pushNamed(context, '/unlock-process/1');
        } else if (updateperiod) {
          Navigator.pushNamed(
            context,
            '/unlock-process/4',
            arguments: true,
          );
        }
      },
      child: Padding(
        padding: Theme.of(context).smallSubSectionDividerPadding,
        child: Row(
          children: [
            ClipOval(
              child: ImageFiltered(
                imageFilter: ColorFilter.mode(
                  grey ? Colors.grey : Colors.transparent,
                  grey ? BlendMode.saturation : BlendMode.dst,
                ),
                child: Image.asset(
                  image,
                  width: 45,
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: grey ? Colors.grey[400] : ACCENT,
                    ),
                  ),
                  grey
                      ? Text(
                          AppLocalizations.of(context)!
                              .user_period_logged_tracking_in_progress,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: grey ? Colors.grey[400] : ACCENT,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
