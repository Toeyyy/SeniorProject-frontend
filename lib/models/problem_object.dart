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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProblemObject &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id;

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
