import 'package:flutter/material.dart';
import 'package:frontend/tmpQuestion.dart';

List<String> filterList(
    TextEditingController searchController, List<String> listForSearch) {
  String query = searchController.text.toLowerCase();
  return listForSearch
      .where((item) => item.toLowerCase().startsWith(query))
      .toList();
}

List<String> filterBreed(String animal) {
  if (animal == 'สุนัข') {
    return Signalment_dogBreedList;
  } else if (animal == 'แมว') {
    return Signalment_catBreedList;
  } else {
    return Signalment_birdBreedList;
  }
}

List<String> filterExam(String de) {
  if (de == 'เลือดและปัสสาวะ') {
    return topicExamList1;
  } else if (de == 'จุลชีววิทยา') {
    return topicExamList2;
  } else if (de == 'อณูวินิจฉัย') {
    return topicExamList3;
  } else if (de == 'เซลล์วินิจฉัย') {
    return topicExamList4;
  } else {
    return topicExamList5;
  }
}

List<String> filterTreatment(String topic) {
  if (topic == 'Medical Treatment') {
    return medicalTreatmentList;
  } else if (topic == 'Surgical Treatment') {
    return surgicalTreatmentList;
  } else if (topic == 'Nutrition Support') {
    return nutritionSupportList;
  } else {
    return otherTreatmentList;
  }
}

List<String> filterEditList(String value) {
  if (value == 'Problem List') {
    return probListSet;
  } else if (value == 'Diagnosis List') {
    return diagnosisList.map((e) => e.name).toList();
  } else if (value == 'Medical Treatment List') {
    return medicalTreatmentList;
  } else if (value == 'Surgical Treatment List') {
    return surgicalTreatmentList;
  } else if (value == 'Nutrition Support List') {
    return nutritionSupportList;
  } else {
    return otherTreatmentList;
  }
}
