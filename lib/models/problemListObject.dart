class ProblemObject {
  final String id;
  String name;
  int? round;

  ProblemObject({required this.id, required this.name, this.round});

  factory ProblemObject.fromJson(Map<String, dynamic> json) {
    return ProblemObject(
        id: json['id'] ?? "",
        name: json['name'] ?? "",
        round: json['round'] as int?);
  }
}
