class LogObject {
  final String id;
  String name;
  String dateTime;

  LogObject({required this.id, required this.name, required this.dateTime});

  factory LogObject.fromJson(Map<String, dynamic> json) {
    return LogObject(
        id: json['id'] ?? "",
        name: json['name'] ?? "",
        dateTime: json['dateTime'] ?? "");
  }
}
