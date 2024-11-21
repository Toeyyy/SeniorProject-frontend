import 'package:frontend/models/problem_object.dart';
import 'package:frontend/models/tag_object.dart';
import 'package:frontend/models/signalment_object.dart';
import 'package:frontend/models/examination_object.dart';
import 'package:frontend/models/treatment_object.dart';
import 'package:frontend/models/diagnosis_object.dart';
import 'package:frontend/models/log_object.dart';

class FullQuestionObject {
  final String id;
  String name;
  String clientComplains;
  String historyTakingInfo;
  String generalInfo;
  List<TagObject>? tags;
  SignalmentObject? signalment;
  List<ProblemObject>? problems;
  List<TreatmentObject>? treatments;
  List<DiagnosisObject>? diagnostics;
  List<ExaminationObject>? examinations;
  String? extraQues;
  int modified;
  int status;
  List<LogObject>? logs;
  String quesVersion;

  FullQuestionObject(
      {required this.id,
      required this.name,
      required this.clientComplains,
      required this.historyTakingInfo,
      required this.generalInfo,
      required this.tags,
      required this.signalment,
      required this.problems,
      required this.treatments,
      required this.diagnostics,
      required this.examinations,
      required this.extraQues,
      required this.modified,
      required this.status,
      required this.logs,
      required this.quesVersion});

  factory FullQuestionObject.fromJson(Map<String, dynamic> json) {
    return FullQuestionObject(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      clientComplains: json['clientComplains'] ?? "",
      historyTakingInfo: json['historyTakingInfo'] ?? "",
      generalInfo: json['generalInfo'] ?? "",
      tags: json['tags'] != null
          ? (json['tags'] as List<dynamic>)
                  .map((jsonItem) => TagObject.fromJson(jsonItem))
                  .toList() ??
              []
          : [],
      signalment: json['signalment'] != null
          ? SignalmentObject.fromJson(json['signalment'])
          : SignalmentObject.fromJson({}),
      problems: json['problems'] != null
          ? (json['problems'] as List<dynamic>)
                  .map((jsonItem) => ProblemObject.fromJson(jsonItem))
                  .toList() ??
              []
          : [],
      treatments: json['treatments'] != null
          ? (json['treatments'] as List<dynamic>)
                  .map((jsonItem) => TreatmentObject.fromJson(jsonItem))
                  .toList() ??
              []
          : [],
      diagnostics: json['diagnostics'] != null
          ? (json['diagnostics'] as List<dynamic>)
                  .map((jsonItem) => DiagnosisObject.fromJson(jsonItem))
                  .toList() ??
              []
          : [],
      examinations: json['examinations'] != null
          ? (json['examinations'] as List<dynamic>)
                  .map((jsonItem) => ExaminationObject.fromJson(jsonItem))
                  .toList() ??
              []
          : [],
      extraQues: json['extraQues'],
      modified: json['modified'] ?? 2,
      status: json['status'] ?? 0,
      logs: json['logs'] != null
          ? (json['logs'] as List<dynamic>)
                  .map((jsonItem) => LogObject.fromJson(jsonItem))
                  .toList() ??
              []
          : [],
      quesVersion: json['quesVersion'] ?? "",
    );
  }
}
