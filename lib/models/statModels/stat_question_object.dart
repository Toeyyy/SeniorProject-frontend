import 'package:frontend/models/examination_predefined_object.dart';
import 'package:frontend/models/problem_object.dart';
import 'package:frontend/models/treatment_object.dart';
import 'package:frontend/models/diagnosis_object.dart';

class StatQuestionObject {
  String questionId;
  String questionName;
  List<ExamPreDefinedObject> examinations;
  List<ProblemObject> problems;
  List<TreatmentObject> treatments;
  List<DiagnosisObject> diagnostics;
  double problem1Score;
  double problem2Score;
  double examinationScore;
  double treatmentScore;
  double diffDiagScore;
  double tenDiagScore;
  String dateTime;

  StatQuestionObject(
      {required this.questionId,
      required this.questionName,
      required this.examinations,
      required this.problems,
      required this.treatments,
      required this.diagnostics,
      required this.problem1Score,
      required this.problem2Score,
      required this.examinationScore,
      required this.treatmentScore,
      required this.diffDiagScore,
      required this.tenDiagScore,
      required this.dateTime});

  factory StatQuestionObject.fromJson(Map<String, dynamic> json) {
    return StatQuestionObject(
      questionId: json['questionId'] ?? "",
      questionName: json['questionName'] ?? "",
      examinations: (json['examinations'] as List<dynamic>)
              .map((jsonItem) => ExamPreDefinedObject.fromJson(jsonItem))
              .toList() ??
          [],
      problems: (json['problems'] as List<dynamic>)
              .map((jsonItem) => ProblemObject.fromJson(jsonItem))
              .toList() ??
          [],
      treatments: (json['treatments'] as List<dynamic>)
              .map((jsonItem) => TreatmentObject.fromJson(jsonItem))
              .toList() ??
          [],
      diagnostics: (json['diagnostics'] as List<dynamic>)
              .map((jsonItem) => DiagnosisObject.fromJson(jsonItem))
              .toList() ??
          [],
      problem1Score: json['problem1_Score'] ?? 0.0,
      problem2Score: json['problem2_Score'] ?? 0.0,
      examinationScore: json['examination_Score'] ?? 0.0,
      treatmentScore: json['treatment_Score'] ?? 0.0,
      diffDiagScore: json['diffDiag_Score'] ?? 0.0,
      tenDiagScore: json['tenDiag_Score'] ?? 0.0,
      dateTime: json['dateTime'] ?? "",
    );
  }
}
