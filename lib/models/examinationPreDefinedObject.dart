class ExamPreDefinedObject {
  String id;
  String lab;
  String type;
  String name;
  int cost;
  ExamPreDefinedObject(
      {required this.id,
      required this.lab,
      required this.type,
      required this.name,
      required this.cost});

  factory ExamPreDefinedObject.fromJson(Map<String, dynamic> json) {
    return ExamPreDefinedObject(
        id: json['id'] ?? "",
        lab: json['lab'] ?? "",
        type: json['type'] ?? "",
        name: json['name'] ?? "",
        cost: json['cost'] ?? 0);
  }
}
