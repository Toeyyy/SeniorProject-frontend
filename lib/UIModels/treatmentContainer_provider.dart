import 'package:flutter/material.dart';
import 'package:frontend/components/treatmentContainer.dart';

class TreatmentContainerProvider extends ChangeNotifier {
  List<TreatmentContainer> treatmentContainerList = [];

  int nub = 0;

  void addContainer(TreatmentContainer newContainer) {
    treatmentContainerList.add(newContainer);
    nub += 1;
    notifyListeners();
  }

  void deleteContainer(int deleteIndex, Key key) {
    treatmentContainerList.removeWhere((item) => item.key == key);
    notifyListeners();
  }
}
