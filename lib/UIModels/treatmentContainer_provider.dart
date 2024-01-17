import 'package:flutter/material.dart';
import 'package:frontend/components/treatmentContainer.dart';
import 'package:frontend/models/treatmentObject.dart';

class TreatmentContainerProvider extends ChangeNotifier {
  List<TreatmentContainer> treatmentContainerList = [];

  int nub = 0;

  void addContainer(TreatmentContainer newContainer) {
    treatmentContainerList.add(newContainer);
    nub += 1;
    notifyListeners();
  }

  void deleteContainer(Key key) {
    // print(treatmentContainerList.map((item) {
    //   return "item.key = ${item.key} and key = $key";
    // }).toList());
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
    for (TreatmentObject item in importedList) {
      addContainer(TreatmentContainer(
          id: item.id,
          key: ObjectKey(item.id),
          selectedTreatmentTopic: item.type,
          selectedTreatmentDetail: item.name));
    }
    // List<TreatmentContainer> tmp = importedList.map((item) {
    //   return TreatmentContainer(
    //       id: item.id,
    //       key: ObjectKey(item.id),
    //       selectedTreatmentTopic: item.type,
    //       selectedTreatmentDetail: item.name);
    // }).toList();
    //
    // treatmentContainerList = tmp;
  }
}
