import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:frontend/models/diagnosis_object.dart';
import 'package:frontend/models/examination_predefined_object.dart';
import 'package:frontend/models/full_question_object.dart';
import 'package:frontend/models/problem_object.dart';
import 'package:frontend/models/question_object.dart';
import 'package:frontend/models/exam_result_object.dart';
import 'package:frontend/models/statModels/stat_nisit_object.dart';
import 'package:frontend/models/statModels/stat_question_object.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/AllDataFile.dart';
import 'package:frontend/models/tag_object.dart';
import 'package:frontend/models/treatment_object.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/my_secure_storage.dart';

Future<List<QuestionObject>> fetchQuestionList() async {
  final String apiUrl = "${dotenv.env['API_PATH']}/question";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((data) => QuestionObject.fromJson(data)).toList();
    } else {
      if (kDebugMode) {
        print("Error: ${response.statusCode}");
      }
      return [];
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error: $error");
    }
    return [];
  }
}

Future<QuestionObject> fetchQuestionFromId(String quesId) async {
  final String apiUrl = "${dotenv.env['API_PATH']}/question/$quesId";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      dynamic jsonFile = jsonDecode(response.body);
      return QuestionObject.fromJson(jsonFile);
    } else {
      if (kDebugMode) {
        print("Error: ${response.statusCode}");
      }
      return QuestionObject.fromJson({});
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error");
    }
    return QuestionObject.fromJson({});
  }
}

Future<FullQuestionObject> fetchFullQuestionFromId(String quesId) async {
  final String apiUrl = "${dotenv.env['API_PATH']}/question/solution/$quesId";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      dynamic jsonFile = jsonDecode(response.body);
      return FullQuestionObject.fromJson(jsonFile);
    } else {
      if (kDebugMode) {
        print("Error: ${response.statusCode}}");
      }
      return FullQuestionObject.fromJson({});
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error");
    }
    return FullQuestionObject.fromJson({});
  }
}

Future<List<ProblemObject>> fetchProblemAns(String quesId, int round) async {
  final String apiUrl =
      "${dotenv.env['API_PATH']}/question/solution/problem/$round/$quesId";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((data) => ProblemObject.fromJson(data)).toList();
    } else {
      if (kDebugMode) {
        print("Error: ${response.statusCode}");
      }
      return [];
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error");
    }
    return [];
  }
}

Future<List<ExamPreDefinedObject>> fetchExamAns(String quesId) async {
  final String apiUrl =
      "${dotenv.env['API_PATH']}/question/solution/examination/$quesId";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map((data) => ExamPreDefinedObject.fromJson(data))
          .toList();
    } else {
      if (kDebugMode) {
        print("Error: ${response.statusCode}");
      }
      return [];
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error: $error");
    }
    return [];
  }
}

Future<List<DiagnosisObject>> fetchDiagAns(String quesId) async {
  final String apiUrl =
      "${dotenv.env['API_PATH']}/question/solution/diagnostic/$quesId";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((data) => DiagnosisObject.fromJson(data)).toList();
    } else {
      if (kDebugMode) {
        print("Error: ${response.statusCode}");
      }
      return [];
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error");
    }
    return [];
  }
}

Future<List<TreatmentObject>> fetchTreatmentAns(String quesId) async {
  final String apiUrl =
      "${dotenv.env['API_PATH']}/question/solution/treatment/$quesId";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((data) => TreatmentObject.fromJson(data)).toList();
    } else {
      if (kDebugMode) {
        print("Error: ${response.statusCode}");
      }
      return [];
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error");
    }
    return [];
  }
}

Future<void> fetchFullQuestionList() async {
  final String apiUrl = "${dotenv.env['API_PATH']}/question/solution";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      teacherQuestionList =
          jsonList.map((data) => FullQuestionObject.fromJson(data)).toList();
    } else {
      if (kDebugMode) {
        print("Error: ${response.statusCode}");
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error");
    }
  }
}

Future<List<ExamResultObject>> fetchResult(String examID, String quesID) async {
  final String apiUrl =
      "${dotenv.env['API_PATH']}/question/$quesID/examinationresult";
  await MySecureStorage().refreshToken();
  List<Map<String, dynamic>> body = [
    {"examinationId": examID}
  ];
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response = await http.post(Uri.parse(apiUrl),
        headers: headers, body: jsonEncode(body));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((data) => ExamResultObject.fromJson(data)).toList();
    } else {
      if (kDebugMode) {
        print("Error: ${response.statusCode}");
      }
      return [];
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error: $error");
    }
    return [];
  }
}

