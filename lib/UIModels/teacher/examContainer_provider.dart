import 'package:flutter/material.dart';
import 'package:frontend/components/examContainer.dart';
import 'package:frontend/models/examinationObject.dart';

class ExamContainerProvider extends ChangeNotifier {
  List<ExamContainer> examContainers = [];

  int nub = 0;

  void addExamContainer(
      ExamContainer newContainer, List<ExamContainer> containerList) {
    containerList.add(newContainer);
    nub += 1;
    notifyListeners();
  }

  void deleteExamContainer(List<ExamContainer> containerList, Key key) {
    containerList.removeWhere((item) => item.key == key);
    notifyListeners();
  }

  void clearList() {
    examContainers.clear();
    nub = 0;
    notifyListeners();
  }

  void getInfo(List<ExaminationObject> importedList) {
    clearList();
    for (ExaminationObject item in importedList) {
      TextEditingController myController = TextEditingController();
      myController.text = item.textResult ?? '';
      examContainers.add(
        ExamContainer(
            id: item.id,
            key: ObjectKey(item.id),
            selectedDepartment: item.lab,
            selectedExamTopic: item.type,
            selectedExamName: item.name,
            selectedArea: item.area,
            areaNull: item.area == null,
            examController: myController,
            imagePath: item.imgPath,
            imageResult: item.imgResult,
            haveImage: item.imgResult == null),
      );
    }
  }
}
