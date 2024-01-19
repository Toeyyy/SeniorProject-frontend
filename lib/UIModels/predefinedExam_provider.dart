import 'package:flutter/material.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:collection/collection.dart';

class PreDefinedExamProvider extends ChangeNotifier {
  List<ExamPreDefinedObject> examList = [];

  late Map<String, List<ExamPreDefinedObject>> groupedByLab =
      groupBy(examList, (exam) => exam.lab);
  Map<String, List<ExamPreDefinedObject>> currentLabList = {};
  List<ExamPreDefinedObject> currentTypeList = [];
  late Map<String, Map<String, List<ExamPreDefinedObject>>> groupedByType;

  void assignItem(List<ExamPreDefinedObject> itemList) {
    examList.addAll(itemList);
    ChangeNotifier();
  }

  Map<String, List<ExamPreDefinedObject>> getGroupByLab(String labName) {
    currentLabList.clear();
    currentLabList = groupBy(groupedByLab[labName]!, (e) => e.type);
    return currentLabList;
  }

  void assignCurrentLabList(String labName) {
    currentLabList.clear();
    currentLabList = groupBy(groupedByLab[labName]!, (e) => e.type);
    ChangeNotifier();
  }

  List<ExamPreDefinedObject> getGroupByType(String typeName) {
    currentTypeList = currentLabList[typeName]!;
    return currentTypeList;
  }

  void assignCurrentTypeList(String typeName) {
    currentTypeList = currentLabList[typeName]!;
    ChangeNotifier();
  }

  void addNewItem(ExamPreDefinedObject newItem) {
    examList.add(newItem);
    groupedByLab[newItem.lab]!.add(newItem);
    ChangeNotifier();
  }

  void deleteItem(ExamPreDefinedObject item) {
    examList.remove(item);
    groupedByLab[item.lab]!.remove(item);
    ChangeNotifier();
  }

  void updateItem(String id, List<String> newItemList, String labName) {
    ExamPreDefinedObject item1 = examList.where((e) => e.id == id).first;
    item1.name = newItemList[0];
    item1.cost = int.parse(newItemList[1]);
    ExamPreDefinedObject item2 =
        groupedByLab[labName]!.where((e) => e.id == id).first;
    item2.name = newItemList[0];
    item2.cost = int.parse(newItemList[1]);
  }
}
