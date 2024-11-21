import 'package:frontend/models/tag_object.dart';
import 'package:frontend/models/signalment_object.dart';

class QuestionObject {
  final String id;
  String name;
  String quesVersion;
  String clientComplains;
  String historyTakingInfo;
  String generalInfo;
  List<TagObject> tags;
  SignalmentObject signalment;
  String? extraQues;

  QuestionObject(
      {required this.id,
      required this.name,
      required this.quesVersion,
      required this.clientComplains,
      required this.historyTakingInfo,
      required this.generalInfo,
      required this.tags,
      required this.signalment,
      required this.extraQues});

  factory QuestionObject.fromJson(Map<String, dynamic> json) {
    return QuestionObject(
        id: json['id'] ?? "",
        name: json['name'] ?? "",
        quesVersion: json['quesVersion'] ?? "",
        clientComplains: json['clientComplains'] ?? "",
        historyTakingInfo: json['historyTakingInfo'] ?? "",
        generalInfo: json['generalInfo'] ?? "",
        tags: (json['tags'] as List<dynamic>)
                .map((tagJson) => TagObject.fromJson(tagJson))
                .toList() ??
            [],
        signalment: SignalmentObject.fromJson(json['signalment']),
        extraQues: json['extraQues']);
  }
}
