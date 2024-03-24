class ExamResultObject {
  String id;
  String? textResult;
  String? imgResult;

  ExamResultObject(
      {required this.id, required this.textResult, required this.imgResult});

  factory ExamResultObject.fromJson(Map<String, dynamic> json) {
    return ExamResultObject(
        id: json['id'] ?? "",
        textResult: json['textResult'],
        imgResult: json['imgResult']);
  }
}
