import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KnowledgeNexusComponent extends StatelessWidget {
  final Function(int)? onselect;
  const KnowledgeNexusComponent({this.onselect, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: Theme.of(context).insideCardPadding,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: SvgPicture.asset(
                'assets/images/knowledge_nexus.svg',
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.knowledge_nexus,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.get_to_know_your_body_better,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (onselect != null) {
                        onselect!(1);
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.go_to_nexus),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
