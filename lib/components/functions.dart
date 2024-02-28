import 'package:flutter/material.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:collection/collection.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/models/tagObject.dart';

List<ProblemObject> filterProblemList(
    TextEditingController searchController, List<ProblemObject> listForSearch) {
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

List<String> filterTreatment(String topic) {
  Map<String, List<TreatmentObject>> splitTreatment =
      groupBy(treatmentListPreDefined, (e) => e.type);
  if (topic == 'first') {
    return splitTreatment.values.first.map((e) => e.name).toList();
  }
  return splitTreatment[topic]!.map((e) => e.name).toList();
}

List<String> getTreatmentTopic() {
  return groupBy(treatmentListPreDefined, (e) => e.type).keys.toList();
}

/////predefined//////

List<dynamic> filterEditTopicList(String value) {
  if (value == 'Problem List') {
    return problemListPreDefined;
  } else if (value == 'Diagnosis List') {
    return diagnosisListPreDefined;
  } else {
    return tagListPreDefined;
  }
}

List<dynamic> filterList(
    TextEditingController searchController, List<dynamic> listForSearch) {
  String query = searchController.text.toLowerCase();
  return listForSearch
      .where((item) => item.name.toLowerCase().startsWith(query))
      .toList();
}

List<String> filterStringList(
    TextEditingController searchController, List<String> listForSearch) {
  String query = searchController.text.toLowerCase();
  return listForSearch
      .where((item) => item.toLowerCase().startsWith(query))
      .toList();
}

/////filter in mainShowQuestion/////

List<dynamic> filterFromTags(List<dynamic> list, List<TagObject> tagList) {
  List<dynamic> returnList = [];
  for (var item in list) {
    bool isTagCorrect = true;
    for (TagObject tag in tagList) {
      if (!item.tags.contains(tag)) {
        isTagCorrect = false;
      }
    }
    if (isTagCorrect) {
      returnList.add(item);
    }
  }
  return returnList;
}

List<dynamic> filterFromQuesName(List<dynamic> list, String query) {
  if (query == '') {
    return list;
  }
  return list.where((item) => item.name.startsWith(query)).toList();
}
