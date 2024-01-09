class QuestionObj {
  String quesNum;
  String type;
  String breed;
  String sex;
  bool sterilize;
  String age;
  String weight;
  List<String> tagList;
  String historyTaking;
  String clientComp;
  List<String> generalResult;

  QuestionObj(
      {required this.quesNum,
      required this.type,
      required this.breed,
      required this.sex,
      required this.sterilize,
      required this.age,
      required this.weight,
      required this.tagList,
      required this.historyTaking,
      required this.clientComp,
      required this.generalResult});

  factory QuestionObj.fromJson(Map<String, dynamic> json) {
    return QuestionObj(
      quesNum: json['quesNum'] ?? "",
      type: json['type'] ?? "",
      breed: json['breed'] ?? "",
      sex: json['sex'] ?? "",
      sterilize: json['sterilize'] ?? "",
      age: json['age'] ?? "",
      weight: json['weight'] ?? "",
      tagList: (json['tagList'] as List<dynamic>?)?.cast<String>() ?? [],
      historyTaking: json['historyTaking'] ?? "",
      clientComp: json['clientComp'] ?? "",
      generalResult:
          (json['generalResult'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}
