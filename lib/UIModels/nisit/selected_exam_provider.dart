import 'package:flutter/material.dart';
import 'package:frontend/models/examination_predefined_object.dart';
import 'package:frontend/components/result_container.dart';

class SelectedExam extends ChangeNotifier {
  List<ExamPreDefinedObject> examList = [];

  List<ResultContainer> resultList = [];

  void addNewExam(ExamPreDefinedObject newItem) {
    examList.add(newItem);
    notifyListeners();
  }

  void addNewResult(ResultContainer newItem) {
    resultList.add(newItem);
    notifyListeners();
  }

  List<ResultContainer> getResultList() {
    return resultList;
  }

  void clearList() {
    examList.clear();
    resultList.clear();
  }
}
