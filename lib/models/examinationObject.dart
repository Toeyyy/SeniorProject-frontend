class ExaminationObject {
  String id;
  String type;
  String name;
  String textResult;
  String imgResult;
  String round;

  ExaminationObject(
      {required this.id,
      required this.type,
      required this.name,
      required this.textResult,
      required this.imgResult,
      required this.round});

  factory ExaminationObject.fromJson(Map<String, dynamic> json) {
    return ExaminationObject(
        id: json['id'] ?? "",
        type: json['type'] ?? "",
        name: json['name'] ?? "",
        textResult: json['textResult'] ?? "",
        imgResult: json['imgResult'] ?? "",
        round: json['round'] ?? "");
  }
}
