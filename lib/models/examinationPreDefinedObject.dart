import 'package:file_picker/file_picker.dart';

class ExamPreDefinedObject {
  String id;
  String lab;
  String type;
  String? area;
  String name;
  String? textDefault;
  String? imgPath;
  PlatformFile? imgDefault;
  int cost;

  ExamPreDefinedObject(
      {required this.id,
      required this.lab,
      required this.type,
      this.area,
      required this.name,
      this.textDefault,
      this.imgPath,
      this.imgDefault,
      required this.cost});

  factory ExamPreDefinedObject.fromJson(Map<String, dynamic> json) {
    return ExamPreDefinedObject(
        id: json['id'] ?? "",
        lab: json['lab'] ?? "",
        type: json['type'] ?? json['lab'],
        area: json['area'],
        name: json['name'] ?? "",
        textDefault: json['textDefault'],
        imgPath: json['imgPath'],
        imgDefault: json['imgDefault'],
        cost: json['cost'] ?? 0);
  }

  ExamPreDefinedObject copyWith(ExamPreDefinedObject item) {
    return ExamPreDefinedObject(
        id: item.id,
        lab: item.lab,
        type: item.type,
        name: item.name,
        cost: item.cost);
  }
}
