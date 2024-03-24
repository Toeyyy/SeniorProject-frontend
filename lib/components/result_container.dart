import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/models/exam_result_object.dart';
import 'package:frontend/models/examination_predefined_object.dart';
import 'package:frontend/constants.dart';

class ResultContainer extends StatelessWidget {
  final ExamResultObject result;
  final ExamPreDefinedObject selectedExam;

  const ResultContainer(
      {super.key, required this.result, required this.selectedExam});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        selectedExam.area != null
            ? ListTile(
                title: Text(
                  '${selectedExam.name} (${selectedExam.area})',
                  style: kSubHeaderTextStyleInLeftPart,
                ),
                leading: const Icon(Icons.circle, size: 15),
              )
            : ListTile(
                title: Text(
                  selectedExam.name,
                  style: kSubHeaderTextStyleInLeftPart,
                ),
                leading: const Icon(Icons.circle, size: 15),
              ),
        result.imgResult != null
            ? Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Image.network(
                      "${dotenv.env['RESOURCE_PATH']}${result.imgResult!.replaceFirst("Uploads", "")}",
                      height: 200,
                      width: 300,
                      fit: BoxFit.fill,
                    ),
                    const SizedBox(height: 15),
                    result.textResult != null
                        ? Text(
                            result.textResult!,
                            style: const TextStyle(fontSize: 18),
                          )
                        : const SizedBox(),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 50),
                child: result.textResult != null
                    ? Text(
                        result.textResult!,
                        style: const TextStyle(fontSize: 18),
                      )
                    : const SizedBox(),
              ),
      ],
    );
  }
}
