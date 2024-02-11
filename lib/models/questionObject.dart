import 'package:frontend/models/problemListObject.dart';
import 'package:frontend/models/tagObject.dart';
import 'package:frontend/models/signalmentObject.dart';

class QuestionObject {
  final String id;
  String name;
  String clientComplains;
  String historyTakingInfo;
  String generalInfo;
  List<TagObject> tags;
  SignalmentObject signalment;
  List<ProblemObject> problems;

  QuestionObject(
      {required this.id,
      required this.name,
      required this.clientComplains,
      required this.historyTakingInfo,
      required this.generalInfo,
      required this.tags,
      required this.signalment,
      required this.problems});

  factory QuestionObject.fromJson(Map<String, dynamic> json) {
    return QuestionObject(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      clientComplains: json['clientComplains'] ?? "",
      historyTakingInfo: json['historyTakingInfo'] ?? "",
      generalInfo: json['generalInfo'] ?? "",
      tags: (json['tags'] as List<dynamic>)
              .map((tagJson) => TagObject.fromJson(tagJson))
              .toList() ??
          [],
      signalment: SignalmentObject.fromJson(json['signalment']),
      problems: (json['problems'] as List<dynamic>)
              .map((probJson) => ProblemObject.fromJson(probJson))
              .toList() ??
          [],
    );
  }
}
