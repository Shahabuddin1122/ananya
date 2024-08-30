import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class KnowledgeItemProvider {
  static List<Map<String, String>> getKnowledgeItems(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return [
      {
        "id": "1",
        "question": localizations.question_1,
        "hero_image": "assets/images/menstruation.jpg",
        "first_description": localizations.first_description_1,
        "second_description": localizations.second_description_1,
        "third_description": localizations.third_description_1,
        "additional_image_1": "assets/images/femaleorgans.jpg",
        "video_id": "Vl2wRbO8LZU",
      },
      {
        "id": "2",
        "question": localizations.question_2,
        "hero_image": "assets/images/periodcycle1.jpg",
        "first_description": localizations.first_description_2,
        "second_description": localizations.second_description_2,
        "additional_image_1": "assets/images/menstruationcycle.PNG",
      },
      {
        "id": "3",
        "question": localizations.question_3,
        "hero_image": "assets/images/menssymp.jpg",
        "video_id": "oZEBjMBMV40",
        "first_description": localizations.first_description_3,
        "second_description": localizations.second_description_3,
        "third_description": localizations.third_description_3,
      },
      {
        "id": "4",
        "question": localizations.question_4,
        "hero_image": "assets/images/stagesofmens.jpg",
        "additional_image_1": "assets/images/stepsofmenscycle.png",
        "video_id": "spe_mto4gFk",
        "first_description": localizations.first_description_4,
        "second_description": localizations.second_description_4,
        "third_description": localizations.third_description_4,
      },
      {
        "id": "5",
        "question": localizations.question_5,
        "hero_image": "assets/images/abnormalmens.jpg",
        "video_id": "Barm4vAfM",
        "first_description": localizations.first_description_5,
        "additional_image_1": "assets/images/abnormalmens22.jpg",
        "second_description": localizations.second_description_5,
        "third_description": localizations.third_description_5,
      },
      {
        "id": "6",
        "question": localizations.question_6,
        "hero_image": "assets/images/missperiod.jpg",
        "first_description": localizations.first_description_6,
      },
      {
        "id": "7",
        "question": localizations.question_7,
        "hero_image": "assets/images/pmsimage.jpg",
        "first_description": localizations.first_description_7,
      },
      {
        "id": "8",
        "question": localizations.question_8,
        "hero_image": "assets/images/doctorsadvise.jpg",
        "first_description": localizations.first_description_8,
      },
      {
        "id": "9",
        "question": localizations.question_9,
        "hero_image": "assets/images/foodhabitttt.jpg",
        "first_description": localizations.first_description_9,
      },
      {
        "id": "10",
        "question": localizations.question_10,
        "hero_image": "assets/images/ironneed.jpg",
        "first_description": localizations.first_description_10,
      },
      {
        "id": "11",
        "question": localizations.question_11,
        "hero_image": "assets/images/img_image7.png",
        "video_id": "3Og40MfBlz8",
        "additional_image_1": "assets/images/mhmmeasures2.PNG",
        "first_description": localizations.first_description_11,
        "second_description": localizations.second_description_11,
        "third_description": localizations.third_description_11,
      },
      {
        "id": "12",
        "question": localizations.question_12,
        "hero_image": "assets/images/menstruationmisconception.jpg",
        "first_description": localizations.first_description_12,
      },
      {
        "id": "13",
        "question": localizations.question_13,
        "hero_image": "assets/images/thingsneeded.jpg",
        "first_description": localizations.first_description_13,
      },
      {
        "id": "14",
        "question": localizations.question_14,
        "hero_image": "assets/images/humanright.jpg",
        "first_description": localizations.first_description_14,
      },
      {
        "id": "15",
        "question": localizations.question_15,
        "hero_image": "assets/images/latepriod.jpg",
        "additional_image_1": "assets/images/missperiod2.jpg",
        "video_id": "kQD0Bou2yJQ",
        "first_description": localizations.first_description_15,
        "second_description": localizations.second_description_15,
        "third_description": localizations.third_description_15,
      },
      {
        "id": "16",
        "question": localizations.question_16,
        "hero_image": "assets/images/thingstoknowbeforefirstperiod.jpg",
        "additional_image_1": "assets/images/abnormalmens22.jpg",
        "first_description": localizations.first_description_16,
        "second_description": localizations.second_description_16,
      },
      {
        "id": "17",
        "question": localizations.question_17,
        "hero_image": "assets/images/firstperiod.jpg",
        "additional_image_1": "assets/images/firstperiod2.jpg",
        "video_id": "ImzxzlPzbRk",
        "first_description": localizations.first_description_17,
        "second_description": localizations.second_description_17,
        "third_description": localizations.third_description_17,
      },
      {
        "id": "18",
        "question": localizations.question_18,
        "hero_image": "assets/images/regularprep.jpg",
        "first_description": localizations.first_description_18,
      },
    ];
  }

  static List<Map<String, String>> getAdditionalInfo(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [
      {
        "id": "1",
        "question": localizations.question_1_1,
        "hero_image": "assets/images/img_image4.png",
        "first_description": localizations.first_description_1_1,
      },
      {
        "id": "2",
        "question": localizations.question_1_2,
        "hero_image": "assets/images/fertiledayspic.jpg",
        "video_id": "pnm7QiG1zW4",
        "first_description": localizations.first_description_1_2,
        "additional_image_1": "assets/images/knowwhenyouarefertile.PNG",
        "second_description": localizations.second_description_1_2,
        "third_description": localizations.third_description_1_2,
      },
      {
        "id": "3",
        "question": localizations.question_1_3,
        "hero_image": "assets/images/img_pngtreecartoo.png",
        "first_description": localizations.first_description_1_3,
      },
    ];
  }
}
