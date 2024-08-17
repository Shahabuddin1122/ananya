import 'package:flutter/material.dart';

class PeriodState with ChangeNotifier {
  bool isPeriodRegular = true;
  int daysBetweenPeriod = 28;
  int lengthOfPeriod = 5;
  String lastPeriodStart = DateTime.now().toString();
  bool takeBirthControl = false;

  Map<String, bool> healthCondition = {
    "Yeast infection": false,
    "Urinary track infections": false,
    "Bacterial Vaginosis": false,
    "Polycystic Ovary Syndrome": false,
    "Endometriosis": false,
    "Fibroids": false,
    "I’m not sure": false,
    "No health issues": true,
  };

  void updatePeriodRegularity(bool value) {
    isPeriodRegular = value;
    notifyListeners();
  }

  void updateDaysBetweenPeriod(int value) {
    daysBetweenPeriod = value;
    notifyListeners();
  }

  void updateLengthOfPeriod(int value) {
    lengthOfPeriod = value;
    notifyListeners();
  }

  void updateLastPeriodStart(String value) {
    lastPeriodStart = value;
    notifyListeners();
  }

  void updateBirthControl(bool value) {
    takeBirthControl = value;
    notifyListeners();
  }

  void updateHealthCondition(String condition, bool value) {
    if (condition != 'No health issues' && value) {
      healthCondition['No health issues'] = false;
    }
    healthCondition[condition] = value;
    notifyListeners();
  }
}