Future<StatQuestionObject> fetchStatQuestion(String quesId) async {
  final String apiUrl = "${dotenv.env['API_PATH']}/student/$quesId/stats";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      dynamic jsonList = jsonDecode(response.body);
      return StatQuestionObject.fromJson(jsonList);
    } else {
      if (kDebugMode) {
        print("Error: ${response.statusCode}");
      }
      return StatQuestionObject.fromJson({});
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error: $error");
    }
    return StatQuestionObject.fromJson({});
  }
}

Future<List<StatQuestionObject>> fetchStatForNisit() async {
  final String apiUrl = "${dotenv.env['API_PATH']}/student/stats";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((data) => StatQuestionObject.fromJson(data)).toList();
    } else {
      if (kDebugMode) {
        print("Error: ${response.statusCode}");
      }
      return [];
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error: $error");
    }
    return [];
  }
}

Future<List<StatNisitObject>> fetchStatForTeacher(String quesId) async {
  final String apiUrl = "${dotenv.env['API_PATH']}/question/$quesId/stats";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((data) => StatNisitObject.fromJson(data)).toList();
    } else {
      if (kDebugMode) {
        print("Error: ${response.statusCode}");
      }
      return [];
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error: $error");
    }
    return [];
  }
}

/////get predefined/////

Future<void> fetchPreDefinedProb() async {
  final String apiUrl = "${dotenv.env['API_PATH']}";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response =
        await http.get(Uri.parse("$apiUrl/problem"), headers: headers);

    if ((response.statusCode >= 200 && response.statusCode < 300)) {
      final List<dynamic> jsonList = json.decode(response.body);
      problemListPreDefined =
          jsonList.map((data) => ProblemObject.fromJson(data)).toList();
    } else {
      if (kDebugMode) {
        print("Error fetch Prob: ${response.statusCode}");
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error");
    }
  }
}

Future<void> fetchPreDefinedTag() async {
  final String apiUrl = "${dotenv.env['API_PATH']}";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response = await http.get(Uri.parse("$apiUrl/tag"), headers: headers);

    if ((response.statusCode >= 200 && response.statusCode < 300)) {
      final List<dynamic> jsonList = json.decode(response.body);
      tagListPreDefined =
          jsonList.map((data) => TagObject.fromJson(data)).toList();
    } else {
      if (kDebugMode) {
        print("Error fetch Tag: ${response.statusCode}");
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error: $error");
    }
  }
}

Future<void> fetchPreDefinedDiag() async {
  final String apiUrl = "${dotenv.env['API_PATH']}";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response =
        await http.get(Uri.parse("$apiUrl/diagnostic"), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> jsonList = json.decode(response.body);
      diagnosisListPreDefined =
          jsonList.map((data) => DiagnosisObject.fromJson(data)).toList();
    } else {
      if (kDebugMode) {
        print("Error fetch Diag: ${response.statusCode}");
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error: $error");
    }
  }
}

Future<void> fetchPreDefinedTreatment() async {
  final String apiUrl = "${dotenv.env['API_PATH']}";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response =
        await http.get(Uri.parse("$apiUrl/treatment"), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> jsonList = json.decode(response.body);
      treatmentListPreDefined =
          jsonList.map((data) => TreatmentObject.fromJson(data)).toList();
    } else {
      if (kDebugMode) {
        print("Error fetch treatment: ${response.statusCode}");
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error");
    }
  }
}

Future<void> fetchPreDefinedExam() async {
  final String apiUrl = "${dotenv.env['API_PATH']}";
  await MySecureStorage().refreshToken();
  final headers = {
    "Content-Type": "application/json",
    "Authorization":
        "Bearer ${await MySecureStorage().readSecureData('accessToken')}"
  };
  try {
    final response =
        await http.get(Uri.parse("$apiUrl/examination"), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final List<dynamic> jsonList = json.decode(response.body);
      examListPreDefined =
          jsonList.map((data) => ExamPreDefinedObject.fromJson(data)).toList();
    } else {
      if (kDebugMode) {
        print("Error fetch Exam: ${response.statusCode}");
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error");
    }
  }
}

/////functions for fetch predefined/////

Future<void> fetchPreDefined() async {
  await fetchPreDefinedProb();
  await fetchPreDefinedDiag();
  await fetchPreDefinedExam();
  await fetchPreDefinedTag();
  await fetchPreDefinedTreatment();
}

Future<void> getTreatment() async {
  await fetchPreDefinedTreatment();
}

Future<void> getExams() async {
  await fetchPreDefinedExam();
}

Future<void> getProbDiagTag(String title) async {
  if (title == 'Problem') {
    await fetchPreDefinedProb();
  } else if (title == 'Tentative/Definitive Diagnosis' ||
      title == 'Differential Diagnosis') {
    await fetchPreDefinedDiag();
  } else {
    await fetchPreDefinedTag();
  }
}
