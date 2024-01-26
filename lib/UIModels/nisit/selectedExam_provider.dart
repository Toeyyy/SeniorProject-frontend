import 'package:flutter/material.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';

class SelectedExam extends ChangeNotifier {
  List<ExamPreDefinedObject> examList1 = [];
  List<ExamPreDefinedObject> examList2 = [];

  void addItem(ExamPreDefinedObject newItem, String round) {
    if (round == '1') {
      examList1.add(newItem);
    } else {
      examList2.add(newItem);
    }
    notifyListeners();
  }

  void clearList() {
    examList1.clear();
    examList2.clear();
  }
}
