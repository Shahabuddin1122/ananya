import 'package:ananya/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomAppBarWithProgress extends StatelessWidget
    implements PreferredSizeWidget {
  final double progressValue;
  final int id;

  const CustomAppBarWithProgress(
      {Key? key, required this.id, required this.progressValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: ACCENT,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Container(),
          actions: [
            TextButton(
              onPressed: () {
                if (id == 3) {
                  Navigator.pushNamed(
                    context,
                    id + 1 == 7 ? '/' : '/unlock-process/${id + 1}',
                    arguments: false,
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    id + 1 == 7 ? '/' : '/unlock-process/${id + 1}',
                  );
                }
              },
              child: Text(
                AppLocalizations.of(context)!.skip,
                style: const TextStyle(
                  color: ACCENT,
                ),
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(ACCENT),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 4);
}
