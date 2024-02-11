import 'package:flutter/material.dart';
import 'package:frontend/models/diagnosisObject.dart';

class SelectedDiagnosis extends ChangeNotifier {
  List<DiagnosisObject> diagList = [];

  void assignList(List<DiagnosisObject> list) {
    diagList = list;
    notifyListeners();
  }

  void clearList() {
    diagList.clear();
    notifyListeners();
  }
}
