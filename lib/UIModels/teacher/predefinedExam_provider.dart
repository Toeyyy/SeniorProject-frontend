// import 'package:flutter/material.dart';
// import 'package:frontend/AllDataFile.dart';
// import 'package:frontend/models/examinationPreDefinedObject.dart';
// import 'package:collection/collection.dart';
//
// class PreDefinedExamProvider extends ChangeNotifier {
//   List<ExamPreDefinedObject> examList = examListPreDefined;
//
//   Map<String, List<ExamPreDefinedObject>> groupedByLab =
//       groupBy(examListPreDefined, (exam) => exam.lab);
//   Map<String, List<ExamPreDefinedObject>> currentLabList = {};
//   List<ExamPreDefinedObject> currentTypeList = [];
//   Map<String, Map<String, List<ExamPreDefinedObject>>> groupedByType = {};
//
//   void assignItem(List<ExamPreDefinedObject> itemList) {
//     examList = itemList;
//     ChangeNotifier();
//   }
//
//   Map<String, List<ExamPreDefinedObject>> getGroupByLab(String labName) {
//     currentLabList.clear();
//     currentLabList = groupBy(groupedByLab[labName]!, (e) => e.type);
//     print('current lab list = $currentLabList}');
//     return currentLabList;
//   }
//
//   void assignCurrentLabList(String labName) {
//     currentLabList.clear();
//     currentLabList = groupBy(groupedByLab[labName]!, (e) => e.type);
//     ChangeNotifier();
//   }
//
//   List<ExamPreDefinedObject> getGroupByType(String typeName) {
//     currentTypeList = currentLabList[typeName]!;
//     return currentTypeList;
//   }
//
//   void addNewItem(ExamPreDefinedObject newItem) {
//     examList.add(newItem);
//     groupedByLab[newItem.lab]!.add(newItem);
//     ChangeNotifier();
//   }
//
//   void deleteItem(ExamPreDefinedObject item) {
//     examList.remove(item);
//     groupedByLab[item.lab]!.remove(item);
//     ChangeNotifier();
//   }
//
//   void updateGroupedList(String labName) {
//     groupedByLab = groupBy(examList, (exam) => exam.lab);
//     currentLabList = groupBy(groupedByLab[labName]!, (e) => e.type);
//     ChangeNotifier();
//   }
//
//   void clearList() {
//     examList.clear();
//     // currentLabList.clear();
//     // groupedByLab.clear();
//     // groupedByType.clear();
//     // currentTypeList.clear();
//     ChangeNotifier();
//   }
// }
