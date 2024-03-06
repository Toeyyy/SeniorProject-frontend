import 'package:flutter/material.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/models/examResultObject.dart';
import 'package:frontend/components/resultContainer.dart';

class SelectedExam extends ChangeNotifier {
  List<ExamPreDefinedObject> examList = [];

  List<ResultContainer> resultList = [];

  void addNewExam(ExamPreDefinedObject newItem, int round) {
    examList.add(newItem);
    notifyListeners();
  }

  void addNewResult(ResultContainer newItem, int round) {
    resultList.add(newItem);
    notifyListeners();
  }

  List<ResultContainer> getResultList(int round) {
    return resultList;
  }

  void clearList() {
    examList.clear();
    resultList.clear();
  }
}
