import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/models/signalmentObject.dart';
import 'package:frontend/models/examinationObject.dart';
import 'package:frontend/models/treatmentObject.dart';
import 'package:frontend/models/diagnosisObject.dart';
import 'package:frontend/models/logObject.dart';

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
  bool modified;
  int status;
  List<LogObject>? logs;

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
      required this.modified,
      required this.status,
      required this.logs});

  factory FullQuestionObject.fromJson(Map<String, dynamic> json) {
    // print('Received JSON: $json');

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
      modified: json['modified'] ?? false,
      status: json['status'] ?? 0,
      logs: json['logs'] != null
          ? (json['logs'] as List<dynamic>)
                  .map((jsonItem) => LogObject.fromJson(jsonItem))
                  .toList() ??
              []
          : [],
    );
  }
}
