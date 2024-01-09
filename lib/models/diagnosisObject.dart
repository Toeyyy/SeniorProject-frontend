class DiagnosisObject {
  String id;
  String name;

  DiagnosisObject({required this.id, required this.name});

  factory DiagnosisObject.fromJson(Map<String, String> json) {
    return DiagnosisObject(id: json['id'] ?? "", name: json['name'] ?? "");
  }
}
