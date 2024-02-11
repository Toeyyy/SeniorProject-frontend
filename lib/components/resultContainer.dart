import 'package:flutter/material.dart';
import 'package:frontend/models/examResultObject.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/components/BoxesInAddQ.dart';

class ResultContainer extends StatelessWidget {
  ExamResultObject result;
  ExamPreDefinedObject selectedExam;
  ResultContainer({required this.result, required this.selectedExam});
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
                leading: Icon(Icons.circle, size: 15),
              )
            : ListTile(
                title: Text(
                  selectedExam.name,
                  style: kSubHeaderTextStyleInLeftPart,
                ),
                leading: Icon(Icons.circle, size: 15),
              ),
        result.imgResult != null
            ? Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Image.network(
                      result.imgResult!,
                      height: 200,
                      width: 300,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 15),
                    Text(
                      result.textResult,
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Text(
                  result.textResult,
                  style: TextStyle(fontSize: 18),
                ),
              ),
      ],
    );
  }
}