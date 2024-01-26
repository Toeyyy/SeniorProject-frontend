import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/appBar.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/tmpQuestion.dart';
import 'package:frontend/models/examinationPreDefinedObject.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam2_add.dart';
import 'package:frontend/components/backButton.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exams_topics.dart';
import 'package:frontend/UIModels/teacher/predefinedExam_provider.dart';
import 'package:frontend/screensTeacher/PredefinedScreens/editPredefined_exam2_edit_choice.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EditPreDefinedExam2Topic extends StatelessWidget {
  List<String> _topicList = [
    'เพิ่ม Examination',
    'แก้ไข/ลบ Examination',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarTeacher(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                Text(
                  'Examination Predefined List',
                  style: kHeaderTextStyle.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(
                      height: 8,
                    ),
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: Color(0xFFA0E9FF),
                        hoverColor: Color(0xFF42C2FF),
                        title: Text(
                          _topicList[index],
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        onTap: () {
                          if (_topicList[index] == 'เพิ่ม Examination') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPreDefinedExam2Add(),
                              ),
                            );
                          } else if (_topicList[index] ==
                              'แก้ไข/ลบ Examination') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPredefinedExamLab(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
                MyBackButton(myContext: context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
