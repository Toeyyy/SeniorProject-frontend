class DiagnosisObject {
  String id;
  String type;
  String name;

  DiagnosisObject({required this.id, required this.type, required this.name});

  factory DiagnosisObject.fromJson(Map<String, dynamic> json) {
    return DiagnosisObject(
        id: json['id'] ?? "",
        type: json['type'] ?? "",
        name: json['name'] ?? "");
  }
}
