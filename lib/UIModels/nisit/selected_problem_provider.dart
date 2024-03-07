import 'package:flutter/material.dart';
import 'package:frontend/models/problemListObject.dart';

class SelectedProblem extends ChangeNotifier {
  List<ProblemObject> problemList1 = [];
  List<ProblemObject> problemList2 = [];
  List<ProblemObject> problemAnsList1 = [];
  List<ProblemObject> problemAnsList2 = [];
  int heart1 = 5;
  int heart2 = 5;

  void clearList() {
    problemList1.clear();
    problemList2.clear();
    problemAnsList1.clear();
    problemAnsList2.clear();
    heart1 = 5;
    heart2 = 5;
    notifyListeners();
  }

  void assignAnswer(List<ProblemObject> ans, int round) {
    if (round == 1) {
      problemAnsList1 = ans;
    } else {
      problemAnsList2 = ans;
    }
    notifyListeners();
  }

  void assignProblem(List<ProblemObject> list, int round) {
    if (round == 1) {
      list = list.map((e) {
        return ProblemObject(id: e.id, name: e.name, round: 1);
      }).toList();
      problemList1 = list;
    } else {
      list = list.map((e) {
        return ProblemObject(id: e.id, name: e.name, round: 2);
      }).toList();
      problemList2 = list;
    }
    notifyListeners();
  }

  void reduceHeart(int round) {
    if (round == 1) {
      heart1 -= 1;
    } else {
      heart2 -= 1;
    }
    notifyListeners();
  }

  bool checkProbAns(int round) {
    if (round == 1) {
      List<String> nameAnsList1 = problemAnsList1.map((e) => e.name).toList();
      if (problemList1.length != problemAnsList1.length) {
        return false;
      }
      for (var item in problemList1) {
        if (!nameAnsList1.contains(item.name)) {
          return false;
        }
      }
    } else {
      List<String> nameAnsList2 = problemAnsList2.map((e) => e.name).toList();
      if (problemList2.length != problemAnsList2.length) {
        return false;
      }
      for (var item in problemList2) {
        if (!nameAnsList2.contains(item.name)) {
          return false;
        }
      }
    }
    return true;
  }
}
