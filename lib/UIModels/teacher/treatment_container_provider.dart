import 'package:flutter/material.dart';
import 'package:frontend/components/treatment_container.dart';
import 'package:frontend/models/treatment_object.dart';

class TreatmentContainerProvider extends ChangeNotifier {
  List<TreatmentContainer> treatmentContainerList = [];

  int nub = 0;

  void addContainer(TreatmentContainer newContainer) {
    treatmentContainerList.add(newContainer);
    nub += 1;
    notifyListeners();
  }

  void deleteContainer(Key key) {
    treatmentContainerList.removeWhere((item) => item.key == key);
    notifyListeners();
  }

  void clearList() {
    treatmentContainerList.clear();
    nub = 0;
    notifyListeners();
  }

  void getInfo(List<TreatmentObject> importedList) {
    clearList();
    if (importedList != []) {
      for (TreatmentObject item in importedList) {
        addContainer(TreatmentContainer(
            id: item.id,
            key: ObjectKey(item.id),
            selectedTreatmentTopic: item.type,
            selectedTreatmentDetail: item.name));
      }
    }
  }
}
