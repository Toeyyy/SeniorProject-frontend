import 'package:file_picker/file_picker.dart';

class ExaminationObject {
  String id;
  String lab;
  String type;
  String? area;
  String name;
  String textResult;
  String? imgPath;
  PlatformFile? imgResult;
  String round;

  ExaminationObject(
      {required this.id,
      required this.lab,
      required this.type,
      required this.area,
      required this.name,
      required this.textResult,
      required this.imgPath,
      required this.imgResult,
      required this.round});

  factory ExaminationObject.fromJson(Map<String, dynamic> json) {
    return ExaminationObject(
        id: json['id'] ?? "",
        lab: json['lab'] ?? "",
        type: json['type'] ?? "",
        area: json['area'] ?? "",
        name: json['name'] ?? "",
        textResult: json['textResult'] ?? "",
        imgPath: json['imgPath'] ?? "",
        imgResult: json['imgResult'],
        round: json['round'] ?? "");
  }
}
