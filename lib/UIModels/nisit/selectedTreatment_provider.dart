import 'package:flutter/material.dart';
import 'package:frontend/models/treatmentObject.dart';

class SelectedTreatment extends ChangeNotifier {
  List<TreatmentObject> treatmentList = [];

  void addItem(TreatmentObject newItem) {
    treatmentList.add(newItem);
    notifyListeners();
  }

  void clearList() {
    treatmentList.clear();
  }
}
