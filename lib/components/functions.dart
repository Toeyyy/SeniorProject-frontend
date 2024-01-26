import 'package:flutter/material.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:collection/collection.dart';

List<ProblemObject> filterProblemList(
    TextEditingController searchController, List<ProblemObject> listForSearch) {
  String query = searchController.text.toLowerCase();
  if (query == '') {
    return listForSearch;
  } else {
    return listForSearch
        .where((item) => item.name.toLowerCase().startsWith(query))
        .toList();
  }
}

List<DiagnosisObject> filterDiagnosisList(
    TextEditingController searchController,
    List<DiagnosisObject> listForSearch) {
  String query = searchController.text.toLowerCase();
  return listForSearch
      .where((item) => item.name.toLowerCase().startsWith(query))
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

// List<String> filterExam(String de) {
//   if (de == 'เลือดและปัสสาวะ') {
//     return topicExamList1;
//   } else if (de == 'จุลชีววิทยา') {
//     return topicExamList2;
//   } else if (de == 'อณูวินิจฉัย') {
//     return topicExamList3;
//   } else if (de == 'เซลล์วินิจฉัย') {
//     return topicExamList4;
//   } else {
//     return topicExamList5;
//   }
// }

// List<String> filterTreatment(String topic) {
//   if (topic == 'medical') {
//     return medicalTreatmentList;
//   } else if (topic == 'Surgical') {
//     return surgicalTreatmentList;
//   } else if (topic == 'Nutritional support') {
//     return nutritionSupportList;
//   } else {
//     return otherTreatmentList;
//   }
// }

List<String> filterTreatment(String topic) {
  if (topic == 'Medical') {
    return preDefinedTreatmentAll
        .where((item) => item.type == 'Medical')
        .map((e) => e.name)
        .toList();
  } else if (topic == 'Surgical') {
    return preDefinedTreatmentAll
        .where((item) => item.type == 'Surgical')
        .map((e) => e.name)
        .toList();
  } else if (topic == 'Nutritional support') {
    return preDefinedTreatmentAll
        .where((item) => item.type == 'Nutritional support')
        .map((e) => e.name)
        .toList();
  } else {
    return preDefinedTreatmentAll
        .where((item) => item.type == 'Other')
        .map((e) => e.name)
        .toList();
  }
}

List<String> getTreatmentTopic() {
  return groupBy(preDefinedTreatmentAll, (e) => e.type).keys.toList();
}

/////predefined//////

List<dynamic> filterEditTopicList(String value) {
  if (value == 'Problem List') {
    return preDefinedProblem;
  } else if (value == 'Diagnosis List') {
    return preDefinedDiagnosis;
  } else if (value == 'Medical Treatment List') {
    return preDefinedTreatmentAll
        .where((item) => item.type == 'Medical')
        .toList();
  } else if (value == 'Surgical Treatment List') {
    return preDefinedTreatmentAll
        .where((item) => item.type == 'Surgical')
        .toList();
  } else if (value == 'Nutrition Support List') {
    return preDefinedTreatmentAll
        .where((item) => item.type == 'Nutritional support')
        .toList();
  } else {
    return preDefinedTreatmentAll
        .where((item) => item.type == 'Other')
        .toList();
  }
}

List<dynamic> filterList(
    TextEditingController searchController, List<dynamic> listForSearch) {
  String query = searchController.text.toLowerCase();
  return listForSearch
      .where((item) => item.name.toLowerCase().startsWith(query))
      .toList();
}
