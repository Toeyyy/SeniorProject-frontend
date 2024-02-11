class ExamPreDefinedObject {
  String id;
  String lab;
  String type;
  String? area;
  String name;
  int cost;
  int? round;

  ExamPreDefinedObject(
      {required this.id,
      required this.lab,
      required this.type,
      this.area,
      required this.name,
      required this.cost,
      this.round});

  factory ExamPreDefinedObject.fromJson(Map<String, dynamic> json) {
    return ExamPreDefinedObject(
        id: json['id'] ?? "",
        lab: json['lab'] ?? "",
        type: json['type'] ?? json['lab'],
        area: json['area'],
        name: json['name'] ?? "",
        cost: json['cost'] ?? 0,
        round: json['round'] as int?);
  }
}
