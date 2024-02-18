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
}
