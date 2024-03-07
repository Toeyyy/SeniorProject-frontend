import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/models/fullQuestionObject.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/questionObject.dart';
import 'package:frontend/models/examResultObject.dart';
import 'package:frontend/models/statModels/StatNisitObject.dart';
import 'package:frontend/models/statModels/StatQuestionObject.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:http/http.dart' as http;

//format '${dotenv.env['API_PATH']}/question/update/$id'

Future<List<QuestionObject>> fetchQuestionList() async {
  //real
  final String apiUrl = "${dotenv.env['API_PATH']}/question";
  final headers = {"Content-Type": "application/json"};
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((data) => QuestionObject.fromJson(data)).toList();
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return [];
    }
  } catch (error) {
    print("Error: $error");
    return [];
  }

  //tmp-comment later
  // try {
  //   final String jsonString =
  //       await rootBundle.loadString("data/tmpNisitQuestion.json");
  //   final List<dynamic> jsonList = json.decode(jsonString);
  //   return jsonList.map((data) => QuestionObject.fromJson(data)).toList();
  // } catch (error) {
  //   print('Error fetching data: $error');
  //   return [];
  // }
}

Future<List<ProblemObject>> fetchProblemAns(String quesId, int round) async {
  //real
  final String apiUrl =
      "${dotenv.env['API_PATH']}/question/solution/problem/$round/$quesId";
  final headers = {"Content-Type": "application/json"};
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((data) => ProblemObject.fromJson(data)).toList();
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return [];
    }
  } catch (error) {
    print("Error: $error");
    return [];
  }

  //tmp-comment later
  // try {
  //   String jsonString;
  //   if (round == 1) {
  //     jsonString = await rootBundle.loadString("data/tmpNisitProblemAns1.json");
  //   } else {
  //     jsonString = await rootBundle.loadString("data/tmpNisitProblemAns2.json");
  //   }
  //   final List<dynamic> jsonList = json.decode(jsonString)[0]['problems'];
  //   // print('jsonList = $jsonList');
  //   // print(
  //   //     'object data = ${jsonList.map((data) => ProblemObject.fromJson(data)).toList()}');
  //   return jsonList.map((data) => ProblemObject.fromJson(data)).toList();
  // } catch (error) {
  //   print('Error fetching data: $error');
  //   return [];
  // }
}

Future<void> fetchFullQuestionList() async {
  //real
  final String apiUrl = "${dotenv.env['API_PATH']}/question/solution";
  final headers = {"Content-Type": "application/json"};
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      teacherQuestionList =
          jsonList.map((data) => FullQuestionObject.fromJson(data)).toList();
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
    }
  } catch (error) {
    print("Error: $error");
  }

  //tmp-comment later
  // try {
  //   final String jsonString =
  //       await rootBundle.loadString("data/tmpTeacherQuestion.json");
  //
  //   final List<dynamic> jsonList = json.decode(jsonString);
  //   teacherQuestionList =
  //       jsonList.map((data) => FullQuestionObject.fromJson(data)).toList();
  // } catch (error) {
  //   print('Error fetching data: $error');
  // }
}

Future<List<ExamResultObject>> fetchResult(String examID, String quesID) async {
  //real
  final String apiUrl =
      "${dotenv.env['API_PATH']}/question/$quesID/examinationresult";
  List<Map<String, dynamic>> body = [
    {"examinationId": examID}
  ];
  final headers = {"Content-Type": "application/json"};
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: jsonEncode(body));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((data) => ExamResultObject.fromJson(data)).toList();
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return [];
    }
  } catch (error) {
    print("Error: $error");
    return [];
  }

  //tmp-comment later
  // try {
  //   final String jsonString =
  //       await rootBundle.loadString("data/tmpResultData.json");
  //   final List<dynamic> jsonList = json.decode(jsonString);
  //   return jsonList.map((data) => ExamResultObject.fromJson(data)).toList();
  // } catch (error) {
  //   print('error fetching data: $error');
  //   return [];
  // }
}

