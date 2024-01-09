class TreatmentObject {
  String id;
  String type;
  String name;

  TreatmentObject({required this.id, required this.type, required this.name});

  factory TreatmentObject.fromJson(Map<String, String> json) {
    return TreatmentObject(
        id: json['id'] ?? "",
        type: json['type'] ?? "",
        name: json['name'] ?? "");
  }
}
