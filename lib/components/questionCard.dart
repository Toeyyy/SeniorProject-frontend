import 'package:flutter/material.dart';
import 'package:frontend/aboutData/dataObject.dart';
import 'package:frontend/components/tagBox.dart';
import 'package:frontend/tmpQuestion.dart';

class QuestionCard extends StatelessWidget {
  final QuestionObj questionObj;

  QuestionCard({required this.questionObj});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Color(0xFFA0E9FF),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'รหัสโจทย์: ${questionObj.quesNum}',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            Text('ชนิดสัตว์: ${questionObj.type}'),
            Text('พันธุ์: ${questionObj.breed}'),
            Text('เพศ: ${questionObj.sex}'),
            Text(questionObj.sterilize == true
                ? 'ทำหมันแล้ว'
                : 'ยังไม่ได้ทำหมัน'),
            Text('อายุ: ${questionObj.age} ปี'),
            Text('น้ำหนัก: ${questionObj.weight} Kg'),
            Container(
              child: Wrap(
                spacing: 2,
                runSpacing: 2,
                children: tagList
                    .map(
                      (e) => TagBox(e),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
