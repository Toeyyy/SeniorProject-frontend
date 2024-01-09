import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ListItem {
  String item;

  ListItem(this.item);
}

class ListTreatment extends ChangeNotifier {
  List<ListItem> list = [];

  void addItem(String txt) {
    list.add(ListItem(txt));
    notifyListeners();
  }
}
