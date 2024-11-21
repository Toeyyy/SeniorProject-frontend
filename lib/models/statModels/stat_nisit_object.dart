import 'package:frontend/models/examination_predefined_object.dart';
import 'package:frontend/models/problem_object.dart';
import 'package:frontend/models/treatment_object.dart';
import 'package:frontend/models/diagnosis_object.dart';

class StatNisitObject {
  String userId;
  String userName;
  List<ExamPreDefinedObject> examinations;
  List<ProblemObject> problems;
  List<TreatmentObject> treatments;
  List<DiagnosisObject> diagnostics;
  String? extraAns;
  double problem1Score;
  double problem2Score;
  double examinationScore;
  double treatmentScore;
  double diffDiagScore;
  double tenDiagScore;
  String dateTime;
  String quesVersion;

  StatNisitObject(
      {required this.userId,
      required this.userName,
      required this.examinations,
      required this.problems,
      required this.treatments,
      required this.diagnostics,
      required this.extraAns,
      required this.problem1Score,
      required this.problem2Score,
      required this.examinationScore,
      required this.treatmentScore,
      required this.diffDiagScore,
      required this.tenDiagScore,
      required this.dateTime,
      required this.quesVersion});

  factory StatNisitObject.fromJson(Map<String, dynamic> json) {
    return StatNisitObject(
      userId: json['userId'] ?? "",
      userName: json['userName'] ?? "",
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
      extraAns: json['extraAns'],
      problem1Score: json['problem1_Score'] ?? 0,
      problem2Score: json['problem2_Score'] ?? 0,
      examinationScore: json['examination_Score'] ?? 0,
      treatmentScore: json['treatment_Score'] ?? 0,
      diffDiagScore: json['diffDiag_Score'] ?? 0,
      tenDiagScore: json['tenDiag_Score'] ?? 0,
      dateTime: json['dateTime'] ?? "",
      quesVersion: json['quesVersion'] ?? "",
    );
  }
}
