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
    notifyListeners();
  }

  void assignAnswer(List<ProblemObject> ans1, List<ProblemObject> ans2) {
    problemAnsList1 = ans1;
    problemAnsList2 = ans2;
    notifyListeners();
  }

  void assignProblem(List<ProblemObject> list, int round) {
    if (round == 1) {
      problemList1 = list;
    } else {
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
        // print('case 1');
        return false;
      }
      for (var item in problemList1) {
        // print(item.name);
        if (!nameAnsList1.contains(item.name)) {
          // print('case 2');
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
