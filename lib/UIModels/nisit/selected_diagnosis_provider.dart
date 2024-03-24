import 'package:flutter/material.dart';
import 'package:frontend/models/diagnosis_object.dart';

class SelectedDiagnosis extends ChangeNotifier {
  List<DiagnosisObject> diffDiagList = [];
  List<DiagnosisObject> tenDiagList = [];

  void assignList(List<DiagnosisObject> list, String type) {
    if (type == 'diff') {
      diffDiagList = list;
    } else {
      tenDiagList = list;
    }
    notifyListeners();
  }

  void clearList() {
    diffDiagList.clear();
    tenDiagList.clear();
    notifyListeners();
  }
}
