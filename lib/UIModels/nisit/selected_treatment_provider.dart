import 'package:flutter/material.dart';
import 'package:frontend/models/treatmentObject.dart';

class SelectedTreatment extends ChangeNotifier {
  List<TreatmentObject> treatmentList = [];
  int totalCost = 0;

  void addItem(TreatmentObject newItem) {
    treatmentList.add(newItem);
    totalCost += newItem.cost;
    notifyListeners();
  }

  void clearList() {
    treatmentList.clear();
    notifyListeners();
  }
}
