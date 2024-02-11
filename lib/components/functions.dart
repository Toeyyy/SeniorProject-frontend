import 'package:flutter/material.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:collection/collection.dart';
import 'package:frontend/AllDataFile.dart';

List<ProblemObject> filterProblemList(
    TextEditingController searchController, List<ProblemObject> listForSearch) {
  // String query = searchController.text.toLowerCase();
  // if (query == '') {
  //   return listForSearch;
  // } else {
  //   return listForSearch
  //       .where((item) => item.name.toLowerCase().startsWith(query))
  //       .toList();
  // }

  String query = searchController.text.toLowerCase();
  return listForSearch
      .where((item) => item.name.toLowerCase().startsWith(query))
      .toList();
}

List<DiagnosisObject> filterDiagnosisList(
    TextEditingController searchController,
    List<DiagnosisObject> listForSearch) {
  String query = searchController.text.toLowerCase();
  return listForSearch
      .where((item) => item.name.toLowerCase().startsWith(query))
      .toList();
}

// List<String> filterBreed(String animal) {
//   if (animal == 'สุนัข') {
//     return Signalment_dogBreedList;
//   } else if (animal == 'แมว') {
//     return Signalment_catBreedList;
//   } else {
//     return Signalment_birdBreedList;
//   }
// }

List<String> filterTreatment(String topic) {
  // Map<String,List<TreatmentObject>> splitTreatment = groupBy(preDefinedTreatmentAll, (e) => e.type);
  // return splitTreatment[topic]!.map((e) => e.name).toList();

  Map<String, List<TreatmentObject>> splitTreatment =
      groupBy(treatmentListPreDefined, (e) => e.type);
  return splitTreatment[topic]!.map((e) => e.name).toList();
}

List<String> getTreatmentTopic() {
  // return groupBy(preDefinedTreatmentAll, (e) => e.type).keys.toList();
  return groupBy(treatmentListPreDefined, (e) => e.type).keys.toList();
}

/////predefined//////

List<dynamic> filterEditTopicList(String value) {
  if (value == 'Problem List') {
    // return preDefinedProblem;
    return problemListPreDefined;
  } else {
    // value == 'Diagnosis List'
    // return preDefinedDiagnosis;
    return diagnosisListPreDefined;
  }
}

List<dynamic> filterList(
    TextEditingController searchController, List<dynamic> listForSearch) {
  String query = searchController.text.toLowerCase();
  return listForSearch
      .where((item) => item.name.toLowerCase().startsWith(query))
      .toList();
}
