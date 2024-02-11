import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:frontend/models/diagnosisObject.dart';

class StatQuestionObject {
  String questionId;
  String questionName;
  List<ExamPreDefinedObject> examinations;
  List<ProblemObject> problems;
  List<TreatmentObject> treatments;
  List<DiagnosisObject> diagnostics;
  int problem1Score;
  int problem2Score;
  int examination1Score;
  int examination2Score;
  int treatmentScore;
  int diagnosticScore;

  StatQuestionObject(
      {required this.questionId,
      required this.questionName,
      required this.examinations,
      required this.problems,
      required this.treatments,
      required this.diagnostics,
      required this.problem1Score,
      required this.problem2Score,
      required this.examination1Score,
      required this.examination2Score,
      required this.treatmentScore,
      required this.diagnosticScore});

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
      problem1Score: json['problem1_Score'] ?? 0,
      problem2Score: json['problem2_Score'] ?? 0,
      examination1Score: json['examination1_Score'] ?? 0,
      examination2Score: json['examination2_Score'] ?? 0,
      treatmentScore: json['treatment_Score'] ?? 0,
      diagnosticScore: json['diagnostic_Score'] ?? 0,
    );
  }
}
