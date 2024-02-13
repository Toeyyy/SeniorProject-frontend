class TagObject {
  final String id;
  final String name;

  TagObject({required this.id, required this.name});

  factory TagObject.fromJson(Map<String, dynamic> json) {
    return TagObject(id: json['id'] ?? "", name: json['name'] ?? "");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagObject &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id;

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