Future<StatQuestionObject> fetchStatQuestion(String quesId) async {
  //real
  final String apiUrl = "${dotenv.env['API_PATH']}/$quesId/stats";
  final headers = {"Content-Type": "application/json"};
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      dynamic jsonList = jsonDecode(response.body);
      return StatQuestionObject.fromJson(jsonList);
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return StatQuestionObject.fromJson({});
    }
  } catch (error) {
    print("Error: $error");
    return StatQuestionObject.fromJson({});
  }

  //tmp-comment later
  // try {
  //   final String jsonString =
  //       await rootBundle.loadString("data/tmpReturnPoint.json");
  //   final dynamic jsonList = json.decode(jsonString);
  //   return StatQuestionObject.fromJson(jsonList);
  // } catch (error) {
  //   print('error fetching data: $error');
  //   return StatQuestionObject.fromJson({});
  // }
}

Future<List<StatQuestionObject>> fetchStatForNisit() async {
  //real
  final String apiUrl = "${dotenv.env['API_PATH']}/student/stats";
  final headers = {"Content-Type": "application/json"};
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((data) => StatQuestionObject.fromJson(data)).toList();
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return [];
    }
  } catch (error) {
    print("Error: $error");
    return [];
  }

  //tmp-comment later
  // try {
  //   final String jsonString =
  //       await rootBundle.loadString("data/stat/tmpStatsForNisit.json");
  //   final List<dynamic> jsonList = json.decode(jsonString);
  //   return jsonList.map((data) => StatQuestionObject.fromJson(data)).toList();
  // } catch (error) {
  //   print('error fetching data: $error');
  //   return [];
  // }
}

Future<List<StatNisitObject>> fetchStatForTeacher(String quesId) async {
  //real
  final String apiUrl = "${dotenv.env['API_PATH']}/question/$quesId/stats";
  final headers = {"Content-Type": "application/json"};
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((data) => StatNisitObject.fromJson(data)).toList();
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return [];
    }
  } catch (error) {
    print("Error: $error");
    return [];
  }

  //tmp-comment later
  // try {
  //   final String jsonString =
  //       await rootBundle.loadString("data/stat/tmpStatsQuestion.json");
  //   final List<dynamic> jsonList = json.decode(jsonString);
  //   return jsonList.map((data) => StatNisitObject.fromJson(data)).toList();
  // } catch (error) {
  //   print('error fetching data: $error');
  //   return [];
  // }
}

/////get predefined/////

Future<void> fetchPreDefinedProb() async {
  //real
  final String apiUrl = "${dotenv.env['API_PATH']}";
  final headers = {"Content-Type": "application/json"};
  try {
    final response =
        await http.get(Uri.parse("$apiUrl/problem"), headers: headers);

    if ((response.statusCode >= 200 && response.statusCode < 300)) {
      final List<dynamic> jsonList = json.decode(response.body);
      problemListPreDefined =
          jsonList.map((data) => ProblemObject.fromJson(data)).toList();
    } else {
      print("Error fetch Prob: ${response.statusCode} - ${response.body}");
    }
  } catch (error) {
    print("Error: $error");
  }

  //tmp-comment later
  // try {
  //   final String jsonProbString =
  //       await rootBundle.loadString("data/preDefined/tmpProblem.json");
  //
  //   final List<dynamic> jsonProbList = json.decode(jsonProbString);
  //   problemListPreDefined =
  //       jsonProbList.map((data) => ProblemObject.fromJson(data)).toList();
  // } catch (error) {
  //   print('error fetching data: $error');
  // }
}

