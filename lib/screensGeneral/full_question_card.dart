import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/tag_box.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/models/full_question_object.dart';
import 'package:go_router/go_router.dart';

class FullQuestionCard extends StatelessWidget {
  final FullQuestionObject questionObj;

  const FullQuestionCard({super.key, required this.questionObj});

  void _showModal(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                color: questionObj.status == 0
                    ? const Color(0xFFBBF5FF)
                    : const Color(0xFF8BE4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            color: const Color(0xFFE7F9FF),
                            child: Text(
                              'โจทย์ ${questionObj.name}',
                              style: kSubHeaderTextStyle,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'V. ${questionObj.quesVersion}',
                            style: const TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  questionObj.tags != []
                      ? Wrap(
                          spacing: 2,
                          runSpacing: 5,
                          children: questionObj.tags!
                              .map(
                                (e) => TagBox(text: e.name, textSize: 20),
                              )
                              .toList(),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 15),
                  Text(
                    'สายพันธุ์: ${questionObj.signalment?.breed}, อายุ: ${questionObj.signalment?.age}, น้ำหนัก: ${questionObj.signalment?.weight}',
                    style: kNormalTextStyle,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Client Complains',
                    style:
                        kNormalTextStyle.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: double.infinity,
                    height: 50,
                    color: const Color(0xFFE7F9FF),
                    child: Text(questionObj.clientComplains, maxLines: 2),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'History Taking',
                    style:
                        kNormalTextStyle.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: double.infinity,
                    height: 50,
                    color: const Color(0xFFE7F9FF),
                    child: Text(questionObj.historyTakingInfo, maxLines: 2),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          //go to showQues
                          context.goNamed(
                            'showQuestion',
                            queryParameters: {"id": questionObj.id},
                          );
                        },
                        child: const Text('ดูโจทย์'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _modifiedModal(BuildContext context, int status) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFBBF5FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  status == 1
                      ? Text(
                          'มีการแก้ไขข้อมูล Predefined ที่ใช้ในโจทย์',
                          style: kNormalTextStyle.copyWith(
                              fontWeight: FontWeight.w700),
                        )
                      : Text(
                          'มีการลบข้อมูล Predefined ที่ใช้ในโจทย์',
                          style: kNormalTextStyle.copyWith(
                              fontWeight: FontWeight.w700),
                        ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      context.goNamed(
                        'editQuestion',
                        queryParameters: {"id": questionObj.id},
                      );
                    },
                    child: const Text('แก้ไขโจทย์'),
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
            color: questionObj.status == 0
                ? const Color(0xFFBBF5FF)
                : const Color(0xFF8BE4FF),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'รหัสโจทย์: ${questionObj.name}',
                        style: kSubHeaderTextStyle,
                      ),
                      Row(
                        children: [
                          questionObj.status == 0
                              ? IconButton(
                                  onPressed: () {
                                    context.goNamed(
                                      'editQuestion',
                                      queryParameters: {"id": questionObj.id},
                                    );
                                  },
                                  icon: const Icon(Icons.description_outlined),
                                  tooltip: "แก้ไข draft",
                                )
                              : const SizedBox(),
                          (questionObj.modified == 1 ||
                                  questionObj.modified == 2)
                              ? IconButton(
                                  onPressed: () {
                                    _modifiedModal(
                                        context, questionObj.modified);
                                  },
                                  icon: Icon(
                                    CupertinoIcons.exclamationmark_circle_fill,
                                    color: questionObj.modified == 1
                                        ? const Color(0xFFfca404)
                                        : const Color(0xffec3d37),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  Text(
                      'ชนิดสัตว์: ${questionObj.signalment?.species}, พันธุ์: ${questionObj.signalment?.breed}',
                      style: kNormalTextStyle),
                  const SizedBox(height: 10),
                  questionObj.tags != []
                      ? Wrap(
                          spacing: 2,
                          runSpacing: 2,
                          children: questionObj.tags!
                              .map(
                                (e) => TagBox(text: e.name),
                              )
                              .toList(),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
