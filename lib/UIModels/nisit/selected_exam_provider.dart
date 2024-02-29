import 'package:flutter/material.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/models/examResultObject.dart';
import 'package:frontend/components/resultContainer.dart';

class SelectedExam extends ChangeNotifier {
  List<ExamPreDefinedObject> examList1 = [];
  List<ExamPreDefinedObject> examList2 = [];

  List<ResultContainer> resultList1 = [];
  List<ResultContainer> resultList2 = [];

  void addNewExam(ExamPreDefinedObject newItem, int round) {
    if (round == 1) {
      newItem.round = 1;
      examList1.add(newItem);
    } else {
      newItem.round = 2;
      examList2.add(newItem);
    }
    notifyListeners();
  }

  void addNewResult(ResultContainer newItem, int round) {
    if (round == 1) {
      resultList1.add(newItem);
    } else {
      resultList2.add(newItem);
    }
    notifyListeners();
  }

  List<ResultContainer> getResultList(int round) {
    if (round == 1) {
      return resultList1;
    } else {
      return resultList2;
    }
  }

  void clearList() {
    examList1.clear();
    examList2.clear();
    resultList1.clear();
    resultList2.clear();
  }
}