Future<void> fetchPreDefinedTag() async {
  //real
  final String apiUrl = "${dotenv.env['API_PATH']}";
  final headers = {"Content-Type": "application/json"};
  try {
    final response = await http.get(Uri.parse("$apiUrl/tag"), headers: headers);

    if ((response.statusCode >= 200 && response.statusCode < 300)) {
      final List<dynamic> jsonList = json.decode(response.body);
      tagListPreDefined =
          jsonList.map((data) => TagObject.fromJson(data)).toList();
    } else {
      print("Error fetch Prob: ${response.statusCode} - ${response.body}");
    }
  } catch (error) {
    print("Error: $error");
  }

  //tmp-comment later
  // try {
  //   final String jsonTagString =
  //       await rootBundle.loadString("data/preDefined/tmpTag.json");
  //
  //   final List<dynamic> jsonTagList = json.decode(jsonTagString);
  //   tagListPreDefined =
  //       jsonTagList.map((data) => TagObject.fromJson(data)).toList();
  // } catch (error) {
  //   print('error fetching data: $error');
  // }
}

Future<void> fetchPreDefinedDiag() async {
  //real
  final String apiUrl = "${dotenv.env['API_PATH']}";
  final headers = {"Content-Type": "application/json"};
  try {
    final response =
        await http.get(Uri.parse("$apiUrl/diagnostic"), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> jsonList = json.decode(response.body);
      diagnosisListPreDefined =
          jsonList.map((data) => DiagnosisObject.fromJson(data)).toList();
    } else {
      print("Error fetch Prob: ${response.statusCode} - ${response.body}");
    }
  } catch (error) {
    print("Error: $error");
  }

  //tmp-comment later
  // try {
  //   final String jsonDiagString =
  //       await rootBundle.loadString("data/preDefined/tmpDiagnosis.json");
  //
  //   final List<dynamic> jsonDiagList = json.decode(jsonDiagString);
  //   diagnosisListPreDefined =
  //       jsonDiagList.map((data) => DiagnosisObject.fromJson(data)).toList();
  // } catch (error) {
  //   print('error fetching data: $error');
  // }
}

Future<void> fetchPreDefinedTreatment() async {
  //real
  final String apiUrl = "${dotenv.env['API_PATH']}";
  final headers = {"Content-Type": "application/json"};
  try {
    final response =
        await http.get(Uri.parse("$apiUrl/treatment"), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> jsonList = json.decode(response.body);
      treatmentListPreDefined =
          jsonList.map((data) => TreatmentObject.fromJson(data)).toList();
    } else {
      print("Error fetch Prob: ${response.statusCode} - ${response.body}");
    }
  } catch (error) {
    print("Error: $error");
  }

  //tmp-comment later
  // try {
  //   final String jsonTreatmentString =
  //       await rootBundle.loadString("data/preDefined/tmpTreatment.json");
  //
  //   final List<dynamic> jsonTreatmentList = json.decode(jsonTreatmentString);
  //   treatmentListPreDefined = jsonTreatmentList
  //       .map((data) => TreatmentObject.fromJson(data))
  //       .toList();
  // } catch (error) {
  //   print('error fetching data: $error');
  // }
}

Future<void> fetchPreDefinedExam() async {
  //real
  final String apiUrl = "${dotenv.env['API_PATH']}";
  final headers = {"Content-Type": "application/json"};
  try {
    final response =
        await http.get(Uri.parse("$apiUrl/examination"), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> jsonList = json.decode(response.body);
      examListPreDefined =
          jsonList.map((data) => ExamPreDefinedObject.fromJson(data)).toList();
    } else {
      print("Error fetch Prob: ${response.statusCode} - ${response.body}");
    }
  } catch (error) {
    print("Error: $error");
  }

  // tmp-comment later
  // try {
  //   final String jsonExamString =
  //       await rootBundle.loadString("data/preDefined/tmpExamination.json");
  //
  //   final List<dynamic> jsonExamList = json.decode(jsonExamString);
  //   examListPreDefined = jsonExamList
  //       .map((data) => ExamPreDefinedObject.fromJson(data))
  //       .toList();
  // } catch (error) {
  //   print('error fetching data: $error');
  // }
}
