import 'package:flutter/material.dart';
import 'package:frontend/aboutData/dataObject.dart';
import 'package:frontend/components/tagBox.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/tmpQuestion.dart';

class QuestionCard extends StatelessWidget {
  final QuestionObj questionObj;

  QuestionCard({required this.questionObj});

  void _showModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Color(0xFFBBF5FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            color: Color(0xFFE7F9FF),
                            child: Text(
                              'โจทย์ ${questionObj.quesNum}',
                              style: kSubHeaderTextStyle,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Wrap(
                              spacing: 2,
                              runSpacing: 2,
                              // children: questionObj.tagList
                              //     .map(
                              //       (e) => TagBox(
                              //         text: e,
                              //         textSize: 20,
                              //       ),
                              //     )
                              //     .toList(),
                              children: showTagList
                                  .map(
                                    (e) => TagBox(text: e.name, textSize: 20),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    'สายพันธุ์: ${questionObj.breed}, อายุ: ${questionObj.age}, น้ำหนัก: ${questionObj.weight}',
                    style: kNormalTextStyle,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Client Complains',
                    style:
                        kNormalTextStyle.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    height: 50,
                    color: Color(0xFFE7F9FF),
                    child: Text(questionObj.clientComp, maxLines: 2),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'History Taking',
                    style:
                        kNormalTextStyle.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    width: double.infinity,
                    height: 50,
                    color: Color(0xFFE7F9FF),
                    child: Text(questionObj.historyTaking, maxLines: 2),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('ยืนยัน'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showModal(context);
      },
      child: Column(
        children: [
          Card(
            elevation: 5,
            color: Color(0xFFA0E9FF),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'รหัสโจทย์: ${questionObj.quesNum}',
                    style: kSubHeaderTextStyle,
                  ),
                  Text(
                      'ชนิดสัตว์: ${questionObj.type}, พันธุ์: ${questionObj.breed}',
                      style: kNormalTextStyle),
                  SizedBox(height: 5),
                  Container(
                    child: Wrap(
                      spacing: 2,
                      runSpacing: 2,
                      children: showTagList
                          .map(
                            (e) => TagBox(text: e.name),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
