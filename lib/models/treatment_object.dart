class TreatmentObject {
  String id;
  String type;
  String name;
  int cost;

  TreatmentObject(
      {required this.id,
      required this.type,
      required this.name,
      required this.cost});

  factory TreatmentObject.fromJson(Map<String, dynamic> json) {
    return TreatmentObject(
        id: json['id'] ?? "",
        type: json['type'] ?? "",
        name: json['name'] ?? "",
        cost: json['cost'] ?? 0);
  }
}
