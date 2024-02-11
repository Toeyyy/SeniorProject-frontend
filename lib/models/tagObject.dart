class TagObject {
  final String id;
  final String name;

  TagObject({required this.id, required this.name});

  factory TagObject.fromJson(Map<String, dynamic> json) {
    return TagObject(id: json['id'] ?? "", name: json['name'] ?? "");
  }
}
