import 'package:flutter/material.dart';
import 'package:frontend/components/examContainer.dart';

class ExamContainerProvider extends ChangeNotifier {
  List<ExamContainer> examContainers1 = [];
  // List<ExamContainer> get examContainers1 => _examContainers1;
  List<ExamContainer> examContainers2 = [];
  // List<ExamContainer> get examContainers2 => _examContainers2;

  int nub = 0;

  void addExamContainer(
      ExamContainer newContainer, List<ExamContainer> containerList) {
    containerList.add(newContainer);
    nub += 1;
    notifyListeners();
  }

  void deleteExamContainer(
      int deleteIndex, List<ExamContainer> containerList, Key key) {
    // print('current delete index = $deleteIndex');
    containerList.removeWhere((item) => item.key == key);

    // for (int i = deleteIndex; i < containerList.length; i++) {
    //   // print('before, i = $i, index = ${_examContainers[i].index}');
    //   containerList[i].index = i;
    //   // print('after, i = $i, index = ${_examContainers[i].index}');
    // }
    // // nub -= 1;
    notifyListeners();
  }
}
