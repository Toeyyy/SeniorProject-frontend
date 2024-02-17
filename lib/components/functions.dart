import 'package:flutter/material.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:collection/collection.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/models/fullQuestionObject.dart';
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

List<QuestionObject> filterFromTagsNisit(
    List<QuestionObject> list, List<TagObject> tagList) {
  List<QuestionObject> returnList = [];
  for (QuestionObject item in list) {
    bool isTagCorrect = true;
    for (TagObject tag in tagList) {
      for (var i in item.tags) {}
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

List<FullQuestionObject> filterFromTagsTeacher(
    List<FullQuestionObject> list, List<TagObject> tagList) {
  List<FullQuestionObject> returnList = [];
  for (FullQuestionObject item in list) {
    bool isTagCorrect = true;
    for (TagObject tag in tagList) {
      for (var i in item.tags) {}
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
