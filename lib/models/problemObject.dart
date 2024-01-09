class ProblemObject {
  String id;
  String name;
  String round;

  ProblemObject({required this.id, required this.name, required this.round});

  factory ProblemObject.fromJson(Map<String, String> json) {
    return ProblemObject(
        id: json['id'] ?? "",
        name: json['name'] ?? "",
        round: json['round'] ?? "");
  }
}
